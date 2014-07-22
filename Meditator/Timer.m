//
//  TimerTimeKeeper.m
//  Meditator
//
//  Created by Charles Feinn on 7/9/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "Timer.h"
#import "SoundEffectPlayer.h"

@interface Timer ()

@property (nonatomic, strong) NSDate *lastResumedTime;
@property (nonatomic, strong) CADisplayLink *displayLinkTimer;
@property (nonatomic, strong) NSString *soundEffectFileName;
@property (nonatomic, readwrite) NSMutableArray *chimeTimesArray;
@property (nonatomic) NSInteger intervals;
@property (nonatomic, strong) NSURL *soundEffectURL;

@property (nonatomic) NSInteger totalTime;

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

#pragma mark - Getters & Setters

-(NSString *)soundEffectFileName
{
    if(!_soundEffectFileName){
        _soundEffectFileName = UILocalNotificationDefaultSoundName;
    }
    return _soundEffectFileName;
}

#pragma mark - Setup

-(void)setupTimerWithIntervalArray:(NSArray *)intervalArray andSoundEffectName:(NSString *)soundEffectName
{
    NSMutableArray *chimeTimesArray = [[NSMutableArray alloc] init];
    NSInteger totalTime = 0;
    
    for (NSNumber *minutes in intervalArray) {
        
        if([minutes integerValue] == 0){
            break;
        }
        
        
        
        //FOR TESTING
        NSInteger intervalDurationInSeconds = [minutes integerValue] * 60;
        if(intervalDurationInSeconds == 60) intervalDurationInSeconds = 10;
        
        
        totalTime += intervalDurationInSeconds;
        [chimeTimesArray addObject:@(totalTime)];
    }
    
    self.totalTime = totalTime;
    self.chimeTimesArray = chimeTimesArray;
    self.intervals = [chimeTimesArray count];
    
    [self setupSoundEffect:soundEffectName];
}

-(void)setupSoundEffect:(NSString *)soundEffectName
{
    if([soundEffectName isEqualToString:UILocalNotificationDefaultSoundName]){
        self.soundEffectFileName = soundEffectName;
        self.soundEffectURL = nil;
        
    } else {
        self.soundEffectFileName = [NSString stringWithFormat:@"%@.%@",soundEffectName, @"aif"];
        self.soundEffectURL = [[NSBundle mainBundle] URLForResource:soundEffectName withExtension:@"aif"];
    }
}

-(void)createLocalNotifications
{
    self.localNotificationsArray = nil;
    
    NSMutableArray *localNotificationsArray = [[NSMutableArray alloc] init];
    
    for(NSNumber *number in self.chimeTimesArray){
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeInterval:[number floatValue] sinceDate:self.lastResumedTime];
        localNotification.soundName = self.soundEffectFileName;
        
        NSInteger intervalIndex = [self.chimeTimesArray indexOfObject:number];
        if(intervalIndex == [self.chimeTimesArray count]-1){
            localNotification.alertBody = @"Meditation Complete";
            localNotification.alertAction = @"Ok";
        } else {
            localNotification.alertBody = [NSString stringWithFormat:@"Interval %ld Complete",(long)(self.intervals - intervalIndex)];
        }
        [localNotificationsArray addObject:localNotification];
    }
    
    self.localNotificationsArray = localNotificationsArray;
}

#pragma mark - Updating UI

-(void)updateTimerView
{
    float totalRemainingTime = [[self.chimeTimesArray lastObject] integerValue];
    NSTimeInterval elapsedTime = [self secondsSinceLastStart];
    
    float percentComplete = (float)(totalRemainingTime - elapsedTime) / self.totalTime;
    [self.delegate updateTimerView:percentComplete];
    
    for(NSNumber *number in self.chimeTimesArray){
        if([number integerValue] - elapsedTime < 0){
            
            [self soundTimer];
        }
    }
    
    if([[self.chimeTimesArray firstObject] integerValue] - elapsedTime <= 0){
        if([self.chimeTimesArray count] > 0){
            [self.chimeTimesArray removeObjectAtIndex:0];
            self.intervals--;
        } else {
            [self.delegate stopTimer];
        }
    }
}



#pragma mark - Timer

-(void)start
{
    self.displayLinkTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimerView)];
    self.displayLinkTimer.frameInterval = [[self.chimeTimesArray lastObject] integerValue] < 300 ? 5 : 20;
    
    [self.displayLinkTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.lastResumedTime = [NSDate date];
    self.timerIsActive = YES;
}

-(void)pause
{
    if(self.timerIsActive){
        NSMutableArray *newChimeTimesArray = [[NSMutableArray alloc] init];
        for(NSNumber *number in self.chimeTimesArray){
            float newChimeTimeFromNextStart = [number floatValue] - [self secondsSinceLastStart];
            
            if(newChimeTimeFromNextStart > 0){
                [newChimeTimesArray addObject:@(newChimeTimeFromNextStart)];
            }
        }
        self.chimeTimesArray = newChimeTimesArray;

        
        [self reset];
    }
}

-(NSTimeInterval)secondsSinceLastStart
{
    return [[NSDate date] timeIntervalSinceDate:self.lastResumedTime];
}

-(void)reset
{
    [self.displayLinkTimer invalidate];
    self.displayLinkTimer = nil;
    self.timerIsActive = NO;
}

-(void)soundTimer
{
    SoundEffectPlayer *player = [[SoundEffectPlayer alloc] initWithURL:self.soundEffectURL];
    [player playSoundOrVibrate];
}










@end
