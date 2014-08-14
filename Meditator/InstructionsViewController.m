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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
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
    
    NSDictionary *attributes = [FontThemer sharedInstance].primaryBodyTextAttributes;
    
    [self.imageView setImage:[[UIImage imageNamed:@"timer"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    
    NSString *heading = @"Mind Timer is a simple app that keeps track of the time while you meditate.\n\n\n";
    NSString *boldText = @"Introduction to meditation:";
    NSRange boldTextRange = NSMakeRange([heading length], [boldText length]);
    
    NSString *fullText = [NSString stringWithFormat:@"%@%@\n\n1) Get comfortable! Eliminate unwanted noise, light and distractions from your surroundings.\n\n2) Setup your timer with a duration, chime and other options of your choice. Be sure to choose a duration over which you are likely to be undisturbed.\n\n3) Start meditating. If you don't know how, simply focus on your breath. Pay attention to your senses and be attentive to how your body moves and reacts while you breath in and out.\n\nThoughts will arise and that's ok. Let them come, acknowledge them. Then when you're ready try and return to your breath.\n\nFor best results meditate daily.",heading,boldText];
    
    self.instructionsTextView.attributedText = [[NSAttributedString alloc] initWithString:fullText attributes:attributes];
    [self.instructionsTextView.textStorage addAttribute:NSFontAttributeName value:[FontThemer sharedInstance].headline range:boldTextRange];
    
    self.textViewHeightConstraint.constant = [self.instructionsTextView sizeThatFits:CGSizeMake(self.instructionsTextView.bounds.size.width, FLT_MAX)].height;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Google Analytics
    self.screenName = @"Instructions Screen";
}

@end
