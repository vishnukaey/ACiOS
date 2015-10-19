//
//  LCListInterestsAndCausesVCViewController.m
//  LegacyConnect
//
//  Created by Jijo on 10/19/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCListInterestsAndCausesVC.h"
#import "LCTabMenuView.h"

@interface LCListInterestsAndCausesVC ()
{
  IBOutlet UIView *tabMenuContainer;
  IBOutlet UICollectionView *causesCollectionView;
  IBOutlet UITableView *interestsTableView;
  
  IBOutlet UIButton *interestsButton, *causesButton;
}
@end

@implementation LCListInterestsAndCausesVC
#pragma mark - lifecycle methods
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  [self addTabMenu];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - setup functions
- (void)addTabMenu
{
  
  LCTabMenuView *tabmenu = [[LCTabMenuView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [tabMenuContainer addSubview:tabmenu];
  [tabmenu setBackgroundColor:[UIColor whiteColor]];
  tabmenu.translatesAutoresizingMaskIntoConstraints = NO;
  tabMenuContainer.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
  
  NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:top];
  
  NSLayoutConstraint *bottom =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:bottom];
  
  NSLayoutConstraint *left =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:left];
  
  NSLayoutConstraint *right =[NSLayoutConstraint constraintWithItem:tabMenuContainer attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:tabmenu attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
  [tabMenuContainer addConstraint:right];
  
  
  tabmenu.menuButtons = [[NSArray alloc] initWithObjects:interestsButton, causesButton, nil];
  tabmenu.views = [[NSArray alloc] initWithObjects:interestsTableView,  causesCollectionView, nil];
  
  tabmenu.highlightColor = [UIColor colorWithRed:239.0f/255.0 green:100.0f/255.0 blue:77.0f/255.0 alpha:1.0];
  tabmenu.normalColor = [UIColor colorWithRed:40.0f/255.0 green:40.0f/255.0 blue:40.0f/255.0 alpha:1.0];
}

#pragma mark - button actions
-(IBAction)doneButtonAction
{
  NSLog(@"done button clicked-->>>");
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction
{
  [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
