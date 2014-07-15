//
//  TimerViewController.h
//  Meditator
//
//  Created by Charles Feinn on 7/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerViewController : UIViewController

-(void)setTimerWithSound:(NSString *)soundEffectName extension:(NSString *)soundEffectExtension andDuration:(NSInteger)minutes;

@end
