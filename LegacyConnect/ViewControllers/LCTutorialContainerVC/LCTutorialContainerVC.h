//
//  LCTutorialContainerVC.h
//  LegacyConnect
//
//  Created by Vishnu on 7/20/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFinalTutorialVC.h"

@interface LCTutorialContainerVC : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
{
  UIPageControl *pageControl;
}
@property (strong, nonatomic) NSArray *pageTitleArray;
@property (weak, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end
