  //
//  LCFeedsHomeViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsHomeViewController.h"
#import "LCLoginHomeViewController.h"
#import "LCFullScreenImageVC.h"
#import <KoaPullToRefresh/KoaPullToRefresh.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "LCSingleCauseVC.h"
#import "LCProfileViewVC.h"
#import "LCSearchViewController.h"
#import "LCLoadingCell.h"
#import "LCSocialShareManager.h"

static CGFloat kFeedCellRowHeight = 44.0f;
static CGFloat kNumberOfSectionsInFeeds = 1;
static NSString *kFeedCellXibName = @"LCFeedcellXIB";

@implementation LCFeedsHomeViewController
@synthesize feedsTable;

#pragma mark - private method implementation

- (void)stopRefreshingViews
{
  // -- Stop Refreshing Views -- //
  if (self.feedsTable.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
    [feedsArray removeAllObjects];
    [feedsTable reloadData];
    [self.feedsTable.pullToRefreshView stopAnimating];
  }
}

- (void)fetchHomeFeedsWithLastFeedId:(NSString*)lastId
{
  isLoadingMoreFriends = YES;
  [LCAPIManager getHomeFeedsWithLastFeedId:lastId success:^(NSArray *response) {
    loadMoreFriends = ([(NSArray*)response count] > 0) ? YES : NO;
    [self stopRefreshingViews];
    
    // -- Update Data Source -- //
    [feedsArray addObjectsFromArray:response];
    [feedsTable reloadData];
    isLoadingMoreFriends = NO;
  } andFailure:^(NSString *error) {
    [self stopRefreshingViews];
    [feedsTable reloadData];
    loadMoreFriends = feedsArray.count < 10 ? NO : YES;
    isLoadingMoreFriends = NO;
  }];
}

- (void)bottomRefresh
{
  if (loadMoreFriends && !isLoadingMoreFriends) {
    [self fetchHomeFeedsWithLastFeedId:[(LCFeed*)[feedsArray lastObject] feedId]];
  }
  else
  {
    [self stopRefreshingViews];
  }
}

- (void)initialUISetUp
{
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  self.customNavigationHeight.constant = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
  [feedsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  feedsTable.estimatedRowHeight = kFeedCellRowHeight;
  feedsTable.rowHeight = UITableViewAutomaticDimension;
  
  // Pull to Refresh Interface to Feeds TableView.
  [feedsTable addPullToRefreshWithActionHandler:^{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [self fetchHomeFeedsWithLastFeedId:nil];
    });
  } withBackgroundColor:[UIColor lightGrayColor]];
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  feedsArray = [[NSMutableArray alloc] init];
  loadMoreFriends = YES;
  [self fetchHomeFeedsWithLastFeedId:nil];
  [self initialUISetUp];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:NO MenuVisibilityStatus:NO];
  [feedsTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:YES MenuVisibilityStatus:YES];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource implementation
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return kNumberOfSectionsInFeeds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
  if (feedsArray.count == 0 && self.feedsTable.pullToRefreshView.state != KoaPullToRefreshStateLoading && !isLoadingMoreFriends) {
    return 1;
  }
  
  return feedsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (feedsArray.count == 0)
  {
    return [LCUtilityManager getEmptyIndicationCellWithText:NSLocalizedString(@"no_feeds_available", nil)];
  }
  
  if (indexPath.row == feedsArray.count) {
    LCLoadingCell *loadingCell = [tableView dequeueReusableCellWithIdentifier:[LCLoadingCell getFeedCellidentifier]];
    if (loadingCell == nil) {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCLoadingCell" owner:self options:nil];
      loadingCell = [topLevelObjects objectAtIndex:0];
    }
    [loadingCell setBackgroundColor:[UIColor greenColor]];
    [MBProgressHUD hideHUDForView:loadingCell animated:NO];
    [MBProgressHUD showHUDAddedTo:loadingCell animated:NO];
    return loadingCell;
  }
  else
  {
    LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:[LCFeedCellView getFeedCellIdentifier]];
    if (cell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:kFeedCellXibName owner:self options:nil];
      cell = [topLevelObjects objectAtIndex:0];
    }
    [cell setData:[feedsArray objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
    NSLog(@"\n%@n\n",[feedsArray objectAtIndex:indexPath.row]);
    __weak typeof(self) weakSelf = self;
    cell.feedCellAction = ^ (kkFeedCellActionType actionType, LCFeed * feed) {
      [weakSelf feedCellActionWithType:actionType andFeed:feed];
    };
    cell.feedCellTagAction = ^ (NSDictionary * tagDetails) {
      [weakSelf tagTapped:tagDetails];
    };
    return cell;
  }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == feedsArray.count - 1 && loadMoreFriends && !isLoadingMoreFriends) {
    [self fetchHomeFeedsWithLastFeedId:[(LCFeed*)[feedsArray lastObject] feedId]];
  }
}

#pragma mark - UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning remove this test call
  UIImage * shareImage = [UIImage imageNamed:@"ThanksIcon_enabled"];
  [LCSocialShareManager canShareToTwitter:^(BOOL canShare) {
    if (canShare) {
      [LCSocialShareManager shareToTwitterWithStatus:@"This is a test share" andImage:shareImage];
    }
    else
    {
      [LCUtilityManager showAlertViewWithTitle:@"" andMessage:@"You must login to Twitter account"];
    }
  }];
}

