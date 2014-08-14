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
    
    for(UIButton *button in self.buttonArray){
        if(button.tag == 0){
            [button setImage:[[UIImage imageNamed:@"vibrate"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        } else if(button.tag == 1){
            [button setImage:[[UIImage imageNamed:@"tingshas"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        } else if(button.tag == 2){
            [button setImage:[[UIImage imageNamed:@"gong"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        } else if(button.tag == 3){
            [button setImage:[[UIImage imageNamed:@"bell"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        } else {
            [button setImage:[[UIImage imageNamed:@"bowl"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        }
    }
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:@"times" attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
    self.timesLabel.attributedText = attributedTitle;
}

@end