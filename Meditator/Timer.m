//
//  TimerTimeKeeper.m
//  Meditator
//
//  Created by Charles Feinn on 7/9/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Timer.h"

@interface Timer ()

@property (nonatomic, strong) NSDate *lastResumedTime;

@property (nonatomic, strong) CADisplayLink *displayLinkTimer;

@property (nonatomic) NSInteger totalTimerDuration;
@property (nonatomic) NSInteger remainingTimerDuration;

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

-(void)startTimerWithDuration:(NSInteger)seconds
{
    self.totalTimerDuration = seconds;
    self.remainingTimerDuration = seconds;
    
    [self startTimer];
}

-(void)startTimer
{
    self.displayLinkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimerView)];
    
    self.displayLinkTimer.frameInterval = self.totalTimerDuration < 300 ? 5 : 20;
    
    [self.displayLinkTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    self.lastResumedTime = [NSDate date];
    self.timerIsRunning = YES;
}

#pragma mark - Updating UI

-(void)updateTimerView
{
    NSTimeInterval secondsSinceLastResume = [[NSDate date] timeIntervalSinceDate:self.lastResumedTime];
    
    float percentComplete = (float)(self.remainingTimerDuration - secondsSinceLastResume) / self.totalTimerDuration;
    [self.delegate updateTimerView:percentComplete];
}


#pragma mark - Timer

-(void)pause
{
    if(self.timerIsRunning){
        NSInteger secondsSinceLastResume = [[NSDate date] timeIntervalSinceDate:self.lastResumedTime];
        self.remainingTimerDuration = self.remainingTimerDuration - secondsSinceLastResume;
        
        if(self.remainingTimerDuration < 0) {
            self.remainingTimerDuration = 0;
        }
        [self reset];
    }
}

-(void)resume
{
    if(self.remainingTimerDuration > 0){
        [self startTimer];
    }
}

-(void)reset
{
    [self.displayLinkTimer invalidate];
    self.displayLinkTimer = nil;
    self.timerIsRunning = NO;
}







@end
