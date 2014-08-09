//
//  ChimeSelectorCell.m
//  mindtimer
//
//  Created by Charles Feinn on 8/8/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ChimeSelectorCell.h"
#import "FontThemer.h"

@interface ChimeSelectorCell ()

@property (weak, nonatomic) IBOutlet UILabel *timesLabel;

@end

@implementation ChimeSelectorCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"times" attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    self.timesLabel.attributedText = attributedTitle;
}

@end