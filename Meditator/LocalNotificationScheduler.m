//
//  LocalNotificationCreator.m
//  Meditator
//
//  Created by Charles Feinn on 7/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "LocalNotificationScheduler.h"
#import "Timer.h"

#define LOCAL_NOTIFICATIONS_ACTIVE @"LocalNotificationsActive"

@implementation LocalNotificationScheduler

+(void)createLocalNotificationIfTimerIsRunning
{
    Timer *timer = [Timer sharedInstance];
    if(timer.timerIsActive){
        [timer createLocalNotifications];
        
        for(UILocalNotification *localNotification in timer.localNotificationsArray){
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LOCAL_NOTIFICATIONS_ACTIVE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(void)cancelLocalNotificationIfActive
{
    BOOL localNotificationsActive = [[NSUserDefaults standardUserDefaults] boolForKey:LOCAL_NOTIFICATIONS_ACTIVE];
    
    if(localNotificationsActive){
        for(UILocalNotification *localNotification in [Timer sharedInstance].localNotificationsArray){
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
        
        NSDate *now = [NSDate date];
        UILocalNotification *lastLocalNotification = [[Timer sharedInstance].localNotificationsArray lastObject];
        NSDate *finalFireDate = lastLocalNotification.fireDate;
        
        if([now laterDate:finalFireDate] == now){
            [Timer sharedInstance].timerIsActive = NO;
        }
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:LOCAL_NOTIFICATIONS_ACTIVE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
