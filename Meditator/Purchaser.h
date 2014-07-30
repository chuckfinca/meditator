//
//  Purchaser.h
//  mindtimer
//
//  Created by Charles Feinn on 7/22/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Purchaser : NSObject <UIActionSheetDelegate>

-(UIActionSheet *)actionSheetForProduct:(NSString *)productName withSoundPreview:(NSString *)soundPreviewName andProductsLoaded:(BOOL)productsLoaded;

@end
