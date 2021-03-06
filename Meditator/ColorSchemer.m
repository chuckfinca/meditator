//
//  ColorSchemer.m
//  wineguide
//
//  Created by Charles Feinn on 11/22/13.
//  Copyright (c) 2013 AppSimple. All rights reserved.
//

#import "ColorSchemer.h"
@interface ColorSchemer ()


@property (nonatomic, strong) NSDictionary *baseColorDictionary;

@property (nonatomic, readwrite) UIColor *baseColor;
@property (nonatomic, readwrite) UIColor *baseColorLight;

@property (nonatomic, readwrite) UIColor *textPrimary;
@property (nonatomic, readwrite) UIColor *textSecondary;
@property (nonatomic, readwrite) UIColor *textPlaceholder;
@property (nonatomic, readwrite) UIColor *clickable;

@property (nonatomic, readwrite) UIColor *white;

@property (nonatomic, readwrite) UIColor *customBackgroundColor;
@property (nonatomic, readwrite) UIColor *gray;

@end

@implementation ColorSchemer

static ColorSchemer *sharedInstance;

+(ColorSchemer *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(UIColor *)baseColor
{
    if(!_baseColor) _baseColor = [UIColor colorWithRed:0.596078F green:0.376471F blue:0.600000F alpha:1.0F]; // original purple
        //[UIColor colorWithRed:0.666667f green:0.470588f blue:0.650980f alpha:1.0]; // original slightly lighter purple
        //[UIColor colorWithRed:0.364706F green:0.129412F blue:0.160784F alpha:1.0F]; // dark red wine
    return _baseColor;
}

-(UIColor *)textPrimary
{
    if(!_textPrimary) _textPrimary = [UIColor colorWithRed:0.133333F green:0.133333F blue:0.133333F alpha:1.0F];
    return _textPrimary;
}

-(UIColor *)textSecondary
{
    if(!_textSecondary) _textSecondary = [UIColor colorWithRed:0.533333F green:0.533333F blue:0.533333F alpha:1.0F];
    return _textSecondary;
}

-(UIColor *)textPlaceholder
{
    if(!_textPlaceholder) _textPlaceholder = [UIColor colorWithRed:0.7F green:0.7F blue:0.7F alpha:1.0F];
        //[UIColor colorWithRed:0.800000F green:0.800000F blue:0.800000F alpha:1.0F];
    return _textPlaceholder;
}

-(UIColor *)clickable
{
    if(!_clickable) _clickable = [UIColor colorWithRed:0.937255F green:0.278431F blue:0.352941F alpha:1.0F]; // red/pink
        //[UIColor colorWithRed:0.207843F green:0.505882F blue:1.000000F alpha:1.0F]; // light blue
        //[UIColor colorWithRed:0.603922F green:0.803922F blue:0.388235F alpha:1.0F]; // light yellow green
        //[UIColor colorWithRed:0.666667f green:0.470588f blue:0.650980f alpha:1.0]; // purple
    return _clickable;
}

-(UIColor *)white
{
    if(!_white) _white = [UIColor whiteColor];
    return _white;
}

-(UIColor *)customBackgroundColor
{
    if(!_customBackgroundColor) _customBackgroundColor = [UIColor colorWithRed:0.985392F green:0.985392F blue:0.985392F alpha:1.0F];
        //[UIColor colorWithRed:1.000000F green:0.956722F blue:0.915948F alpha:1.0F];
        //[UIColor colorWithRed:0.968627F green:0.894118F blue:0.823529F alpha:1.0F];
    return _customBackgroundColor;
}

-(UIColor *)gray
{
    if(!_gray) _gray = [UIColor grayColor];
    return _gray;
}

-(UIColor *)disabled
{
    return [UIColor colorWithRed:0.9F green:0.9F blue:0.9F alpha:1.0F];
}

@end
