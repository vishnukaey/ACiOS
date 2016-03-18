//
//  LCContactsListVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCMultipleSelectionTable.h"
#import "LCInviteEmailVC.h"


@interface LCContactsListVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
  NSArray *contactsArray;
  IBOutlet LCMultipleSelectionTable *contactsTable;
  NSMutableArray *selectedContactsArray;
  NSMutableArray *selectedEmailsArray;
  NSMutableArray *invitedEmails;
  IBOutlet UILabel *additionalEmailsLabel;
}

@end
