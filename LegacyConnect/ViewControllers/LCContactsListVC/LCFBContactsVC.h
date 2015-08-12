//
//  LCFBContactsVC.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCFBContactsVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
  UITableView *friendsTable;
  NSMutableArray *finalFriendsArray;;
}

@end
