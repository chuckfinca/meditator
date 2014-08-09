//
//  InstructionsViewController.m
//  Meditator
//
//  Created by Charles Feinn on 7/14/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "InstructionsViewController.h"
#import "FontThemer.h"

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
    
    self.instructionsTextView.attributedText = [[NSAttributedString alloc] initWithString:@"Meditation Timer is a simple app that enables you to meditate for a length of your chosing.\n\n\nQuick introduction to meditation:\n\n1) Get comfortable! Eliminate unwanted noise, light and distractions from your surroundings.\n\n2) Setup your timer with the duration, chime and other options of your choice. Be sure to choose a duration over which you are likely to be undisturbed.\n\n3) Start meditating. If you don't know how simply allow yourself to focus on your breath. Pay attention to your senses and be attentive to how your body moves and reacts while you breath in and out.\n\nThoughts will arise, and that's ok! Let them come and acknowledge them. Then when you're ready try and return to your breath." attributes:[FontThemer sharedInstance].primaryBodyTextAttributes];
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
