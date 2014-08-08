//
//  FontThemer.m
//  Corkie
//
//  Created by Charles Feinn on 1/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "FontThemer.h"
#import "ColorSchemer.h"

@interface FontThemer ()

@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSString *boldFontName;

@end

@implementation FontThemer

static FontThemer *sharedInstance;

+(FontThemer *)sharedInstance
{
    //dispatch_once executes a block object only once for the lifetime of an application.
    static dispatch_once_t executesOnlyOnce;
    dispatch_once (&executesOnlyOnce, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.fontName = @"AmericanTypewriter";
        sharedInstance.boldFontName = @"AmericanTypewriter-Bold";
    });
    return sharedInstance;
}

-(UIFont *)headline
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleHeadline];
    return [UIFont fontWithName:self.boldFontName size:[fontDescriptor pointSize]];
}

-(UIFont *)subHeadline
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleSubheadline];
    return [UIFont fontWithName:self.fontName size:[fontDescriptor pointSize]];
}

-(UIFont *)body
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    return [UIFont fontWithName:self.fontName size:[fontDescriptor pointSize]];
}

-(UIFont *)caption1
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption1];
    return [UIFont fontWithName:self.fontName size:[fontDescriptor pointSize]];
}

-(UIFont *)caption2
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleCaption2];
    return [UIFont fontWithName:self.fontName size:[fontDescriptor pointSize]];
}

-(UIFont *)footnote
{
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor preferredFontDescriptorWithTextStyle:UIFontTextStyleFootnote];
    return [UIFont fontWithName:self.fontName size:[fontDescriptor pointSize]];
}



-(NSDictionary *)primaryHeadlineTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary, NSFontAttributeName : self.headline};
}

-(NSDictionary *)primaryBodyTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary, NSFontAttributeName : self.body};
}

-(NSDictionary *)primaryFootnoteTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary, NSFontAttributeName : self.footnote};
}

-(NSDictionary *)primarySubHeadlineTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textPrimary, NSFontAttributeName : self.subHeadline};
}



-(NSDictionary *)secondaryHeadlineTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : self.headline};
}
-(NSDictionary *)secondaryBodyTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : self.body};
}

-(NSDictionary *)secondaryCaption1TextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : self.caption1};
}

-(NSDictionary *)secondaryFootnoteTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].textSecondary, NSFontAttributeName : self.footnote};
}

-(NSDictionary *)linkBodyTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].clickable, NSFontAttributeName : self.body};
}


-(NSDictionary *)baseHeadlineTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].baseColor, NSFontAttributeName : self.headline};
}

-(NSDictionary *)linkCaption1TextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].clickable, NSFontAttributeName : self.caption1};
}


-(NSDictionary *)whiteSubHeadlineTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].customWhite, NSFontAttributeName : self.subHeadline};
}

-(NSDictionary *)whiteHeadlineTextAttributes
{
    return @{NSForegroundColorAttributeName : [ColorSchemer sharedInstance].customWhite, NSFontAttributeName : self.headline};
}

@end
