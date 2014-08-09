//
//  SoundSelectorCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "SelectorCell.h"
#import "ColorSchemer.h"

@interface SelectorCell ()

@end

@implementation SelectorCell

-(void)awakeFromNib
{
    // Initialization code
    for(UIButton *button in self.buttonArray){
        button.layer.cornerRadius = 4;
        button.clipsToBounds = YES;
        button.contentMode = UIViewContentModeScaleAspectFill;
    }
}

-(void)refreshWithSelectedButtonIndex:(NSInteger)selectedButtonIndex
{
    for(UIButton *button in self.buttonArray){
        if(selectedButtonIndex == button.tag){
            button.selected = YES;
            button.alpha = 1.0;
            button.tintColor = [ColorSchemer sharedInstance].clickable;
            
        } else {
            button.selected = NO;
            button.alpha = 0.2;
            button.tintColor = [ColorSchemer sharedInstance].gray;
        }
    }
}




@end
