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
  return impactsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  //  NSString *nativeUserId = [LCDataManager sharedDataManager].userID;
  //  NSLog(@"nativeUserId-->>%@ userDetail.userID-->>%@",nativeUserId, userDetail.userID);
  //  if ([nativeUserId isEqualToString:userDetail.userID])
  //  {
  //    currentProfileState = PROFILE_SELF;
  
  
  
  static NSString *MyIdentifier = @"LCFeedCell";
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = [topLevelObjects objectAtIndex:0];
  }
  cell.delegate = self;
  [cell setData:[impactsArray objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
 
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(NSString *)type andFeed:(LCFeed *)feed
{
    NSLog(@"actionType--->>>%@", type);
    
    if ([type isEqualToString:kFeedCellActionComment])//comments
    {
//      UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
//                                                    bundle:nil];
//      LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
//      [next setFeedObject:feed];
//      [self.navigationController pushViewController:next animated:YES];
    }
    
    else if ([type isEqualToString:kFeedCellActionLike])
    {
//#if DEBUG
//      //testing community
//      UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
//      LCViewCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCViewCommunity"];
//      vc.eventID = @"e82de0d2-4fd4-11e5-9852-3d5d64aee29a";
//      [self.navigationController pushViewController:vc animated:YES];
//#endif
      //    [self postMessage];
    }
    else if ([type isEqualToString:kFeedCellActionImage])
    {
      LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
      [appdel.GIButton setHidden:YES];
      [appdel.menuButton setHidden:YES];
      LCFullScreenImageVC *vc = [[LCFullScreenImageVC alloc] init];
      vc.imageView.image = [UIImage imageNamed:@"photoPost_dummy.png"];
      vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
      [self presentViewController:vc animated:YES completion:nil];
    }
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
