//
//  LCProfileViewBC.h
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "JTTableViewController.h"
#import "LCMileStonesVC.h"
#import "LCInterestsVC.h"
#import "LCActionsVC.h"

@interface LCProfileViewBC : JTTableViewController
{
  __weak IBOutlet UIImageView *profilePic, *headerImageView;
  __weak IBOutlet UILabel *impactsCountLabel, *friendsCountLabel;
  __weak IBOutlet UILabel *userNameLabel, *memeberSincelabel, *locationLabel;
  __weak IBOutlet UIButton *friendsButton;
  __weak IBOutlet UIButton *impactsCountButton, *friendsCountButton;
  __weak IBOutlet UIView *tabBarView;
  
  LCMileStonesVC *mileStonesVC;
  LCInterestsVC *interestsVC;
  LCActionsVC *actionsVC;
  
  FriendStatus currentProfileStatus;
}

@property(nonatomic, retain)LCUserDetail *userDetail;
- (void) setCurrentProfileStatus:(FriendStatus)friendStatus;
- (void) updateUserDetailUI;
- (void) checkPrivacySettings;
- (void) showTabBarAndLoadMilestones;

@end
