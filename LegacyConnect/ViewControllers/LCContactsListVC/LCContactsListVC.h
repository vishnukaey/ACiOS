//
//  LCContactsListVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCMultipleSelectionTable.h"

@interface LCContactsListVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
  NSArray *H_contactsArray;
  LCMultipleSelectionTable *H_contactsTable;
}

@end
