//
//  IntervalCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/16/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "IntervalCell.h"

@interface IntervalCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topToMinutePickerViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minutePickerViewToButtonArrayConstraint;
@end

@implementation IntervalCell

- (void)awakeFromNib
{
    // Initialization code
    [self setCellHeight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setCellHeight
{
    float height = 0;
    
    if(self.buttonArray){
        height += self.topToMinutePickerViewConstraint.constant;
        height += self.buttonHeightConstraint.constant;
        height += self.minutePickerViewToButtonArrayConstraint.constant;
        height += self.minutePickerView.bounds.size.height;
        
    } else {
        height = self.minutePickerView.bounds.size.height;
    }
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

-(void)refreshWithIntervalArray:(NSArray *)intervalsArray andSelectedButtonIndex:(NSInteger)selectedButtonIndex
{
    NSLog(@"intervalsArray = %@",intervalsArray);
    NSInteger numberOfActiveIntervals = 0;
    for(NSNumber *minutes in intervalsArray){
        if([minutes integerValue] > 0){
            numberOfActiveIntervals++;
        }
    }
    
    for(UIButton *button in self.buttonArray){
        button.enabled = YES;
        
        if(button.tag == 2 && numberOfActiveIntervals == 1){
            button.enabled = NO;
        }
        if(button.tag > 2 && numberOfActiveIntervals <= 2){
            button.enabled = NO;
        }
        if(button.tag > 3 && numberOfActiveIntervals <=3){
            button.enabled = NO;
        }
    }
    
    for(UIButton *button in self.buttonArray){
        if(selectedButtonIndex == button.tag){
            button.selected = YES;
            button.alpha = 1.0;
            
        } else {
            button.selected = NO;
            button.alpha = 0.5;
        }
        
        NSNumber *minutes = (NSNumber *)intervalsArray[button.tag];
        [button setTitle:[minutes stringValue] forState:UIControlStateNormal];
        [button setTitle:[minutes stringValue] forState:UIControlStateSelected];
    }
}



@end
