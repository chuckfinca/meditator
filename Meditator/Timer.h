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

-(void)updateTimerView:(float)percentRemaining;

@end


@interface Timer : NSObject

@property (nonatomic, weak) id <TimerViewDelegate> delegate;

@property (nonatomic, readonly) NSInteger remainingTimerDuration;
@property (nonatomic) BOOL timerIsActive;
@property (nonatomic, strong) UILocalNotification *localNotification;
@property (nonatomic, strong) NSString *soundEffectName;

+(Timer *)sharedInstance;

-(void)setupTimerWithDuration:(NSInteger)seconds;
-(void)start;
-(void)pause;
-(void)reset;

@end
