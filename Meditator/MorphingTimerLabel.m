//
//  MorphingTimerLabel.m
//  Meditator
//
//  Created by Charles Feinn on 7/11/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "MorphingTimerLabel.h"

@implementation MorphingTimerLabel

-(void)setupForTime:(NSInteger)secondsRemaining
{
    NSString *seconds = [NSString stringWithFormat:@"%d",secondsRemaining % 60];
    if([seconds length] == 1){
        seconds = [NSString stringWithFormat:@"0%@",seconds];
    }
    self.text = [NSString stringWithFormat:@"%d:%@ remains",secondsRemaining/60,seconds];
}






@end
