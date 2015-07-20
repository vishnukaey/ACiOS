//
//  LCTutorialContainerVC.m
//  LegacyConnect
//
//  Created by qbuser on 7/20/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCTutorialContainerVC.h"

@interface LCTutorialContainerVC ()

@end

@implementation LCTutorialContainerVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.pageTitle = @[@"",@"",@""];
  _pageController = [self getChildViewControllerOfType:[UIPageViewController class]];
  [self.pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
  UIPageControl *pageControl = [UIPageControl appearance];
  pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
  pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
  pageControl.backgroundColor = [UIColor whiteColor];
  self.pageController.dataSource =self;
  self.pageController.delegate =self;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


-(id) getChildViewControllerOfType:(id)type
{
  for(id vc in self.childViewControllers)
  {
    if([vc isKindOfClass:type])
    {
      return vc;
    }
  }
  return nil;
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
  NSUInteger index = ((LCFinalTutorialVC*) viewController).pageIndex;
  
  if ((index == 0) || (index == NSNotFound)) {
    return nil;
  }
  
  index--;
  return [self viewControllerAtIndex:index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
  NSUInteger index = ((LCFinalTutorialVC*) viewController).pageIndex;
  
  if (index == NSNotFound) {
    return nil;
  }
  
  index++;
  if (index == [self.pageTitle count]) {
    return nil;
  }
  
  return [self viewControllerAtIndex:index];
}



- (LCFinalTutorialVC *)viewControllerAtIndex:(NSUInteger)index
{
  if (([self.pageTitle count] == 0) || (index >= [self.pageTitle count])) {
    return nil;
  }
  // Create a new view controller and pass suitable data.
  LCFinalTutorialVC *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"page1"];
  pageContentViewController.pageIndex = index;
  
  return pageContentViewController;
}



- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
  return [self.pageTitle count];
}


- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
  return 0;
}


- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
  LCFinalTutorialVC *vc = [pendingViewControllers lastObject];
  if(vc.pageIndex+1 == [self.pageTitle count])
  {
    [_nextButton setTitle:@"GOT IT" forState:UIControlStateNormal];
  }
  else
  {
    [_nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
  }
}

//- (void)goToNextPage:(id)sender
//{
//  
//}
//
//- (void)finishedTutorial:(id)sender
//{
//  
//}

@end
