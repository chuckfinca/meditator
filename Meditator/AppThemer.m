//
//  AppThemer.m
//  mindtimer
//
//  Created by Charles Feinn on 8/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "AppThemer.h"
#import "ColorSchemer.h"
#import "FontThemer.h"

@implementation AppThemer

+(void)themeWindow:(UIWindow *)window
{
    [[UINavigationBar appearance] setTitleTextAttributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    window.tintColor = [ColorSchemer sharedInstance].clickable;
}


@end
