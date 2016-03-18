//
//  LCAboutViewController.h
//  LegacyConnect
//
//  Created by Kaey on 14/03/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCAboutViewController : UIViewController <UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@end
