//
//  TimerPickerViewDelegateAndDataSource.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "MinutesPickerViewDelegateAndDataSource.h"
@interface MinutesPickerViewDelegateAndDataSource ()

@property (nonatomic) NSInteger numberOfRows;

@end

@implementation MinutesPickerViewDelegateAndDataSource

-(id)initWithOneComponentContainingRows:(NSInteger)numberOfRows
{
    self = [super init];
    
    if(self){
        _numberOfRows = numberOfRows;
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
    return [@(row+1) stringValue];
}

@end
