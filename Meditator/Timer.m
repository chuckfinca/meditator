//
//  TimerTimeKeeper.m
//  Meditator
//
//  Created by Charles Feinn on 7/9/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Timer.h"
@interface Timer ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSInteger intervalsRemaining;
@property (nonatomic) float timerInterval;
@property (nonatomic, readwrite) float secondsRemaining;

@end


@implementation Timer

static Timer *sharedInstance;

+(Timer *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}



#pragma mark - Setup

-(void)startTimerWithDuration:(NSInteger)minutes
{
    self.timerInterval = (float) minutes*60 / NUMBER_OF_TIMER_FIRES;
    self.intervalsRemaining = NUMBER_OF_TIMER_FIRES;
    
    [self startTimer];
}

-(void)startTimer
{
    self.timer = [NSTimer timerWithTimeInterval:self.timerInterval target:self selector:@selector(updateTimerView) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    self.timerIsRunning = YES;
}

#pragma mark - Updating UI

-(void)updateTimerView
{
    self.intervalsRemaining--;
    float percentComplete = (float) self.intervalsRemaining / NUMBER_OF_TIMER_FIRES;
    
    [self.delegate updateTimerViewWithCompletionPercentage:percentComplete];
    
    if(self.intervalsRemaining == 0){
        [self reset];
    }
    
    self.secondsRemaining = (float) self.timerInterval * self.intervalsRemaining;
}


#pragma mark - Timer

-(void)pause
{
    [self reset];
}

-(void)resume
{
    [self startTimer];
}

-(void)reset
{
    [self.timer invalidate];
    self.timer = nil;
    self.timerIsRunning = NO;
}



@end
