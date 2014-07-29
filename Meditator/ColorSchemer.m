//
//  ColorSchemer.m
//  mindtimer
//
//  Created by Charles Feinn on 7/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ColorSchemer.h"

@implementation ColorSchemer

static ColorSchemer *sharedInstance;

+(ColorSchemer *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(UIColor *)tintColor
{
    return [UIColor colorWithRed:0.937255F green:0.278431F blue:0.352941F alpha:1.0F];
}







@end
