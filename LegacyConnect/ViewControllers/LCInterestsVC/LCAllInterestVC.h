//
//  LCAllInterestVC.h
//  LegacyConnect
//
//  Created by User on 7/29/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAllInterestVC : UIViewController
{
  IBOutlet UIScrollView *H_interestsScroll;
}

- (IBAction)toggleMineORAll:(UIButton *)sender;

@end
