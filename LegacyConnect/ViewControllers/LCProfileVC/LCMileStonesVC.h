//
//  LCMileStonesVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedTableViewController.h"

@interface LCMileStonesVC : LCFeedTableViewController
{
  BOOL isSelfProfile;
}

@property(nonatomic, retain)NSString *userID;

@end
