//
//  LCActionsVC.m
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCActionsVC.h"
#import "LCActionsCellView.h"

@interface LCActionsVC ()

@end

@implementation LCActionsVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  [self initailSetup];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - private method implementation

- (void) initailSetup {
  
  actionsTable.estimatedRowHeight = 44.0;
  actionsTable.rowHeight = UITableViewAutomaticDimension;
  
  actionsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  isSelfProfile = [self.userID isEqualToString:[LCDataManager sharedDataManager].userID];
}

- (void) loadActions {
  
  [MBProgressHUD showHUDAddedTo:actionsTable animated:YES];
  [LCAPIManager getUserEventsForUserId:self.userID andLastEventId:nil withSuccess:^(NSArray *response) {
    
    actionsArray = response;
    [actionsTable reloadData];
    [MBProgressHUD hideAllHUDsForView:actionsTable animated:YES];
  } andFailure:^(NSString *error) {
    
    [MBProgressHUD hideAllHUDsForView:actionsTable animated:YES];
  }];
}


#pragma mark - TableView delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if (actionsArray.count == 0) {
    return 1;
  }
  return actionsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (actionsArray.count == 0) {
    
    NSString *message;
    if (isSelfProfile) {
      message = NSLocalizedString(@"no_actions_available_self", nil);
      
    }
    else {
      message = NSLocalizedString(@"no_actions_available_others", nil);
    }
    UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
    
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    return cell;
  }
  
  static NSString *MyIdentifier = @"LCActionsCell";
  LCActionsCellView *cell = (LCActionsCellView*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCActionsCellView" owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  [cell setEvent:[actionsArray objectAtIndex:indexPath.row]];
  
  tableView.backgroundColor = [UIColor clearColor];
  tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
  tableView.allowsSelection = YES;
  return cell;
}

@end
