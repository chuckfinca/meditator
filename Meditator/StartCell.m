//
//  StartCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "StartCell.h"
#import "ColorSchemer.h"
#import "FontThemer.h"


@implementation StartCell

- (void)awakeFromNib
{
    // Initialization code
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Start Timer" attributes:[FontThemer sharedInstance].whiteHeadlineTextAttributes];
    [self.startButton setAttributedTitle:attributedString forState: UIControlStateNormal];
}


@end
