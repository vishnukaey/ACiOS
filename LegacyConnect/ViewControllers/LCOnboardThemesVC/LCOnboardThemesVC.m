//
//  LCChooseCausesVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCOnboardThemesVC.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCChooseInterestCVC.h"
#import "LCHorizontalInterestsCell.h"
#import "LCOnboardInterestsVC.h"


@interface LCOnboardThemesVC ()
{
  IBOutlet UIButton *nextButton;
  NSMutableArray *themesArray;

}
@end

@implementation LCOnboardThemesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  themesArray = [[NSMutableArray alloc] init];
  
   [LCThemeAPIManager getThemesWithLastId:nil withSuccess:^(id response) {
     themesArray = response;
     [self.themesTable reloadData];
   } andFailure:^(NSString *error) {
     
   }];
}


- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  [self.themesTable reloadData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction) nextButtonTapped:(id)sender
{
  [self performSegueWithIdentifier:@"causeSummary" sender:self];
}

- (void)showAllClicked :(UIButton *)sender
{
  LCTheme *theme = [themesArray objectAtIndex:sender.tag];
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:kSignupStoryBoardIdentifier bundle:nil];
  LCOnboardInterestsVC *vc = [sb instantiateViewControllerWithIdentifier:@"LCOnboardInterestsVC"];
  vc.theme = theme;
  [self.navigationController pushViewController:vc animated:YES];;
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return themesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier_ = @"horizontalInterestsCell";
  LCHorizontalInterestsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_];
  if (cell == nil)
  {
    cell = [[LCHorizontalInterestsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:identifier_];
  }
  cell.showAllButton.tag = indexPath.row;
  [cell.showAllButton addTarget:self action:@selector(showAllClicked:) forControlEvents:UIControlEventTouchUpInside];
  LCTheme *theme = [themesArray objectAtIndex:indexPath.row];
  cell.interestsArray = theme.interests;
  cell.themeLabel.text = theme.name;
  
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 167;
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
  [self performSegueWithIdentifier:@"searchCauses" sender:self];
  return NO;
}

@end