- (void)feedCellActionWithType:(kkFeedCellActionType)type andFeed:(LCFeed *)feed
{
  switch (type) {
      
    case kFeedCellActionComment:
      [self showFeedCommentsWithFeed:feed];
      break;
      
      case kFeedCellActionLike:
      /**
       * Like/Unlike actions will be handled from 'LCFeedCellView' class.
       */
      break;
      
      case kkFeedCellActionViewImage:
      [self showFullScreenImage:feed.image];
      break;
      
    default:
      break;
  }
}

- (void)showFeedCommentsWithFeed:(LCFeed*)feed
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                bundle:nil];
  LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
  [next setFeedObject:feed];
  [self.navigationController pushViewController:next animated:YES];
}

- (void)showFullScreenImage:(NSString*)imageUrl
{
  [LCUtilityManager setGIAndMenuButtonVisibilityStatus:YES MenuVisibilityStatus:YES];
  LCFullScreenImageVC *vc = [[LCFullScreenImageVC alloc] init];
  vc.imageUrlString = imageUrl;
  vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
  [self presentViewController:vc animated:YES completion:nil];
}

- (void)tagTapped:(NSDictionary *)tagDetails
{
  NSLog(@"tag details-->>%@", tagDetails);
  if ([tagDetails[@"type"] isEqualToString:kFeedTagTypeCause])//go to cause page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Interests" bundle:nil];
    LCSingleCauseVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCSingleCauseVC"];
    [self.navigationController pushViewController:vc animated:YES];
  }
  else if ([tagDetails[@"type"] isEqualToString:kFeedTagTypeUser])//go to user page
  {
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    LCProfileViewVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCProfileViewVC"];
    vc.userDetail = [[LCUserDetail alloc] init];
    vc.userDetail.userID = tagDetails[@"id"];
    [self.navigationController pushViewController:vc animated:YES];
  }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////                                                                                                  ////////////////////
////////////////                        TEST DATA - To be removed                                                 ////////////////////
////////////////                                                                                                  ////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//following is the code for other screens
ACAccount *facebookAccount;
-(void)postMessage
{
  ACAccountStore *accountStore = [[ACAccountStore alloc] init];
  
  ACAccountType *facebookAccountType = [accountStore
                                        accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
  
  // Specify App ID and permissions
  NSDictionary *options = @{
                            ACFacebookAppIdKey: @"1408366702711751",
                            ACFacebookPermissionsKey: @[@"publish_stream", @"publish_actions"],
                            ACFacebookAudienceKey: ACFacebookAudienceFriends
                            };
  
  [accountStore requestAccessToAccountsWithType:facebookAccountType
                                        options:options completion:^(BOOL granted, NSError *e) {
                                          if (granted) {
                                            NSLog(@"granted-->>>");
                                            NSArray *accounts = [accountStore
                                                                 accountsWithAccountType:facebookAccountType];
                                             facebookAccount = [accounts lastObject];
                                          
                                                          UIImage *image = [UIImage imageNamed:@"check_box.png"];
                                                          NSDictionary *parameters = @{@"message": @"nil", @"picture":image};
                                                          
                                                          NSURL *feedURL = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
                                                          
                                                          SLRequest *feedRequest = [SLRequest
                                                                                    requestForServiceType:SLServiceTypeFacebook
                                                                                    requestMethod:SLRequestMethodPOST
                                                                                    URL:feedURL
                                                                                    parameters:parameters];
                                                          
                                                          feedRequest.account = facebookAccount;
                                                          
                                                          [feedRequest performRequestWithHandler:^(NSData *responseData, 
                                                                                                   NSHTTPURLResponse *urlResponse, NSError *error)
                                                           {
                                                             // Handle response
                                                             NSString *res = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                                                             NSLog(@"response-->>>%@   error-->>%@", res, error);
                                                           }];
                                          }
                                          else
                                          {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                              
                                              // Fail gracefully...
                                              NSLog(@"%@",e.description);
//                                              if([e code]== ACErrorAccountNotFound)
//                                                [self throwAlertWithTitle:@"Error" message:@"Account not found. Please setup your account in settings app."];
//                                              else
//                                                [self throwAlertWithTitle:@"Error" message:@"Account access denied."];
                                              
                                            });
                                          }
                                        }];
  
}



-(IBAction)search:(id)sender
{
  LCSearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCSearchViewController"];
  [self.navigationController pushViewController:searchVC animated:NO];
}


//-(void)shareFB
//{
//  if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"])
//  {
//    [self postToFB];
//  }
//  else
//  {
//    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
//    [login logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
//     {
//       if (error)
//       {
//         // Process error
//         NSLog(@"permissionError-->>");
//       } else if (result.isCancelled)
//       {
//         // Handle cancellations
//       } else
//       {
//         // If you ask for multiple permissions at once, you
//         // should check if specific permissions missing
//         if ([result.grantedPermissions containsObject:@"publish_actions"])
//         {
//           // Do work
//           NSLog(@"permission granted-->>");
//           [self postToFB];
//         }
//       }
//     }];
//  }
//}

//-(void)postToFB
//{
//  FBSDKSharePhoto *sharePhoto = [[FBSDKSharePhoto alloc] init];
//  sharePhoto.caption = @"Test Caption";
//  sharePhoto.image = [UIImage imageNamed:@"check_box.png"];
//  
//  FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
//  content.photos = @[sharePhoto];
//  
//  [FBSDKShareAPI shareWithContent:content delegate:nil];
//  
//  return;
//  
////  [[[FBSDKGraphRequest alloc]
////    initWithGraphPath:@"me/feed"
////    parameters: @{ @"message" : @"test...1111"}
////    HTTPMethod:@"POST"]
////   startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
////     if (!error) {
////       NSLog(@"Post id:%@", result[@"id"]);
////     }
////   }];
//}


@end
