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

@interface LCLeftMenuController ()
@property (weak, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *menuTable;
@end

static NSString *kProfilePicPlaceholder = @"userProfilePic";
static CGFloat kProfilePicBorderWidth = 3.0f;
static CGFloat kCellHeight = 44.0f;
static CGFloat kNumberOfCells = 5.0;
static NSString * kMenuCellIdentifier = @"LCMenuItemCell";

#define kSelectionColor [UIColor colorWithRed:40.0f/255 green:40.0f/255 blue:40.0f/255 alpha:1]
#define kDeSelectionColor [UIColor colorWithRed:40.0f/255 green:40.0f/255 blue:40.0f/255 alpha:0.8]


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
  
  //-- Name Label -- //
  [self refreshUserInfo];
  
  [self.menuTable setBackgroundColor:kDeSelectionColor];
  [self.menuTable.backgroundView setBackgroundColor:kDeSelectionColor];
}

- (void)refreshUserInfo
{
  [self.userNameLabel setText:[[NSString stringWithFormat:@"%@ %@",[LCDataManager sharedDataManager].firstName,[LCDataManager sharedDataManager].lastName] uppercaseString]];

  //-- Cover Photo -- //
  NSString *urlString = [NSString stringWithFormat:@"%@?type=normal",[LCDataManager sharedDataManager].headerPhotoURL];
  [self.coverPhoto sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
  
  //-- Profile Image--//
  NSString *profileUrlString = [NSString stringWithFormat:@"%@?type=normal",[LCDataManager sharedDataManager].avatarUrl];
  [self.profilePicture sd_setImageWithURL:[NSURL URLWithString:profileUrlString] placeholderImage:[UIImage imageNamed:kProfilePicPlaceholder]];
}

- (void)addUserImageChangeNitification
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUserImages:) name:kUserDataUpdatedNotification object:nil];
}

- (void)removeUserImageChangeNitification
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kUserDataUpdatedNotification object:nil];
}

- (void)refreshUserImages:(NSNotification*)notification
{
  [self refreshUserInfo];
}

#pragma mark - view life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self initialUISetUp];
  [self addUserImageChangeNitification];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [self removeUserImageChangeNitification];
  [super viewWillDisappear:animated];
}

- (IBAction)profileButtonTapped:(id)sender {
  [delegate_ leftMenuItemSelectedAtIndex:5];
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
  return cell;
}

#pragma mark - UITableViewDelegate implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCMenuItemCell * selectedCell = (LCMenuItemCell*)[tableView cellForRowAtIndexPath:indexPath];
  [selectedCell setSelected:NO];
  [selectedCell setBackgroundColor:kSelectionColor];
  [selectedCell.itemIcon setTintColor:kIconSelectionColor];
  [delegate_ leftMenuItemSelectedAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCMenuItemCell * deSelectedCell = (LCMenuItemCell*)[tableView cellForRowAtIndexPath:indexPath];
  [deSelectedCell setBackgroundColor:kDeSelectionColor];
  [deSelectedCell.itemIcon setTintColor:kIconDeSelectionColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return kCellHeight;
}

@end
