//
//  LCSearchUsersViewController.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/6/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCSearchUsersBC.h"

@interface LCSearchUsersViewController : LCSearchUsersBC
@property (weak, nonatomic) IBOutlet UIView *noResultsHereView;
@property (nonatomic,retain) NSString *searchKey;
- (void)setUsersArray:(NSArray*) usersArray;

@end
