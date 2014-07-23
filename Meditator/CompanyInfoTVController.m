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
#import "CenterAlignedTextCell.h"
#import "MindTimerIAPHelper.h"

@interface CompanyInfoTVController () <SKStoreProductViewControllerDelegate>

@property (nonatomic, strong) AppCell *guidedMindCell;
@property (nonatomic, strong) CenterAlignedTextCell *sizingCell;
@property (nonatomic, strong) SKStoreProductViewController *storeViewController;

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
        [_guidedMindCell setupWithAppImageName:@"flowers" andName:@"Guided Mind"];
    }
    return _guidedMindCell;
}

-(CenterAlignedTextCell *)sizingCell
{
    if(!_sizingCell){
        _sizingCell = [[[NSBundle mainBundle] loadNibNamed:@"CenterAlignedTextCell" owner:self options:nil] firstObject];
    }
    return _sizingCell;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle;
    if(section == 2){
        headerTitle = @"Other apps by AppSimple";
    }
    return headerTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case 0:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"CenterAlignedTextCell" forIndexPath:indexPath];
            [(CenterAlignedTextCell *)cell setupWithTitle:@"Review in iTunes"];
            break;
        case 1:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"CenterAlignedTextCell" forIndexPath:indexPath];
            [(CenterAlignedTextCell *)cell setupWithTitle:@"Restore Purchases"];
            break;
        case 2:
            cell = self.guidedMindCell;
            break;
            
        default:
            break;
    }
    // Configure the cell...
    
    return cell;
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0;
    switch (indexPath.section) {
        case 0:
            height = self.sizingCell.bounds.size.height;
            break;
        case 1:
            height = self.sizingCell.bounds.size.height;
            break;
        case 2:
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
            [self reviewApp];
            break;
        case 1:
            [[MindTimerIAPHelper sharedInstance] restoreCompletedTransactions];
            break;
        case 2:
            [self pushAppVC];
            break;
            
        default:
            break;
    }
}

-(void)pushAppVC
{
    AppDetailsViewController *appDetailsVC = [[AppDetailsViewController alloc] initWithNibName:@"AppDetailsViewController" bundle:nil];
    [self.navigationController pushViewController:appDetailsVC animated:YES];
}

-(void)reviewApp
{
    NSLog(@"review in iTunes");
    NSURL *appURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id901569488?at=1l3vcSo"]; // Guided Mind = id672076838?at=1l3vcSo
    [[UIApplication sharedApplication] openURL:appURL];
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








- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
