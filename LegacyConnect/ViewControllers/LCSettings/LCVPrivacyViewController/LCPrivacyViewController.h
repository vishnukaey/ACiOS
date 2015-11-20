//
//  LCPrivacyTableViewController.h
//  LegacyConnect
//
//  Created by qbuser on 14/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCUpdatePrivacyDelegate <NSObject>
- (void)updateView;
@end

@interface LCPrivacyViewController : UIViewController
{
    __weak IBOutlet UIButton *saveButton;
}

@property (strong,nonatomic) LCSettings *settingsData;
@property (nonatomic, assign) id<LCUpdatePrivacyDelegate> delegate;
@end
