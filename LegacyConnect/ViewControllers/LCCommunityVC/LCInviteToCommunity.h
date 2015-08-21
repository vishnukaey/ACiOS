//
//  LCInviteToCommunity.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCMultipleSelectionTable.h"


@interface LCInviteToCommunity : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
  IBOutlet LCMultipleSelectionTable *friendsTableView;
  NSArray *friendsArray;
}
- (IBAction)cancelAction;
-(IBAction)doneButtonAction;

@end
