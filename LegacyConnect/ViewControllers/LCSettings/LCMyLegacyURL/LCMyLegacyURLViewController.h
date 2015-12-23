//
//  LCMyLegacyURL.h
//  LegacyConnect
//
//  Created by qbuser on 11/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCUpdateLegacyURLDelegate <NSObject>
- (void)updateView;
@end

@interface LCMyLegacyURLViewController : UIViewController
{
  __weak IBOutlet UITextField *legacyURLTextField;
  __weak IBOutlet UILabel *legacyURLLabel;
  __weak IBOutlet UIButton *saveButton;
}

@property (strong,nonatomic) LCSettings *settingsData;
@property (nonatomic, assign) id<LCUpdateLegacyURLDelegate> delegate;

@end
