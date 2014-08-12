//
//  SavedStateTabBarController.m
//  mindtimer
//
//  Created by Charles Feinn on 8/11/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SavedStateTabBarController.h"

#define TAB_BAR_CONTROLLER_INDEX @"TabBarControllerIndex"

@implementation SavedStateTabBarController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedIndex = [[NSUserDefaults standardUserDefaults] integerForKey:TAB_BAR_CONTROLLER_INDEX];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    [[NSUserDefaults standardUserDefaults] setInteger:[tabBar.items indexOfObject:item] forKey:TAB_BAR_CONTROLLER_INDEX];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
