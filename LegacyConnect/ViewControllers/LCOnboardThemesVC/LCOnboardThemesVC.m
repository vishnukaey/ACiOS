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
#import "LCOnboardingHelper.h"


@interface LCOnboardThemesVC ()
{
  IBOutlet UIButton *nextButton;
  IBOutlet UILabel *infoLabel1, *inforLabel2;;
  NSMutableArray *themesArray;
}
@end

@implementation LCOnboardThemesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  themesArray = [[NSMutableArray alloc] init];
  self.themesTable.separatorColor = [UIColor clearColor];
  nextButton.enabled = NO;
  [MBProgressHUD showHUDAddedTo:self.themesTable animated:YES];
   [LCThemeAPIManager getThemesWithLastId:nil withSuccess:^(id response) {
     [MBProgressHUD hideAllHUDsForView:self.themesTable animated:YES];
     themesArray = response;
     [self reloadTable];
   } andFailure:^(NSString *error) {
     [MBProgressHUD hideAllHUDsForView:self.themesTable animated:YES];
   }];
  
  NSString *infoText_2 = @"If you don't have one, that's okay! Choose a few Interests below and we'll fill your feed with news from related causes that you can follow later.";
  NSMutableAttributedString *attributedString_2 = [[NSMutableAttributedString alloc] initWithString:infoText_2];
  NSMutableParagraphStyle *paragraphStyle_2 = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle_2 setLineSpacing:5];
  [attributedString_2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle_2 range:NSMakeRange(0, [infoText_2 length])];
  inforLabel2.attributedText = attributedString_2 ;
  
  
  NSString *infoText_1 = @"To get started, search for the name of a specific Cause if you have one in mind.";
  NSMutableAttributedString *attributedString_1 = [[NSMutableAttributedString alloc] initWithString:infoText_1];
  NSMutableParagraphStyle *paragraphStyle_1 = [[NSMutableParagraphStyle alloc] init];
  [paragraphStyle_1 setLineSpacing:5];
  [attributedString_1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle_1 range:NSMakeRange(0, [infoText_1 length])];
  infoLabel1.attributedText = attributedString_1 ;
}


- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  [self reloadTable];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (IBAction) nextButtonTapped:(id)sender
{
  [self performSegueWithIdentifier:@"causeSummary" sender:self];
}

- (void)reloadTable
{
//  for (LCTheme *theme in themesArray) {
//    theme.interests = [LCOnboardingHelper sortInterests:theme.interests forTheme:theme];
//  }
  [self.themesTable reloadData];
  [nextButton setEnabled:![LCOnboardingHelper noInterestSelected]];
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
  cell.theme = theme;
  cell.nextButton = nextButton;
  
  cell.separatorInset = UIEdgeInsetsMake(0.f, cell.bounds.size.width, 0.f, 0.f);
  
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
