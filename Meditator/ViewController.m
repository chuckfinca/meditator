//
//  ViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/7/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "ViewController.h"
#import "MinutesPickerViewDelegateAndDataSource.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *minutesPickerView;
@property (nonatomic, strong) MinutesPickerViewDelegateAndDataSource *minutesPickerViewDelegateAndDataSource;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //[self setupPickerView];
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
