//
//  GoogleAnalyticsHelper.m
//  mindtimer
//
//  Created by Charles Feinn on 8/13/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "GoogleAnalyticsHelper.h"

#import <GAI.h>
#import "GAIFields.h"
#import "GAIDictionaryBuilder.h"

@implementation GoogleAnalyticsHelper

+(void)logScreenNamed:(NSString *)screenName
{
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    // This screen name value will remain set on the tracker and sent with
    // hits until it is set to a new value or to nil.
    [tracker set:kGAIScreenName value:screenName];
    
    // manual screen tracking
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

+(void)logEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value
{
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category     // Event category (required)
                                                          action:action  // Event action (required)
                                                           label:label          // Event label
                                                           value:value] build]];    // Event value
}

@end
