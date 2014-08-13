//
//  GoogleAnalyticsHelper.h
//  mindtimer
//
//  Created by Charles Feinn on 8/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleAnalyticsHelper : NSObject

+(void)logScreenNamed:(NSString *)screenName;
+(void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;

@end
