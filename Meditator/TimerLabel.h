//
//  MorphingTimerLabel.h
//  Meditator
//
//  Created by Charles Feinn on 7/11/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimerLabel : UILabel

-(void)setupForTime:(NSInteger)secondsRemaining;

@end
