//
//  LCActionsTableTableViewController.h
//  LegacyConnect
//
//  Created by qbuser on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "JTTableViewController.h"

@interface LCUserActionsBC : JTTableViewController {
  BOOL isSelfProfile;
}

@property(nonatomic, retain)NSString *userID;

@end
