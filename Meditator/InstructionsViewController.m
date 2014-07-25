//
//  InstructionsViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@property (strong, nonatomic) IBOutlet UITextView *instructionsTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end

@implementation InstructionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.instructionsTextView.text = @"Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate. Meditation Timer is a simple app that allows you to take time for your self to meditate.";
    self.textViewHeightConstraint.constant = [self.instructionsTextView sizeThatFits:CGSizeMake(self.instructionsTextView.bounds.size.width, FLT_MAX)].height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
