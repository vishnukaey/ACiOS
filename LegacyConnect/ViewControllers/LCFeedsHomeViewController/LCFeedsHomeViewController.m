  //
//  LCFeedsHomeViewController.m
//  LegacyConnect
//
//  Created by Vishnu on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsHomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "LCGIButton.h"
#import "LCLoginHomeViewController.h"
#import "LCChooseCommunityInterest.h"
#import "LCContactsListVC.h"


@implementation LCFeedsHomeViewController

@synthesize P_containerController;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [H_feedsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];

  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  self.P_containerController = (MFSideMenuContainerViewController *)appdel.window.rootViewController;

  [self addfloatingButtons];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self prepareFeedViews];
  [H_feedsTable reloadData];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - initial setup functions
- (void)addfloatingButtons
{
  //global impact button
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  LCGIButton * giButton = [[LCGIButton alloc]initWithFrame:CGRectMake(appdel.window.frame.size.width - 60, appdel.window.frame.size.height - 60, 50, 50)];
  [appdel.window addSubview:giButton];
  [giButton setUpMenu];
  giButton.P_community.tag = 0;
  [giButton.P_community addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
  appdel.GIButton = giButton;

  giButton.P_video.tag = 1;
  [giButton.P_video addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];

  giButton.P_status.tag = 2;
  [giButton.P_status addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];

  //menu poper button
  UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(appdel.window.frame.size.width - 40,70, 30, 30)];
  menuButton.layer.cornerRadius = menuButton.frame.size.width/2;
  menuButton.backgroundColor = [UIColor grayColor];
  [appdel.window addSubview:menuButton];
  [menuButton addTarget:self action:@selector(menuButtonAction) forControlEvents:UIControlEventTouchUpInside];
  appdel.menuButton = menuButton;
}

- (void)prepareFeedViews
{
  NSArray *feedsArray = [LCDummyValues dummyFeedArray];

  H_feedsViewArray = [[NSMutableArray alloc]init];
  for (int i=0; i<feedsArray.count; i++)
  {
    LCFeedCellView *celViewFinal = [[LCFeedCellView alloc]init];
    [celViewFinal arrangeSelfForData:[feedsArray objectAtIndex:i] forWidth:H_feedsTable.frame.size.width forPage:1];
    celViewFinal.delegate = self;
    [H_feedsViewArray addObject:celViewFinal];
  }
}

#pragma mark - button actions
- (void)menuButtonAction
{
  [self.P_containerController setMenuState:MFSideMenuStateLeftMenuOpen];
}

- (void)GIBComponentsAction :(UIButton *)sender
{
  NSLog(@"tag-->>%d", (int)sender.tag);
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton toggle];
  [appdel.GIButton setHidden:YES];
  [appdel.menuButton setHidden:YES];
  
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCChooseCommunityInterest *vc = [sb instantiateViewControllerWithIdentifier:@"LCChooseCommunityInterest"];
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)logout:(id)sender
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:kLoginStatusKey];
  [defaults synchronize];
  [LCDataManager sharedDataManager].userToken = kEmptyStringValue;
  if ([FBSDKAccessToken currentAccessToken])
  {
    [[FBSDKLoginManager new] logOut];
  }
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  UIViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
  appdel.window.rootViewController = myStoryBoardInitialViewController;
  [appdel.window makeKeyAndVisible];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  return H_feedsViewArray.count;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
  }
  [[cell viewWithTag:10] removeFromSuperview];

  UIView *cellView = (UIView *)[H_feedsViewArray objectAtIndex:indexPath.row];
  [cell addSubview:cellView];
  cellView.tag = 10;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UIView *cellView = (UIView *)[H_feedsViewArray objectAtIndex:indexPath.row];
  
  return cellView.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - feedCell delegates
- (void)feedCellActionWithType:(int)type andID:(NSString *)postID
{
  NSLog(@"actionType--->>>%d", type);
  if (type==2)//comments
  {
        UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Main"
                                                      bundle:nil];
        LCFeedsCommentsController *next = [sb instantiateViewControllerWithIdentifier:@"LCFeedsCommentsController"];
        
        [self.navigationController pushViewController:next animated:YES];
  }
  
  if (type==1)
  {
  }
}

#pragma mark - leftmenu delegates
- (void)leftMenuButtonActions:(UIButton *)sender
{
  NSLog(@"left menu sender tag-->>%d", (int)sender.tag);
  [self.P_containerController setMenuState:MFSideMenuStateClosed];
}

@end
