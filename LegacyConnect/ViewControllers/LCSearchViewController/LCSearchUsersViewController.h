//
//  LCSearchUsersViewController.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTTableViewController.h>

@interface LCSearchUsersViewController : JTTableViewController

@property (nonatomic,retain) NSString *searchKey;
- (void)setUsersArray:(NSArray*) usersArray;

@end
