//
//  LCInterestsVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedTableViewController.h"

@protocol InterestsDelegate <NSObject>
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
@end

@interface LCInterestsVC : LCFeedTableViewController
{
  BOOL isSelfProfile;
}

@property(nonatomic, retain)NSString *userID;
@property (nonatomic, assign) id<InterestsDelegate> delegate;

- (void) loadInterests;
@end
