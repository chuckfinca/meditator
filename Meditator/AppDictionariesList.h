//
//  AppDictionariesList.h
//  mindtimer
//
//  Created by Charles Feinn on 7/24/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_NAME @"name"
#define APP_ICON_NAME @"iconName"
#define APP_SCREENSHOT_NAME @"screenShotName"
#define APP_DESCRIPTION @"appDescription"
#define APP_SHORT_NAME @"shortName"

@interface AppDictionariesList : NSObject

+(NSDictionary *)appDictionaryForID:(NSInteger)appID;

@end
