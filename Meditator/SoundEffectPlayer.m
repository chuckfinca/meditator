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

-(void)playSoundOrVibrate
{
    if(self.soundUrl){
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)self.soundUrl,&soundID);
        AudioServicesPlaySystemSound(soundID);
    } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}







@end
