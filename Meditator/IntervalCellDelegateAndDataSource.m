//
//  IntervalDelegateAndDataSource.m
//  Meditator
//
//  Created by Charles Feinn on 7/16/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "IntervalCellDelegateAndDataSource.h"
#import "FontThemer.h"

#define TIMER_INTERVAL_ARRAY @"TimerIntervalArray"

@interface IntervalCellDelegateAndDataSource ()

@property (nonatomic) NSInteger numberOfRows;
@property (nonatomic, weak) NSArray *buttonArray;

@end

@implementation IntervalCellDelegateAndDataSource

-(id)initWithIntervalButtonArray:(NSArray *)buttonArray andPickerViewContainingRows:(NSInteger)numberOfRows
{
    self = [super init];
    
    if(self){
        _numberOfRows = numberOfRows;
        _buttonArray = buttonArray;
    }
    
    return self;
}


#pragma mark - UIPickerViewDataSource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.numberOfRows;
}


#pragma mark - UIPickerViewDelegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSMutableArray *intervalArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:TIMER_INTERVAL_ARRAY] mutableCopy];
    [intervalArray replaceObjectAtIndex:[self.delegate selectedIntervalIndex] withObject:@(row)];
    
    [self removeUnusedIntervalsFromTheMiddleOfIntervalArray:intervalArray];
    
    [[NSUserDefaults standardUserDefaults] setObject:intervalArray forKey:TIMER_INTERVAL_ARRAY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.delegate refreshIntervalCell];
}

-(void)removeUnusedIntervalsFromTheMiddleOfIntervalArray:(NSMutableArray *)intervalArray
{
    for (NSInteger i = 0; i < [intervalArray count]-1; i++) {
        if([intervalArray[i] integerValue] == 0 && [intervalArray[i+1] integerValue] != 0){
            [intervalArray removeObjectAtIndex:i];
            [intervalArray addObject:@0];
        }
    }
    if([intervalArray[0] isEqual:@0]){
        [intervalArray replaceObjectAtIndex:0 withObject:@1];
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.attributedText = [[NSAttributedString alloc] initWithString:[@(row) stringValue] attributes:[FontThemer sharedInstance].primaryHeadlineTextAttributes];
    [label sizeToFit];
    label.frame = CGRectMake(pickerView.bounds.size.width/2-label.bounds.size.width/2,label.frame.size.height,label.frame.size.width,label.frame.size.height);
    return label;
}



@end
