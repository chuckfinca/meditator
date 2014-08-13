//
//  TimerViewController.h
//  Meditator
//
//  Created by Charles Feinn on 7/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "GAITrackedViewController.h"

@interface TimerViewController : GAITrackedViewController

-(void)setTimerIntervalArray:(NSArray *)intervalArray withSoundEffect:(NSString *)soundEffectName numberOfChimes:(NSInteger)numberOfChimes andBackground:(NSString *)backgroundName;

@end
