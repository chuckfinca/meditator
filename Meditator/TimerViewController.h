//
//  TimerViewController.h
//  Meditator
//
//  Created by Charles Feinn on 7/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController

@property (nonatomic) float secondsRemaining; // to be read by AppDelegate when app goes into the background

-(void)setTimerDuration:(NSInteger)minutes;
-(void)reset;

@end
