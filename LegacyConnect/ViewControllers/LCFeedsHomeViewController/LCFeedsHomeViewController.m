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

static CGFloat kFeedCellRowHeight = 44.0f;
static CGFloat kNumberOfSectionsInFeeds = 1;
static NSString *kFeedCellIdentifier = @"LCFeedCell";
static NSString *kFeedCellXibName = @"LCFeedcellXIB";

@implementation LCFeedsHomeViewController
@synthesize feedsTable;

#pragma mark - private method implementation
- (void)fetchHomeFeedsWithLastFeedId:(NSString*)lastId
{
  [LCAPIManager getHomeFeedsWithLastFeedId:lastId success:^(NSArray *response) {
    [feedsArray addObjectsFromArray:response];;
    [feedsTable reloadData];
    
    if (self.feedsTable.pullToRefreshView.state == KoaPullToRefreshStateLoading) {
      [self.feedsTable.pullToRefreshView stopAnimating];
    }

  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
    //TO DO :
    // Implement func to user tap to refresh or something.
  }];
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
      [feedsTable.pullToRefreshView stopAnimating];
    });
  } withBackgroundColor:[UIColor lightGrayColor]];
}

- (void)setGIAndMenuButtonVisibilityStatus:(BOOL)isHidden
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:isHidden];
  [appdel.menuButton setHidden:isHidden];
}

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  feedsArray = [[NSMutableArray alloc] init];
  [self fetchHomeFeedsWithLastFeedId:nil];
  [self initialUISetUp];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = YES;
  [self setGIAndMenuButtonVisibilityStatus:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  [self setGIAndMenuButtonVisibilityStatus:YES];
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
  return feedsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:kFeedCellIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:kFeedCellXibName owner:self options:nil];
    cell = [topLevelObjects objectAtIndex:0];
  }
  cell.delegate = self;
  [cell setData:[feedsArray objectAtIndex:indexPath.row] forPage:kHomefeedCellID];
  return cell;
}

#pragma mark - UITableViewDelegate implementation
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
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
    [next setFeedObject:feed];
    [self.navigationController pushViewController:next animated:YES];
  }
  
  else if ([type isEqualToString:kFeedCellActionLike])
  {
    [self postMessage];
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
//  LCSearchViewController *searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCSearchViewController"];
//  [self.navigationController pushViewController:searchVC animated:NO];
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
