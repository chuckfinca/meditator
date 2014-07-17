//
//  IntervalDelegateAndDataSource.m
//  Meditator
//
//  Created by Charles Feinn on 7/16/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "IntervalCellDelegateAndDataSource.h"

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

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [@(row) stringValue];
}

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





@end
