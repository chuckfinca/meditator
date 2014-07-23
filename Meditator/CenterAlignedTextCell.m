//
//  CenterAlignedTextCell.m
//  mindtimer
//
//  Created by Charles Feinn on 7/22/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "CenterAlignedTextCell.h"
@interface CenterAlignedTextCell ()

@property (weak, nonatomic) IBOutlet UILabel *centerAlignedTitleLabel;

@end


@implementation CenterAlignedTextCell

-(void)setupWithTitle:(NSString *)title
{
    NSDictionary *attributes = @{};
    [self.centerAlignedTitleLabel setAttributedText:[[NSAttributedString alloc] initWithString:title attributes:attributes]];
}

@end
