//
//  LCInterestsVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InterestsDelegate <NSObject>
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
@end

@interface LCInterestsVC : UIViewController
{
  __weak IBOutlet UITableView *interestsTable;
  NSArray *interestsArray;
  BOOL isSelfProfile;
}

@property(nonatomic, retain)NSString *userID;
@property (nonatomic, assign) id<InterestsDelegate> delegate;

- (void) loadInterests;
@end
