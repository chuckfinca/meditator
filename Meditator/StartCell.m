//
//  StartCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/17/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "StartCell.h"
@interface StartCell ()

@end


@implementation StartCell

- (void)awakeFromNib
{
    // Initialization code
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline]};
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@"Start Timer" attributes:attributes];
    [self.startButton setAttributedTitle:attributedString forState: UIControlStateNormal];
    self.startButton.titleLabel.textColor = [UIColor whiteColor];
    self.startButton.layer.backgroundColor = self.tintColor.CGColor;
    self.startButton.layer.cornerRadius = 4;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
