//
//  LCOnboardFinalSelectionVC.m
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardFinalSelectionVC.h"
#import "LCCausesCollectionTableViewCell.h"
#import "LCOnboardCausesVC.h"

#pragma mark - LCCausesHeaderReusableView class
@interface LCCausesHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *interestName;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;
@end

@implementation LCCausesHeaderTableViewCell
@end

@interface LCOnboardFinalSelectionVC ()

@end

NSString *const kCellIdentifierSectionHeader = @"headerCell";
NSString *const kCellIdentifierTableViewCell = @"mycell";
NSInteger const kTableViewCellHeight = 170;
NSInteger const kTableViewHeaderHeight = 44;
NSInteger const kNumberOfRowsInSection = 1;

@implementation LCOnboardFinalSelectionVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self getCauses];
}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:NO ];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void) getCauses {
  
  NSArray *interestArray = @[@"1", @"2", @"3"];
  
  [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
  [LCThemeAPIManager getCausesForSetOfInterests:interestArray withSuccess:^(id response) {
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
    self.interestArray = response;
    [self.tableView reloadData];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:self.tableView animated:YES];
  }];
}

- (IBAction)showAllAction:(UIButton*)sender {
  
  NSInteger section = sender.tag;
  LCInterest *interest = self.interestArray[section];
  
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  LCOnboardCausesVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCOnboardCausesVC"];
  vc.interest = interest;
  [self.navigationController pushViewController:vc animated:YES];;
}

#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return self.interestArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return kNumberOfRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kTableViewCellHeight;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return kTableViewHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  
  // remove bottom extra 20px space.
  return CGFLOAT_MIN;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  NSString *cellIdentifier = kCellIdentifierSectionHeader;
  LCCausesHeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  LCInterest *interest = self.interestArray[section];
  headerView.interestName.text = interest.name;
  headerView.showAllButton.tag = section;
  return  headerView ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *cellIdentifier = kCellIdentifierTableViewCell;
  LCCausesCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  LCInterest *interest = self.interestArray[indexPath.section];
  cell.causesArray = interest.causes;
  return cell;
}

@end
