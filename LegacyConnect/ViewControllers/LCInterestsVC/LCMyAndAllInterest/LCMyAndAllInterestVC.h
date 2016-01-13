//
//  LCMyAndAllInterestVC.h
//  LegacyConnect
//
//  Created by qbuser on 12/01/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCTabMenuView.h"
#import "LCAllInterestVC.h"
#import "LCMyInterestVC.h"

@interface LCMyAndAllInterestVC : UIViewController {
  __weak IBOutlet LCTabMenuView *tabmenu;
  __weak IBOutlet UIView *allInterestContainer;
  __weak IBOutlet UIView *mineInterestContainer;
  __weak IBOutlet UIButton *allInterestbtn;
  __weak IBOutlet UIButton *myInterestBtn;
  
  LCAllInterestVC * allInterestVC;
  LCMyInterestVC * myInterestVC;
}

@end
