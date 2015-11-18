//
//  LCUpdateEmailViewController.h
//  LegacyConnect
//
//  Created by qbuser on 10/09/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCUpdateEmailViewController : UIViewController
{
  
  __weak IBOutlet UIButton *saveButton;
}

@property (strong, nonatomic) NSString * emailAddress;

@end
