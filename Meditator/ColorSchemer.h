//
//  ColorSchemer.h
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorSchemer : NSObject

+(ColorSchemer *)sharedInstance;

@property (nonatomic, readonly) UIColor *textPrimary;
@property (nonatomic, readonly) UIColor *textSecondary;
@property (nonatomic, readonly) UIColor *textPlaceholder;
@property (nonatomic, readonly) UIColor *clickable;

@property (nonatomic, readonly) UIColor *baseColor;
@property (nonatomic, readonly) UIColor *baseColorLight;

@property (nonatomic, readonly) UIColor *white;

@property (nonatomic, readonly) UIColor *customBackgroundColor;
@property (nonatomic, readonly) UIColor *gray;

@property (nonatomic, readonly) UIColor *disabled;


@end
