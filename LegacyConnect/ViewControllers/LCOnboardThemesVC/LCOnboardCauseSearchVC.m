//
//  LCOnboardCauseSearchVC.m
//  LegacyConnect
//
//  Created by Jijo on 12/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCOnboardCauseSearchVC.h"
#import "LCChooseCausesCollectionViewCell.h"
#import "LCOnboardingHelper.h"
#import "LCCauseCollectionReusableView.h"

@interface LCOnboardCauseSearchVC ()
{
  NSMutableArray *causesArray;
  NSTimer *searchTimer;
}
@end

@implementation LCOnboardCauseSearchVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  causesArray = [[NSMutableArray alloc] init];
  [self addSelectedCausesToDataSourcce];
  [self refreshList];
  [self setSearchBarProperties];
  [self.searchBar becomeFirstResponder];
}

- (void)setSearchBarProperties
{
  for (UIView *subview in self.searchBar.subviews)
  {
    for (UIView *subSubview in subview.subviews)
    {
      if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
      {
        UITextField *textField = (UITextField *)subSubview;
        [textField setEnablesReturnKeyAutomatically:NO];
        //        [textField setKeyboardAppearance: UIKeyboardAppearanceAlert];
        textField.returnKeyType = UIReturnKeyDone;
        break;
      }
    }
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


#pragma mark - collection view delegates
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [(LCInterest*)causesArray[section] causes].count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return causesArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *cellIdentifier = @"causesCell";
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
  if (cell == nil)
  {
    NSArray *cells =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LCChooseCausesCollectionViewCell class]) owner:nil options:nil];
    cell=cells[0];
  }
  cell.cause = [(LCInterest*)causesArray[indexPath.section] causes][indexPath.row];
  if([LCOnboardingHelper isCauseSelected:cell.cause])
  {
    cell.selectionButton.selected = YES;
  }
  else
  {
    cell.selectionButton.selected = NO;
  }
  return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *reusableview = nil;
  if (kind == UICollectionElementKindSectionHeader)
  {
    LCCauseCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    LCInterest *interest = causesArray[indexPath.section];
    headerView.sectionHeader.text = interest.name;
    reusableview = headerView;
  }
  return reusableview;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  float size = ([[UIScreen mainScreen] bounds].size.width - 15*4)/3;
  return CGSizeMake(size, 140);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCChooseCausesCollectionViewCell *cell = (LCChooseCausesCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
  if([LCOnboardingHelper isCauseSelected:cell.cause])
  {
    [LCOnboardingHelper removeCause:cell.cause];
    cell.selectionButton.selected = NO;
  }
  else
  {
    cell.selectionButton.selected = YES;
    [LCOnboardingHelper addCause:cell.cause andInterest:causesArray[indexPath.section]];
  }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
  [causesArray removeAllObjects];
  causesArray = [[[LCOnboardingHelper selectedItemsDictionary] allValues] mutableCopy];
  [self refreshList];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
  // Do the search...
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  NSString * trimmedText = [LCUtilityManager getSpaceTrimmedStringFromString:searchText];
  if (searchTimer)
  {
    if ([searchTimer isValid]) { [searchTimer invalidate]; }
    searchTimer = nil;
  }
  if(searchBar.text.length == 0 || searchText == nil || trimmedText == nil || trimmedText.length == 0)
  {
    [causesArray removeAllObjects];
    [self addSelectedCausesToDataSourcce];
    [self refreshList];
  }
  else
  {
    searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(searchRequest) userInfo:trimmedText repeats:NO];
  }
}


-(void)searchRequest
{
  [LCSearchAPIManager searchCausesWithInterestForSearchText:[LCUtilityManager getSpaceTrimmedStringFromString:_searchBar.text] lastId:@"" withSuccess:^(id response) {
    [causesArray removeAllObjects];
    [causesArray addObjectsFromArray:response];
    [self refreshList];
  } andfailure:^(NSString *error) {
  }];
}


-(IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)doneButtonTapped:(id)sender
{
  NSDictionary *selectedItems = [LCOnboardingHelper selectedItemsDictionary];
  NSArray *interestsToSave = [selectedItems allKeys];
  NSArray *allInterests = [selectedItems allValues];
  NSMutableArray *causesToSave = [[NSMutableArray alloc] init];
  for(LCInterest *interest in allInterests) {
    for (LCCause *cause in interest.causes) {
      [causesToSave addObject:cause.causeID];
    }
  }
  
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCThemeAPIManager saveCauses:causesToSave
                   andInterests:interestsToSave
                         ofUser:[LCDataManager sharedDataManager].userID
                    withSuccess:^(id response) {
                      [[LCOnboardingHelper selectedItemsDictionary] removeAllObjects];
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                      [self performSegueWithIdentifier:@"connectFriends" sender:self];
                    } andFailure:^(NSString *error) {
                      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
}

-(void)addSelectedCausesToDataSourcce
{
  causesArray = [[[LCOnboardingHelper selectedItemsDictionary] allValues] mutableCopy];
  for(int i = 0 ; i<causesArray.count ; i++)
  {
    LCInterest *interest = causesArray[i];
    if(!interest.causes.count)
    {
      [causesArray removeObject:interest];
      i--;
    }
  }
}


-(void) refreshList
{
  if(causesArray.count == 0)
  {
    _noCausesLabel.hidden  = NO;
  }
  else
  {
    _noCausesLabel.hidden = YES;
  }
  [_causesCollectionView reloadData];
}


@end
