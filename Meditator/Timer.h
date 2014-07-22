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
-(void)stopTimer;

@end


@interface Timer : NSObject

+(Timer *)sharedInstance;

@property (nonatomic, weak) id <TimerViewDelegate> delegate;

@property (nonatomic) BOOL timerIsActive;
@property (nonatomic, readonly) NSMutableArray *chimeTimesArray;

-(void)setupTimerWithIntervalArray:(NSArray *)intervalArray andSoundEffectName:(NSString *)soundEffectName;

-(void)start;
-(void)pause;
-(void)reset;

-(NSTimeInterval)secondsSinceLastStart;

@property (nonatomic, strong) NSArray *localNotificationsArray;
-(void)createLocalNotifications;

@end
