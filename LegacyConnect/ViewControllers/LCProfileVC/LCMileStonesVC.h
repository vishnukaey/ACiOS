//
//  LCMileStonesVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCMileStonesBC.h"

@protocol MileStonesDelegate <NSObject>
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
@end

@interface LCMileStonesVC : LCMileStonesBC
{
  
}

@property(nonatomic, retain)NSString *userID;
@property (nonatomic, assign) id<MileStonesDelegate> delegate;
- (void) loadMileStones;

@end
