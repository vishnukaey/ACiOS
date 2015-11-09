//
//  LCActionsVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedTableViewController.h"

@protocol ActionsDelegate <NSObject>
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
@end

@interface LCActionsVC : LCFeedTableViewController
{
  BOOL isSelfProfile;
}

@property(nonatomic, retain)NSString *userID;
@property (nonatomic, assign) id<ActionsDelegate> delegate;

- (void) loadActions;

@end
