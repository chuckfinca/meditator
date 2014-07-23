//
//  Purchaser.m
//  mindtimer
//
//  Created by Charles Feinn on 7/22/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Purchaser.h"
#import "MindTimerIAPHelper.h"
@interface Purchaser ()

@property (nonatomic) BOOL productsLoaded;

@end


@implementation Purchaser

-(UIActionSheet *)actionSheetForProduct:(NSString *)productName withProductsLoaded:(BOOL)productsLoaded
{
    NSString *title;
    NSString *cancelTitle;
    NSString *purchaseTitle;
    
    if(productsLoaded){
        self.productsLoaded = YES;
        
        title = [NSString stringWithFormat:@"\nUNLOCK ALL FEATURES\n\nMeditation Intervals\nBell chime\nDrum chime\nOther chime\nOther chime\nBackground 1\nBackground 2\n\n"];
        purchaseTitle = [[MindTimerIAPHelper sharedInstance] localizedPriceForProductIdentifier:ALL_FEATURES_PRODUCT];
        cancelTitle = @"Cancel";
    } else {
        title = [NSString stringWithFormat:@"To unlock the %@ chime please make sure you have a strong internet connection and try again.",[productName capitalizedString]];
        cancelTitle = @"Ok";
        purchaseTitle = nil;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles:purchaseTitle, nil];
    
    return actionSheet;
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index = %ld",(long)buttonIndex);
    if(buttonIndex == 0 && self.productsLoaded){
        MindTimerIAPHelper *helper = [MindTimerIAPHelper sharedInstance];
        [helper buyProduct:[helper.products firstObject]];
    }
}

@end
