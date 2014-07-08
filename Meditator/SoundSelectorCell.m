//
//  SoundSelectorCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SoundSelectorCell.h"
@interface SoundSelectorCell ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;

@end

@implementation SoundSelectorCell

-(void)awakeFromNib
{
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)soundSelected:(UIButton *)sender
{
    NSLog(@"tag = %ld",(long)sender.tag);
}





@end
