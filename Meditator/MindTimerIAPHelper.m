//
//  MindTimerIAPHelper.m
//  mindtimer
//
//  Created by Charles Feinn on 7/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "MindTimerIAPHelper.h"

@implementation MindTimerIAPHelper

+ (MindTimerIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static MindTimerIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"io.appsimple.mindtimer.all",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
