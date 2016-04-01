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
  NSTimer *timer;
  bool transitionInProgress;
}
@property (nonatomic) UIPageControl *pageControl;
@property(nonatomic, assign) int currentIndex;

@end

@implementation LCAboutViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  _pageControl = [UIPageControl appearance];
  _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
  _pageControl.currentPageIndicatorTintColor = [LCUtilityManager getThemeRedColor];
  
  _pageTitles = @[@"aboutPage1_Text", @"aboutPage2_Text", @"aboutPage3_Text", @"aboutPage4_Text"];
  _pageImages = @[@"AboutPage1", @"AboutPage2", @"AboutPage3", @"AboutPage4"];

  // Create page view controller
  self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
  self.pageViewController.dataSource = self;
  self.pageViewController.delegate = self;
  
  LCAboutPageContentVC *startingViewController = [self viewControllerAtIndex:0];
  NSArray *viewControllers = @[startingViewController];
  [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
  
  _pageControl.numberOfPages = _pageTitles.count;
  _pageControl.currentPage = 0;

  // Change the size of page view controller
  self.pageViewController.view.frame = [[self view] bounds];
  [self addChildViewController:_pageViewController];
  [self.view addSubview:_pageViewController.view];
  [self.pageViewController didMoveToParentViewController:self];
  
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self restartTimer];
}

-(void)invalidateTimer
{
  [timer invalidate];
  timer= nil;

  
}

-(void)restartTimer
{
  [self invalidateTimer];
  timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                           target:self
                                         selector:@selector(loadNextController)
                                         userInfo:nil
                                          repeats:YES];

}


-(void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [self invalidateTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
  
  NSUInteger index = ((LCAboutPageContentVC*) viewController).pageIndex;
  
  if (index == NSNotFound)
  {
    return nil;
  }
  
  if(index == 0)
  {
    return [self viewControllerAtIndex:[self.pageTitles count]];
  }
  _currentIndex = (int)index;
  index--;
  return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSUInteger index = ((LCAboutPageContentVC*) viewController).pageIndex;
  
  if (index == NSNotFound) {
    return nil;
  }
  _currentIndex = (int)index;
  index++;
  if (index == [self.pageTitles count])
  {
    return [self viewControllerAtIndex:0];
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
//  _currentIndex = (int)index;
  
  return pageContentViewController;
}

/*! set next controller */
- (void)loadNextController
{
  _currentIndex++;
  LCAboutPageContentVC *nextViewController = [self viewControllerAtIndex:_currentIndex];
  if (nextViewController == nil) {
    _currentIndex = 0;
    nextViewController = [self viewControllerAtIndex:_currentIndex];
  }
  [_pageControl setCurrentPage:_currentIndex];
  
  __weak typeof(self) weakSelf = self;
  if (!transitionInProgress) {
    [self.pageViewController setViewControllers:@[nextViewController] direction:UIPageViewControllerNavigationDirectionForward animated:YES  completion:^(BOOL finished) {
      transitionInProgress = !finished;
      [weakSelf.pageControl setCurrentPage:weakSelf.currentIndex];
    }];
  }
}


-(void) pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
  LCAboutPageContentVC *currentViewController = pageViewController.viewControllers[0];
  _currentIndex = (int)currentViewController.pageIndex;
  [_pageControl setCurrentPage:_currentIndex];
  [self restartTimer];
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
  return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
  return _currentIndex;
}

@end
