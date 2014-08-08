//
//  MorphingTimerLabel.m
//  Meditator
//
//  Created by Charles Feinn on 7/11/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TimerLabel.h"
#import "FontThemer.h"

@implementation TimerLabel

-(void)setupForTime:(NSInteger)secondsRemaining
{
    NSString *seconds = [NSString stringWithFormat:@"%ld",secondsRemaining % 60];
    if([seconds length] == 1){
        seconds = [NSString stringWithFormat:@"0%@",seconds];
    }
    self.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld:%@ remains",secondsRemaining/60,seconds] attributes:[FontThemer sharedInstance].whiteSubHeadlineTextAttributes];
}






@end
