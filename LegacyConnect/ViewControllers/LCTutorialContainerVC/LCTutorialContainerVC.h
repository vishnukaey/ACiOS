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
@property (strong, nonatomic) NSArray *pageTitle;
@property (weak, nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end
