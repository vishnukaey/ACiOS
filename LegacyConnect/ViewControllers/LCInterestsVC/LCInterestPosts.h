//
//  LCInterestPosts.h
//  LegacyConnect
//
//  Created by Akhil K C on 1/4/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCInterestPostsBC.h"

@protocol LCInterestPostsDelegate <NSObject>
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
@end

@interface LCInterestPosts : LCInterestPostsBC

  @property (nonatomic, assign) id<LCInterestPostsDelegate> delegate;
  - (void) loadPostsInCurrentInterest;

@end
