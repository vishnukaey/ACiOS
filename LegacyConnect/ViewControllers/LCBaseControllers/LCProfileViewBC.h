//
//  LCProfileViewBC.h
//  LegacyConnect
//
//  Created by Jijo on 11/24/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "JTTableViewController.h"

@interface LCProfileViewBC : JTTableViewController
{
  IBOutlet UIImageView *profilePic, *headerImageView;
  IBOutlet UILabel *impactsCountLabel, *friendsCountLabel;
  IBOutlet UILabel *userNameLabel, *memeberSincelabel, *locationLabel;
  IBOutlet UIButton *friendsButton;
  FriendStatus currentProfileStatus;
}

@property(nonatomic, retain)LCUserDetail *userDetail;
- (void) setCurrentProfileStatus:(FriendStatus)friendStatus;
- (void) updateUserDetailUI;

@end
