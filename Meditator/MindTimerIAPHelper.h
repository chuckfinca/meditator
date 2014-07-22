//
//  MindTimerIAPHelper.h
//  mindtimer
//
//  Created by Charles Feinn on 7/21/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "IAPHelper.h"

#define ALL_FEATURES_PRODUCT @"io.appsimple.mindtimer.all"

@interface MindTimerIAPHelper : IAPHelper

+(MindTimerIAPHelper *)sharedInstance;

@end
