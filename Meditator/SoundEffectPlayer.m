//
//  SoundEffectPlayer.m
//  Meditator
//
//  Created by Charles Feinn on 7/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SoundEffectPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@interface SoundEffectPlayer ()

@property (nonatomic, strong) NSURL *soundUrl;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic) BOOL timerEnded;

@end

@implementation SoundEffectPlayer

-(id)initWithURL:(NSURL *)URL
{
    self = [super init];
    if(self){
        _soundUrl = URL;
    }
    return self;
}

void SoundMuteCheckCompletion(SystemSoundID  ssID,void *clientData)
{
    SoundEffectPlayer *sep = (__bridge SoundEffectPlayer *)clientData;
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:sep.startTime];
    if(elapsedTime < 0.4){
        NSLog(@"mute is on");
        if(sep.timerEnded) {
            for(int i = 1; i < 12; i++){
                [sep performSelector:@selector(vibrate) withObject:sep afterDelay:i*0.3];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Silent Mode Detected" message:@"Unsilence your device to play chimes." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
}

-(void)playSoundOrVibrate:(BOOL)timerEnded
{
    self.timerEnded = timerEnded;
    
    if(self.soundUrl){
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)self.soundUrl,&soundID);
        AudioServicesAddSystemSoundCompletion(soundID, CFRunLoopGetMain(), kCFRunLoopDefaultMode, SoundMuteCheckCompletion, (__bridge_retained void *)self);
        AudioServicesPlaySystemSound(soundID);
        self.startTime = [NSDate date];
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}


-(void)vibrate
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}


@end
