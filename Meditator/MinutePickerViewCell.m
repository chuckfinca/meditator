//
//  MinutePickerViewCell.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "MinutePickerViewCell.h"
#import "MinutesPickerViewDelegateAndDataSource.h"

@interface MinutePickerViewCell ()

@property (weak, nonatomic) IBOutlet UIPickerView *minutesPickerView;
@property (nonatomic, strong) MinutesPickerViewDelegateAndDataSource *minutesPickerViewDelegateAndDataSource;

@end

@implementation MinutePickerViewCell

-(id)init
{
    self = [super init];
    if(self){
        [self setupPickerView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self setupPickerView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupPickerView
{
    self.minutesPickerViewDelegateAndDataSource = [[MinutesPickerViewDelegateAndDataSource alloc] initWithOneComponentContainingRows:90];
    self.minutesPickerView.delegate = _minutesPickerViewDelegateAndDataSource;
    self.minutesPickerView.dataSource = _minutesPickerViewDelegateAndDataSource;
    
    [self.minutesPickerView selectRow:self.minutesPickerViewDelegateAndDataSource.previouslySelectedRow inComponent:0 animated:NO];
    
    self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.minutesPickerView.bounds.size.height);
}











@end
