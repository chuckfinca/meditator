//
//  IAPHelper.m
//  Meditator
//
//  Created by Charles Feinn on 7/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "IAPHelper.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";

@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) NSSet *productIdentifiers;
@property (nonatomic, strong) NSMutableSet *purchasedProductIdentifiers;
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, strong) RequestProductsCompletionHandler completionHandler;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UILabel *activityIndicatorLabel;

@end


@implementation IAPHelper

-(id)initWithProductIdentifiers:(NSSet *)productIdentifiers
{
    self = [super init];
    if(self){
        _productIdentifiers = productIdentifiers;
        
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
                
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

#pragma mark - Getters & Setters

-(UIActivityIndicatorView *)activityIndicator
{
    if(!_activityIndicator){
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _activityIndicator;
}

-(UILabel *)activityIndicatorLabel
{
    if(!_activityIndicatorLabel){
        _activityIndicatorLabel = [[UILabel alloc] init];
        _activityIndicatorLabel.layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;
        _activityIndicatorLabel.layer.cornerRadius = 4;
        _activityIndicatorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _activityIndicatorLabel;
}

-(void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler
{
    self.completionHandler = [completionHandler copy];
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:self.productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

-(BOOL)productPurchased:(NSString *)productIdentifier
{
    return [self.purchasedProductIdentifiers containsObject:productIdentifier];
}

-(void)buyProduct:(SKProduct *)product
{
    NSLog(@"Buying %@",product.productIdentifier);
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    [self startActivityIndicatorForAction:@"Purchasing..."];
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.productsRequest = nil;
    
    NSArray *skProducts = response.products;
    for (SKProduct *skProduct in skProducts){
        NSLog(@"Found product: %@ %@ %0.2f", skProduct.productIdentifier,skProduct.localizedTitle,skProduct.price.floatValue);
    }
    
    if(self.completionHandler){
        self.products = skProducts;
        self.completionHandler(YES, skProducts);
        self.completionHandler = nil;
    }
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    self.productsRequest = nil;
    self.completionHandler(NO, nil);
    self.completionHandler = nil;
    
    [self handleError:error forActivity:@"Product Request Failed"];
}


#pragma mark - SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSLog(@"queue = %@",queue);
    NSLog(@"transactions = %@",transactions);
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"SKPaymentTransactionStatePurchasing");
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

-(void)completeTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"completeTransaction...");
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [self stopActivityIndicator];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)failedTransaction:(SKPaymentTransaction *)transaction
{
    [self stopActivityIndicator];
    [self handleError:transaction.error forActivity:@"Failed Transaction"];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [self stopActivityIndicator];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

-(void)provideContentForProductIdentifier:(NSString *)productIdentifier
{
    [self.purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier];
}


#pragma mark - Restore Transactions

-(void)restoreCompletedTransactions
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    [self startActivityIndicatorForAction:@"Restoring..."];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished...");
    for(SKPaymentTransaction *transaction in queue.transactions){
        NSLog(@"restored %@",transaction.payment.productIdentifier);
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchases Restored" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [self handleError:error forActivity:@"Restore Transactions"];
    [self stopActivityIndicator];
}

-(NSString *)localizedPriceForProductIdentifier:(NSString *)productIdentifier
{
    SKProduct *product;
    for(SKProduct *p in self.products){
        if([p.productIdentifier isEqualToString:productIdentifier]){
            product = p;
        }
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:product.priceLocale];
    return [numberFormatter stringFromNumber:product.price];
}



-(void)handleError:(NSError *)error forActivity:(NSString *)activity
{
    NSString *errorType;
    switch (error.code) {
        case 0:
            errorType = @"SKErrorUnknown";
            break;
        case 1:
            errorType = @"SKErrorClientInvalid";
            break;
        case 2:
            errorType = @"SKErrorPaymentCancelled";
            break;
        case 3:
            errorType = @"SKErrorPaymentInvalid";
            break;
        case 4:
            errorType = @"SKErrorPaymentNotAllowed";
            break;
        case 5:
            errorType = @"SKErrorStoreProductNotAvailable";
            break;
        default:
            break;
    }
    
    NSString *errorBody = [NSString stringWithFormat:@"Please try again with a strong connection.\n\n(%@)",errorType];
    
    if(error.code != 2){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:errorBody
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    NSLog(@"%@ - Error: %@ - %@",activity,error.localizedDescription,errorType);
}


#pragma mark - UIActivityIndicator

-(void)startActivityIndicatorForAction:(NSString *)action
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor colorWithWhite:1 alpha:0.9]};
    [self.activityIndicatorLabel setAttributedText:[[NSAttributedString alloc] initWithString:action attributes:attributes]];
    [self.activityIndicatorLabel sizeToFit];
    self.activityIndicatorLabel.bounds = CGRectMake(0, 0, 2*self.activityIndicatorLabel.bounds.size.width, 2*self.activityIndicatorLabel.bounds.size.height);
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    self.activityIndicatorLabel.center = window.center;
    [window addSubview:self.activityIndicatorLabel];
    
    [self.activityIndicatorLabel addSubview:self.activityIndicator];
    self.activityIndicator.frame = CGRectMake(self.activityIndicatorLabel.bounds.size.width/8-self.activityIndicator.bounds.size.width/2, self.activityIndicatorLabel.bounds.size.height/2-self.activityIndicator.bounds.size.height/2, self.activityIndicator.bounds.size.width, self.activityIndicator.bounds.size.height);
    
    [self.activityIndicator startAnimating];
}

-(void)stopActivityIndicator
{
    [self.activityIndicatorLabel removeFromSuperview];
    [self.activityIndicator stopAnimating];
    self.activityIndicator = nil;
    self.activityIndicatorLabel = nil;
}

@end
