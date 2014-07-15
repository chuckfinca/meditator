//
//  LocalNotificationCreator.m
//  Meditator
//
//  Created by Charles Feinn on 7/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "LocalNotificationScheduler.h"
#import "Timer.h"

#define LOCAL_NOTIFICATIONS_ACTIVE @"LocalNotificationActive"

@implementation LocalNotificationScheduler

+(void)createLocalNotificationIfTimerIsRunning
{
    if([Timer sharedInstance].timerIsActive){
        [[UIApplication sharedApplication] scheduleLocalNotification:[Timer sharedInstance].localNotification];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOCAL_NOTIFICATIONS_ACTIVE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(void)cancelLocalNotificationIfActive
{
    BOOL localNotificationActive = [[NSUserDefaults standardUserDefaults] boolForKey:LOCAL_NOTIFICATIONS_ACTIVE];
    if(localNotificationActive){
        UILocalNotification *localNotification = [Timer sharedInstance].localNotification;
        
        NSDate *now = [NSDate date];
        if([now laterDate:localNotification.fireDate] == now){
            [Timer sharedInstance].timerIsActive = NO;
        }
        
        [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        [Timer sharedInstance].localNotification = nil;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOCAL_NOTIFICATIONS_ACTIVE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
