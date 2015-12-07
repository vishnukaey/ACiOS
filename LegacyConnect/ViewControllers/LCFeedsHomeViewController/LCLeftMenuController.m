//
//  leftMenuController.m
//  LegacyConnect
//
//  Created by User on 7/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCLeftMenuController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LCMenuItemCell.h"
#import "LCMenuButton.h"

@interface LCLeftMenuController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (nonatomic, assign) BOOL isFirstLaunch;
@end

static NSString *kProfilePicPlaceholder = @"userProfilePic";
static CGFloat kProfilePicBorderWidth = 3.0f;
static CGFloat kCellHeight = 44.0f;
static CGFloat kNumberOfCells = 3.0;
static NSString * kMenuCellIdentifier = @"LCMenuItemCell";

#define kSelectionColor [UIColor colorWithRed:0.0f/255 green:0.0f/255 blue:0.0f/255 alpha:1]
#define kDeSelectionColor [UIColor colorWithRed:40.0f/255 green:40.0f/255 blue:40.0f/255 alpha:1]


#define kIconSelectionColor [UIColor colorWithRed:239.0f/255 green:100.0f/255 blue:77.0f/255 alpha:1]
#define kIconDeSelectionColor [UIColor colorWithRed:247.0f/255 green:247.0f/255 blue:247.0f/255 alpha:1]

@implementation LCLeftMenuController
@synthesize delegate_;

#pragma mark - private method implementation
- (void)initialUISetUp
{
  //-- Profile Photo -- //
  self.profilePicture.layer.cornerRadius = CGRectGetWidth(self.profilePicture.frame) / 2;
  self.profilePicture.layer.borderColor = [UIColor whiteColor].CGColor;
  self.profilePicture.layer.borderWidth = kProfilePicBorderWidth;
  self.profilePicture.clipsToBounds = YES;
  self.profilePicture.image = [UIImage imageNamed:kProfilePicPlaceholder];
  //-- Name Label -- //
  [self refreshUserInfo];
  
  self.menuTable.opaque = NO;
  [self.menuTable setBackgroundColor:kDeSelectionColor];
  //  [self.menuTable.backgroundView setBackgroundColor:kDeSelectionColor];
  //  self.menuTable.backgroundView = nil;
  self.isFirstLaunch = YES;
  selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  
  NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
  NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];
  [_versionLabel setText:[NSString stringWithFormat:@"Legacy Connect %@",version]];
}

- (void)refreshUserInfo
{
  NSString *firstName = [LCUtilityManager performNullCheckAndSetValue:[LCDataManager sharedDataManager].firstName];
  NSString *lastName = [LCUtilityManager performNullCheckAndSetValue:[LCDataManager sharedDataManager].lastName];
  [self.userNameLabel setText:[[NSString stringWithFormat:@"%@ %@",firstName, lastName] uppercaseString]];
  
  //-- Cover Photo -- //
  NSString *urlString = [NSString stringWithFormat:@"%@?type=normal",[LCDataManager sharedDataManager].headerPhotoURL];
  [self.coverPhoto sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:self.coverPhoto.image];
  
  //-- Profile Image--//
  NSString *profileUrlString = [NSString stringWithFormat:@"%@?type=large",[LCDataManager sharedDataManager].avatarUrl];
  [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:profileUrlString] placeholderImage:self.profilePicture.image];
}

- (void)addRequiredNotificationObserver
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserImages:) name:kUserDataUpdatedNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCountUpdated) name:kNotificationCountUpdated object:nil];
}

- (void)refreshUserImages:(NSNotification*)notification
{
  [self refreshUserInfo];
}

- (void)notificationCountUpdated
{
  LCAppDelegate * appdel = [[UIApplication sharedApplication] delegate];
  NSInteger totalNotificationCount = [[[LCDataManager sharedDataManager] notificationCount] integerValue] + [[[LCDataManager sharedDataManager] requestCount] integerValue];
  [[(LCMenuButton*)appdel.menuButton badgeLabel] setText:[NSString stringWithFormat:@"%li",(long)totalNotificationCount]];
  [[(LCMenuButton*)appdel.menuButton badgeLabel] setHidden:(totalNotificationCount == 0)];
  [self.menuTable reloadData];
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self addRequiredNotificationObserver];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self initialUISetUp];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

- (void)deselectCellAtIndexPath:(NSIndexPath*)indexpath
{
  if (!indexpath) {
    indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
  }
  LCMenuItemCell * deSelectedCell = (LCMenuItemCell*)[self.menuTable cellForRowAtIndexPath:indexpath];
  [deSelectedCell setBackgroundColor:kDeSelectionColor];
  [deSelectedCell.itemIcon setTintColor:kIconDeSelectionColor];
}

- (IBAction)profileButtonTapped:(id)sender {
  [self deselectCellAtIndexPath:selectedIndexPath];
  selectedIndexPath = nil;
  [delegate_ leftMenuItemSelectedAtIndex:3];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return kNumberOfCells;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCMenuItemCell * cell = (LCMenuItemCell*)[tableView dequeueReusableCellWithIdentifier:kMenuCellIdentifier];
  if (cell == nil) {
    cell = [[LCMenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kMenuCellIdentifier];
  }
  [cell setIndex:indexPath.row];
  [cell setBackgroundColor:kDeSelectionColor];
  
  if ([indexPath isEqual:selectedIndexPath]) {
    [cell setBackgroundColor:kSelectionColor];
    [cell.itemIcon setTintColor:kIconSelectionColor];
  }
  
  return cell;
}

#pragma mark - UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  if (self.isFirstLaunch) {
    [self deselectCellAtIndexPath:selectedIndexPath];
    self.isFirstLaunch = NO;
  }
  selectedIndexPath = indexPath;
  
  LCMenuItemCell * selectedCell = (LCMenuItemCell*)[tableView cellForRowAtIndexPath:indexPath];
  [selectedCell setSelected:NO];
  [selectedCell setBackgroundColor:kSelectionColor];
  [selectedCell.itemIcon setTintColor:kIconSelectionColor];
  [delegate_ leftMenuItemSelectedAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self deselectCellAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeight;
}

@end
