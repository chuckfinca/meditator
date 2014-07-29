//
//  StartCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "StartCell.h"
#import "ColorSchemer.h"


@implementation StartCell

- (void)awakeFromNib
{
    // Initialization code
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Start Timer" attributes:attributes];
    [self.startButton setAttributedTitle:attributedString forState: UIControlStateNormal];
    
    self.tintColor = [ColorSchemer sharedInstance].tintColor;
}


@end
