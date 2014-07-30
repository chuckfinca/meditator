//
//  SoundEffectPlayer.h
//  Meditator
//
//  Created by Charles Feinn on 7/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundEffectPlayer : NSObject

-(id)initWithURL:(NSURL *)URL;

-(void)playSoundOrVibrate:(BOOL)timerEnded;

@end
