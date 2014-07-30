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
@property (nonatomic, strong) NSString *soundPreviewName;

@end


@implementation Purchaser

-(UIActionSheet *)actionSheetForProduct:(NSString *)productName withSoundPreview:(NSString *)soundPreviewName andProductsLoaded:(BOOL)productsLoaded
{
    NSString *title;
    NSString *cancelTitle;
    NSString *purchaseTitle;
    
    if(productsLoaded){
        self.productsLoaded = YES;
        
        title = [NSString stringWithFormat:@"\nUNLOCK ALL FEATURES\n\nMeditation Intervals\nBell Chime\nDrum Chime\nOther Chime\nOther Chime\nBackground 1\nBackground 2\n\n"];
        purchaseTitle = [[MindTimerIAPHelper sharedInstance] localizedPriceForProductIdentifier:ALL_FEATURES_PRODUCT];
        cancelTitle = @"Cancel";
    } else {
        title = [NSString stringWithFormat:@"To unlock %@ please make sure you have a strong internet connection and try again.",productName];
        cancelTitle = @"Ok";
        purchaseTitle = nil;
    }
    
    NSString *preview;
    if(soundPreviewName){
        preview = @"Preview Chime";
        self.soundPreviewName = soundPreviewName;
    }
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:cancelTitle destructiveButtonTitle:nil otherButtonTitles:purchaseTitle, preview,nil];
    
    return actionSheet;
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"index = %ld",(long)buttonIndex);
    if(buttonIndex == 0 && self.productsLoaded){
        MindTimerIAPHelper *helper = [MindTimerIAPHelper sharedInstance];
        [helper buyProduct:[helper.products firstObject]];
        
    } else if(buttonIndex == 1 && self.soundPreviewName){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlaySound" object:self.soundPreviewName];
        self.soundPreviewName = nil;
    }
}

@end
