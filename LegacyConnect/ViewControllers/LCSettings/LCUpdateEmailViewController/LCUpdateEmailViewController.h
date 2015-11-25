//
//  LCUpdateEmailViewController.h
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCUpdateEmailDelegate <NSObject>
- (void)updateView;
@end

@interface LCUpdateEmailViewController : UIViewController
{
  __weak IBOutlet UIButton *saveButton;
}

@property (strong,nonatomic) LCSettings *settingsData;
@property (nonatomic, assign) id<LCUpdateEmailDelegate> delegate;

@end
