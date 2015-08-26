//
//  LCSearchViewController.m
//  LegacyConnect
//
//  Created by qbuser on 8/26/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCSearchViewController.h"

@interface LCSearchViewController ()

@end

@implementation LCSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  [self.searchBar becomeFirstResponder];
  
  UIButton *topButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [topButton setTitle:@"Top" forState:UIControlStateNormal];
  UIButton *usersButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [usersButton setTitle:@"Users" forState:UIControlStateNormal];
  UIButton *interestsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [interestsButton setTitle:@"Interests" forState:UIControlStateNormal];
  UIButton *causesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [causesButton setTitle:@"Causes" forState:UIControlStateNormal];
  
  self.tabMenu.menuButtons = @[topButton,usersButton ,interestsButton, causesButton];
  self.tabMenu.views = @[_tableView, _tableView, _tableView, _collectionView];
  self.tabMenu.highlightColor = [UIColor orangeColor];
  self.tabMenu.normalColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"userTableViewCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}




-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 10;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"causesCollectionViewCell";
  UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}






- (IBAction)searchCancelButtonClicked:(UIButton *)cancelButton
{
  [self.navigationController popViewControllerAnimated:YES];
}

@end
