//
//  IAPHelper.h
//  Meditator
//
//  Created by Charles Feinn on 7/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

@property (nonatomic, strong) NSArray *products;
-(void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

-(id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
-(void)buyProduct:(SKProduct *)product;
-(BOOL)productPurchased:(NSString *)productIdentifier;
-(void)restoreCompletedTransactions;

@end
