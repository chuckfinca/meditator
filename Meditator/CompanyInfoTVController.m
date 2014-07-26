//
//  CompanyInfoTVC.m
//  Meditator
//
//  Created by Charles Feinn on 7/18/14.
//  Copyright (c) 2014 AppSimple. All rights reserved.
//

#import "CompanyInfoTVController.h"
#import "AppCell.h"
#import "AppDetailsViewController.h"
#import "MindTimerIAPHelper.h"
#import "AppDictionariesList.h"
#import <MessageUI/MessageUI.h>

@interface CompanyInfoTVController () <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) AppCell *guidedMindCell;

@end

@implementation CompanyInfoTVController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CenterAlignedTextCell" bundle:nil] forCellReuseIdentifier:@"CenterAlignedTextCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Getters & Setters

-(AppCell *)guidedMindCell
{
    if(!_guidedMindCell){
        _guidedMindCell = [[[NSBundle mainBundle] loadNibNamed:@"AppCell" owner:self options:nil] firstObject];
        NSDictionary *dictionary = [AppDictionariesList appDictionaryForID:672076838];
        [_guidedMindCell setupWithAppIconImageName:dictionary[APP_ICON_NAME] name:dictionary[APP_NAME]];
    }
    return _guidedMindCell;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 3;
    } else {
        return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle;
    if(section == 1){
        headerTitle = @"Other apps by AppSimple";
    }
    return headerTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            if(indexPath.row == 0){
                cell.textLabel.text = @"Review in iTunes";
            } else if(indexPath.row == 1){
                cell.textLabel.text =  @"Restore Purchases";
            } else if(indexPath.row == 2){
                cell.textLabel.text =  @"Contact Support";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 1:
            cell = self.guidedMindCell;
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    switch (indexPath.section) {
        case 0:
            height = 60;
            break;
        case 1:
            height = self.guidedMindCell.bounds.size.height;
            break;
            
        default:
            break;
    }
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if(indexPath.row == 0){
                [self showGoingToStoreAlert];
            } else if(indexPath.row == 1){
                [[MindTimerIAPHelper sharedInstance] restoreCompletedTransactions];
            } else if(indexPath.row == 2){
                [self displayMessageSender];
            }
            break;
        case 1:
            [self pushAppVC];
            break;
            
        default:
            break;
    }
}

-(void)showGoingToStoreAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You are about to go to iTunes" message:@"Once there click REVIEWS\nthen WRITE A REVIEW\nto review Mind Timer" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    [alert show];
}

-(void)pushAppVC
{
    AppDetailsViewController *appDetailsVC = [[AppDetailsViewController alloc] initWithNibName:@"AppDetailsViewController" bundle:nil];
    [appDetailsVC setupForAppID:672076838];
    [self.navigationController pushViewController:appDetailsVC animated:YES];
}

-(void)reviewApp
{
    NSLog(@"review in iTunes");
    NSURL *appURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id901569488?at=1l3vcSo"]; // Guided Mind = id672076838?at=1l3vcSo
    [[UIApplication sharedApplication] openURL:appURL];
}

-(void)displayMessageSender
{
    if([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailSender = [[MFMailComposeViewController alloc] init];
        mailSender.mailComposeDelegate = self;
        [mailSender setToRecipients:@[@"support@appsimple.io"]];
        [mailSender setSubject:@"Mind Timer Support"];
        [self presentViewController:mailSender animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to send email" message:@"Please try again with a strong internet connection" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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



#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        [self reviewApp];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
