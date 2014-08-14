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

@property (nonatomic, strong) NSMutableArray *lockImageViewArray;
@property (nonatomic) NSInteger numberOfFreeSelections;

@end

@implementation SelectorCell

-(void)awakeFromNib
{
    // Initialization code
    for(UIButton *button in self.buttonArray){
        button.layer.cornerRadius = 4;
        button.clipsToBounds = YES;
        button.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

-(NSMutableArray *)lockImageViewArray
{
    if(!_lockImageViewArray){
        _lockImageViewArray = [[NSMutableArray alloc] init];
    }
    return _lockImageViewArray;
}


-(void)setupWithSelectedButtonIndex:(NSInteger)selectedButtonIndex numberOfFreeSelections:(NSInteger)numberOfFreeSelections itemsPurchased:(BOOL)itemsPurchased
{
    self.numberOfFreeSelections = numberOfFreeSelections;
    [self refreshWithSelectedButtonIndex:selectedButtonIndex itemsPurchased:itemsPurchased];
}

-(void)refreshWithSelectedButtonIndex:(NSInteger)selectedButtonIndex itemsPurchased:(BOOL)itemsPurchased
{
    for(UIImageView *iv in self.lockImageViewArray){
        [iv removeFromSuperview];
    }
    self.lockImageViewArray = nil;
    
    for(UIButton *button in self.buttonArray){
        if(selectedButtonIndex == button.tag){
            button.selected = YES;
            button.alpha = 1.0;
            button.tintColor = [ColorSchemer sharedInstance].clickable;
            
        } else {
            button.selected = NO;
            button.alpha = 0.2;
            button.tintColor = [ColorSchemer sharedInstance].gray;
            
            if(!itemsPurchased && button.tag > self.numberOfFreeSelections - 1){
                UIImageView *iv = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"lock"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
                iv.tintColor = [ColorSchemer sharedInstance].gray;
                iv.frame = CGRectMake(button.frame.origin.x+button.frame.size.width-iv.bounds.size.width/1.5, button.frame.origin.y+button.frame.size.height-iv.bounds.size.height/1.5, iv.bounds.size.width, iv.bounds.size.height);
                [self addSubview:iv];
                [self.lockImageViewArray addObject:iv];
            }
        }
    }
}




@end
