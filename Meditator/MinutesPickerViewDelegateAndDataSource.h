//
//  TimerPickerViewDelegateAndDataSource.h
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PICKER_VIEW_USER_SELECTION @"PickerViewUserSelection"

@interface MinutesPickerViewDelegateAndDataSource : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic) NSInteger previouslySelectedRow;

-(id)initWithOneComponentContainingRows:(NSInteger)numberOfRows;

@end
