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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonArrayToBottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;
@end

@implementation IntervalCell

- (void)awakeFromNib
{
    // Initialization code
    [self.resetButton setImage:[[UIImage imageNamed:@"reset"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    if(self.buttonArray){
        [self.toggleIntervalsButton setImage:[[UIImage imageNamed:@"remove"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    } else {
        [self.toggleIntervalsButton setImage:[[UIImage imageNamed:@"add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
    
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
        height += self.buttonArrayToBottomConstraint.constant;
        height += self.minutePickerView.bounds.size.height;
        
    } else {
        height = self.minutePickerView.bounds.size.height;
    }
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, height);
}

-(void)refreshWithIntervalArray:(NSArray *)intervalsArray andSelectedButtonIndex:(NSInteger)selectedButtonIndex
{
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
        
        NSNumber *minutes = (NSNumber *)intervalsArray[button.tag];
        NSString *title = [minutes stringValue];
        
        if(selectedButtonIndex == button.tag){
            button.selected = YES;
            title = [title stringByAppendingString:@" min"];
            
        } else {
            button.selected = NO;
        }
        
        if(!button.enabled){
            button.alpha = 0.5;
        } else {
            button.alpha = 1.0;
        }
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateSelected];
    }
    
    if([intervalsArray  isEqual: @[@15,@0,@0,@0,@0]]){
        self.resetButton.enabled = NO;
    } else {
        self.resetButton.enabled = YES;
    }
    
    self.intervalLabel.text = [NSString stringWithFormat:@"Interval %d",selectedButtonIndex+1];
}



@end
