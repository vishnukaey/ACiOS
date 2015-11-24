//
//  LCActionsVC.h
//  LegacyConnect
//
//  Created by Akhil K C on 11/4/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCUserActionsBC.h"

@protocol ActionsDelegate <NSObject>
- (void)scrollViewScrolled:(UIScrollView *)scrollView;
@end

@interface LCActionsVC : LCUserActionsBC
{
  BOOL isSelfProfile;
}

@property (nonatomic, assign) id<ActionsDelegate> delegate;

- (void) loadActions;

@end
