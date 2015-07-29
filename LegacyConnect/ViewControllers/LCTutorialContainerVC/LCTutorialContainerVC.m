//
//  LCTutorialContainerVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/20/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCTutorialContainerVC.h"

@interface LCTutorialContainerVC ()

@end

@implementation LCTutorialContainerVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setUpPageViewController];
}


- (void) viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  NSArray *subviews = self.pageViewController.view.subviews;
  
  for (int i=0; i<[subviews count]; i++) {
    if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]]) {
      pageControl = (UIPageControl *)[subviews objectAtIndex:i];
    }
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (void) setUpPageViewController
{
  self.pageTitleArray = @[@"Tutorial Page1",@"Tutorial Page2",@"Tutorial Page3"];
  _pageViewController = [self getChildViewControllerOfType:[UIPageViewController class]];
  [self.pageViewController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
  pageControl = [UIPageControl appearance];
  pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
  pageControl.currentPageIndicatorTintColor = [UIColor redColor];
  pageControl.backgroundColor = [UIColor whiteColor];
  
  self.pageViewController.dataSource =self;
  self.pageViewController.delegate =self;
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
  if (index == [self.pageTitleArray count]) {
    return nil;
  }
  
  return [self viewControllerAtIndex:index];
}


- (LCFinalTutorialVC *)viewControllerAtIndex:(NSUInteger)index
{
  if (([self.pageTitleArray count] == 0) || (index >= [self.pageTitleArray count])) {
    return nil;
  }
  LCFinalTutorialVC *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"page1"];
  pageContentViewController.pageIndex = index;
  
  return pageContentViewController;
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
  return [self.pageTitleArray count];
}


- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
  return 0;
}

- (void) pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
  LCFinalTutorialVC *pageContentVC = pendingViewControllers[0];
  [self updateNextButtonTitleForPageIndex:pageContentVC.pageIndex];
}


- (IBAction)nextButtonTapped:(id)sender
{
  if(_nextButton.selected)
  {
    [self.navigationController popToRootViewControllerAnimated:YES];
  }
  else
  {
    LCFinalTutorialVC *final = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = nil;
    viewControllers = [NSArray arrayWithObjects:[self viewControllerAtIndex:final.pageIndex+1], nil];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    pageControl.currentPage = final.pageIndex+1;
    [self updateNextButtonTitleForPageIndex:final.pageIndex+1];
  }
}


-(void) updateNextButtonTitleForPageIndex:(NSInteger)pageIndex
{
  if(pageIndex == [_pageTitleArray count]-1)
  {
    _nextButton.selected = YES;
  }
  else
  {
    _nextButton.selected = NO;
  }
}

@end
