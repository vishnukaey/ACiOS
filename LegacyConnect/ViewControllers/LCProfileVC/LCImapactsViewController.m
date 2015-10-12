//
//  LCImapactsViewController.m
//  LegacyConnect
//
//  Created by Jijo on 8/27/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCImapactsViewController.h"
#import "LCFeedCellView.h"
#import "LCFullScreenImageVC.h"

@interface LCImapactsViewController ()

@end

@implementation LCImapactsViewController
@synthesize impactsTableView, customNavigationHeight, userDetail;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  self.customNavigationHeight.constant = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
  
  [MBProgressHUD showHUDAddedTo:impactsTableView animated:YES];
  [LCAPIManager getImpactsForUser:userDetail.userID andLastMilestoneID:nil with:^(NSArray *response) {
    NSLog(@"%@",response);
    impactsArray = response;
    [impactsTableView reloadData];
    [MBProgressHUD hideHUDForView:impactsTableView animated:YES];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
    [MBProgressHUD hideHUDForView:impactsTableView animated:YES];
  }];
  
  [impactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  impactsTableView.estimatedRowHeight = 44.0;
  impactsTableView.rowHeight = UITableViewAutomaticDimension;

}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [appdel.menuButton setHidden:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (IBAction)backButtonAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (impactsArray.count == 0) {
    return 1;
  }
  return impactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (impactsArray.count == 0)
  {
    NSString *nativeUserId = [LCDataManager sharedDataManager].userID;
    if ([nativeUserId isEqualToString:userDetail.userID])//self profile
    {
      return [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"no_impacts_available_self", nil)];
    }
    else
    {
      return [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"no_impacts_available_others", nil)];
    }
  }
  static NSString *MyIdentifier = @"LCFeedCell";
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = [topLevelObjects objectAtIndex:0];
  }
  [cell setData:[impactsArray objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
  __weak typeof(self) weakSelf = self;
  cell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
    [weakSelf feedCellActionWithType:actionType andFeed:feed];
  };
  cell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
    [weakSelf tagTapped:tagDetails];
  };

 
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  
  switch (type) {
    case kFeedCellActionComment:
      //      UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
      //                                                    bundle:nil];
      //      LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
      //      [next setFeedObject:feed];
      //      [self.navigationController pushViewController:next animated:YES];
      break;
      
      case kFeedCellActionLike:
      //    [self postMessage];
      break;
      
      case kkFeedCellActionViewImage:
      [self showFullScreenImage:nil];
      break;
      
    default:
      break;
  }
}

- (void)showFullScreenImage:(NSString*)imageUrl
{
#warning remove this with proper image url obje
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:YES];
  [appdel.menuButton setHidden:YES];
  LCFullScreenImageVC *vc = [[LCFullScreenImageVC alloc] init];
  vc.imageView.image = [UIImage imageNamed:@"photoPost_dummy.png"];
  vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  NSLog(@"tag details-->>%@", tagDetails);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
