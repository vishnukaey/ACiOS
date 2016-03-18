//
//  LCAboutViewController.m
//  LegacyConnect
//
//  Created by Kaey on 14/03/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCAboutViewController.h"
#import "LCAboutPageContentVC.h"

@interface LCAboutViewController ()
{
  int currentIndex;
  UIPageControl *pageControl;
}
@end

@implementation LCAboutViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  pageControl = [UIPageControl appearance];
  pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
  pageControl.currentPageIndicatorTintColor = [LCUtilityManager getThemeRedColor];
  
  _pageTitles = @[@"aboutPage1_Text", @"aboutPage2_Text", @"aboutPage3_Text", @"aboutPage4_Text"];
  _pageImages = @[@"AboutPage1", @"AboutPage2", @"AboutPage3", @"AboutPage4"];
  
  [NSTimer scheduledTimerWithTimeInterval:3.0
                                   target:self
                                 selector:@selector(loadNextController)
                                 userInfo:nil
                                  repeats:YES];

  // Create page view controller
  self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
  self.pageViewController.dataSource = self;
  self.pageViewController.delegate = self;
  
  LCAboutPageContentVC *startingViewController = [self viewControllerAtIndex:0];
  NSArray *viewControllers = @[startingViewController];
  [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
  
  pageControl.numberOfPages = _pageTitles.count;
  pageControl.currentPage = 0;

  // Change the size of page view controller
  self.pageViewController.view.frame = [[self view] bounds];
  [self addChildViewController:_pageViewController];
  [self.view addSubview:_pageViewController.view];
  [self.pageViewController didMoveToParentViewController:self];
  
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
  
  NSUInteger index = ((LCAboutPageContentVC*) viewController).pageIndex;
  
  if ((index == 0) || (index == NSNotFound)) {
    return nil;
  }
  
  index--;
  return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSUInteger index = ((LCAboutPageContentVC*) viewController).pageIndex;
  
  if (index == NSNotFound) {
    return nil;
  }
  
  index++;
  if (index == [self.pageTitles count]) {
    return nil;
  }
  return [self viewControllerAtIndex:index];
}



- (LCAboutPageContentVC *)viewControllerAtIndex:(NSUInteger)index
{
  if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
    return nil;
  }
  
  // Create a new view controller and pass suitable data.
  LCAboutPageContentVC *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
  pageContentViewController.imageFile = self.pageImages[index];
  pageContentViewController.titleText = self.pageTitles[index];
  pageContentViewController.pageIndex = index;
  currentIndex = (int)index;
  
  return pageContentViewController;
}

/*! set next controller */
- (void)loadNextController
{
  currentIndex++;
  LCAboutPageContentVC *nextViewController = [self viewControllerAtIndex:currentIndex];
  if (nextViewController == nil) {
    currentIndex = 0;
    nextViewController = [self viewControllerAtIndex:currentIndex];
  }
  [pageControl setCurrentPage:currentIndex];
  [self.pageViewController setViewControllers:@[nextViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
  [pageControl setCurrentPage:currentIndex];
}


-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
  LCAboutPageContentVC *currentViewController = pageViewController.viewControllers[0];
  currentIndex = (int)currentViewController.pageIndex;
  [pageControl setCurrentPage:currentIndex];
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
  return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
  return currentIndex;
}

@end
