//
//  ColorSchemer.h
//  mindtimer
//
//  Created by Charles Feinn on 7/28/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorSchemer : NSObject

+(ColorSchemer *)sharedInstance;

-(UIColor *)tintColor;

@end
