//
//  MorphingTimerLabel.h
//  Meditator
//
//  Created by Charles Feinn on 7/11/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "TOMSMorphingLabel.h"

@interface MorphingTimerLabel : TOMSMorphingLabel

-(void)setupForTime:(NSInteger)secondsRemaining;

@end
