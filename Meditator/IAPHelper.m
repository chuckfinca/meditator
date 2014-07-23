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
    NSLog(@"SKRequest didFailWithError %@; code: %ld",error.localizedDescription,(long)error.code);
    self.productsRequest = nil;
    self.completionHandler(NO, nil);
    self.completionHandler = nil;
    
    [self handleError:error];
}


#pragma mark - SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
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
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self stopActivityIndicator];
}

-(void)failedTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"failedTransaction...");
    if(transaction.error.code != SKErrorPaymentCancelled){
        NSLog(@"Transaction error: %@; code: %ld",transaction.error.localizedDescription,(long)transaction.error.code);
        [self handleError:transaction.error];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self stopActivityIndicator];
}

-(void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    NSLog(@"restoreTransaction...");
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    [self stopActivityIndicator];
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
    // Notify user a UIAlert view
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"restoreCompletedTransactionsFailedWithError %@; code: %ld",error.localizedDescription,(long)error.code);
    [self handleError:error];
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



-(void)handleError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error.localizedDescription message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
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