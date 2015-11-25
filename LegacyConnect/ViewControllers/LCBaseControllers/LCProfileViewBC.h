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
  IBOutlet UILabel *impactsCountLabel, *friendsCountLabel;
  IBOutlet UIButton *friendsButton;
  FriendStatus currentProfileStatus;
}

@property(nonatomic, retain)LCUserDetail *userDetail;
- (void) setCurrentProfileStatus:(FriendStatus)friendStatus;

@end
