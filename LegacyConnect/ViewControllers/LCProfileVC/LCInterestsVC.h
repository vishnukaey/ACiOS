//
//  LCInterestsVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCInterestsVC : UIViewController
{
  __weak IBOutlet UITableView *interestsTable;
  NSArray *interestsArray;
  BOOL isSelfProfile;
}

@property(nonatomic, retain)NSString *userID;

- (void) loadInterests;
@end
