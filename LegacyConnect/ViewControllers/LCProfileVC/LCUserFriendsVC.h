//
//  LCUserFriendsVC.h
//  LegacyConnect
//
//  Created by Jijo on 8/21/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCUserFriendsVC : UIViewController
{
  IBOutlet UITableView *friendsTableView;
  NSArray *friendsArray;
}

- (IBAction)backButtonAction;

@end
