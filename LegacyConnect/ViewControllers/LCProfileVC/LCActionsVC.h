//
//  LCActionsVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCActionsVC : UIViewController
{
  __weak IBOutlet UITableView *actionsTable;
  NSArray *actionsArray;
  BOOL isSelfProfile;
}

@property(nonatomic, retain)NSString *userID;

- (void) loadActions;

@end
