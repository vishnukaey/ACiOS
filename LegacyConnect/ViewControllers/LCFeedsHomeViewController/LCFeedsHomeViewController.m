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

#if DEBUG
#import "LCViewCommunity.h"
#endif

@implementation LCFeedsHomeViewController
@synthesize feedsTable;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UILabel *construction_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, [[UIScreen mainScreen] bounds].size.width, 80)];
  construction_.text = @"Under development...";
  construction_.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:construction_];
  
//  [LCAPIManager getHomeFeedsWithSuccess:^(NSArray *response) {
//    feedsArray = response;
//    [feedsTable reloadData];
//  } andFailure:^(NSString *error) {
//    NSLog(@"%@",error);
//  }];
  
  CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
  self.customNavigationHeight.constant = statusBarViewRect.size.height+self.navigationController.navigationBar.frame.size.height;
  
  [feedsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
  feedsTable.estimatedRowHeight = 44.0;
  feedsTable.rowHeight = UITableViewAutomaticDimension;
  
  [feedsTable addPullToRefreshWithActionHandler:^{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [feedsTable.pullToRefreshView stopAnimating];
    });
  }withBackgroundColor:[UIColor lightGrayColor]];
  
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

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
  return feedsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"LCFeedCell";
  LCFeedCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCFeedcellXIB" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = [topLevelObjects objectAtIndex:0];
  }
  cell.delegate = self;
  [cell setData:[feedsArray objectAtIndex:indexPath.row] forPage:kHomefeedCellID];

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
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                  bundle:nil];
    LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
    [next setFeedObject:feed];
    [self.navigationController pushViewController:next animated:YES];
  }
  
  else if ([type isEqualToString:kFeedCellActionLike])
  {
#if DEBUG
    //testing community
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
    LCViewCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCViewCommunity"];
    vc.eventID = @"e82de0d2-4fd4-11e5-9852-3d5d64aee29a";
    [self.navigationController pushViewController:vc animated:YES];
#endif
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
