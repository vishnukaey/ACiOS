//
//  LCInterestCauses.h
//  LegacyConnect
//
//  Created by Akhil K C on 1/4/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCCollectionViewController.h"

@protocol LCInterestCausesDelegate <NSObject>
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
@end

@interface LCInterestCauses : LCCollectionViewController

  @property(nonatomic, retain) LCInterest *interest;
  @property (nonatomic, assign) id<LCInterestCausesDelegate> delegate;
  - (void) loadCausesInCurrentInterest;

@end
