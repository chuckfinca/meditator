//
//  TimerTimeKeeper.h
//  Meditator
//
//  Created by Charles Feinn on 7/9/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NUMBER_OF_TIMER_FIRES 1000

@protocol TimerViewDelegate

-(void)updateTimerViewWithCompletionPercentage:(float)percentComplete;

@end


@interface Timer : NSObject

@property (nonatomic, weak) id <TimerViewDelegate> delegate;

@property (nonatomic, readonly) float secondsRemaining;
@property (nonatomic) BOOL timerIsRunning;

+(Timer *)sharedInstance;

-(void)startTimerWithDuration:(NSInteger)minutes;
-(void)pause;
-(void)resume;
-(void)reset;

@end
