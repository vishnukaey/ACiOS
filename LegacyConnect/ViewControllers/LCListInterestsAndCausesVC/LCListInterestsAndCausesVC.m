//
//  LCListInterestsAndCausesVCViewController.m
//  LegacyConnect
//
//  Created by Jijo on 10/19/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCListInterestsAndCausesVC.h"
#import "LCTabMenuView.h"
#import "LCInterestsCellView.h"

@interface LCListInterestsAndCausesVC ()
{
  IBOutlet UIView *tabMenuContainer;
  IBOutlet UICollectionView *causesCollectionView;
  IBOutlet UITableView *interestsTableView;
  
  IBOutlet UIButton *interestsButton, *causesButton;
  
  NSArray *interestsArray, *causesArray;
  NSMutableArray *interestsSearchArray, *causesSearchArray;
  
  LCInterest *selectedInterest;
  LCCause *selectedCause;
}
@end

static NSString *kUnCheckedImageName = @"tagFirend_unselected";
static NSString *kCheckedImageName = @"contact_tick";

#pragma mark - LCTagCauseCollectionCell class
@interface LCTagCauseCollectionCell : UICollectionViewCell
@property(nonatomic, strong)IBOutlet UIImageView *causeImageView;
@property(nonatomic, strong)IBOutlet UIButton *checkButton;
@property(nonatomic, strong)IBOutlet UILabel *testlabel;
@property(nonatomic, strong) LCCause *cause;
@end

@implementation LCTagCauseCollectionCell
-(void)setCause:(LCCause *)cause
{
  _cause = cause;
  
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1.0] CGColor]);
  CGContextFillRect(context, rect);
  UIImage *placeHolder_image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  _testlabel.text = cause.name;
  
  [_causeImageView sd_setImageWithURL:[NSURL URLWithString:cause.logoURLSmall] placeholderImage:placeHolder_image];//no placeholder needed. background color is placeholder itself
}
@end

#pragma mark - LCTagCauseCollectionSectionHeader class
@interface LCTagCauseCollectionSectionHeader : UICollectionReusableView
@property(nonatomic, strong)IBOutlet UILabel *headerLabel;
@end

@implementation LCTagCauseCollectionSectionHeader
@end


#pragma mark - LCListInterestsAndCausesVC class
@implementation LCListInterestsAndCausesVC
@synthesize delegate;
#pragma mark - lifecycle methods
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  interestsSearchArray = [[NSMutableArray alloc] init];
  causesSearchArray = [[NSMutableArray alloc] init];
  
  [self addTabMenu];
  [self loadInterestsAndCauses];
  
  UIView *zeroRectView = [[UIView alloc] initWithFrame:CGRectZero];
  interestsTableView.tableFooterView = zeroRectView;
  
  UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*)causesCollectionView.collectionViewLayout;
  collectionViewLayout.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
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

- (void)loadInterestsAndCauses
{
  [MBProgressHUD showHUDAddedTo:interestsTableView.superview animated:YES];
  [LCAPIManager getUserInterestsAndCausesWithSuccess:^(NSArray *responses) {
    interestsArray = responses;
    [interestsSearchArray addObjectsFromArray:responses];
    [interestsTableView reloadData];
    NSMutableArray *nonZeroCausedInterests = [[NSMutableArray alloc] init];
    for (LCInterest *interest in responses)
    {
      if (interest.causes.count>0)
      {
        [nonZeroCausedInterests addObject:interest];
      }
    }
    causesArray = [nonZeroCausedInterests copy];
    causesArray = [self sortedInterestCauses:causesArray];
    [causesSearchArray addObjectsFromArray:causesArray];
    [causesCollectionView reloadData];
    [MBProgressHUD hideAllHUDsForView:interestsTableView.superview animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideAllHUDsForView:interestsTableView.superview animated:YES];
    NSLog(@"%@",error);
  }];
}

- (NSArray *)sortedInterestCauses :(NSArray *)Interests
{
  for (LCInterest *interest in Interests)
  {
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [interest.causes sortedArrayUsingDescriptors:sortDescriptors];
    if ([sortedArray containsObject:selectedCause]) {
      NSMutableArray *arrayto_rearrange = [[NSMutableArray alloc] initWithArray:sortedArray];
      [arrayto_rearrange removeObject:selectedCause];
      [arrayto_rearrange insertObject:selectedCause atIndex:0];
      sortedArray = [arrayto_rearrange copy];
    }
    interest.causes = sortedArray;
  }
  
  return Interests;
}

#pragma mark - button actions
-(IBAction)doneButtonAction
{
  NSLog(@"done button clicked-->>>");
  [delegate didfinishPickingInterest:selectedInterest andCause:selectedCause];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - searchfield delegates
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  //interest search
  [interestsSearchArray removeAllObjects];
  if([searchText length] != 0) {
    for (int i = 0; i<interestsArray.count ; i++)
    {
      LCInterest *interest = interestsArray[i];
      NSString * tempStr = interest.name;
      NSComparisonResult result = [tempStr compare:searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchBar.text length])];
      if (result == NSOrderedSame)
      {
        [interestsSearchArray addObject:interest];
      }
    }
  }
  else
  {
    [interestsSearchArray addObjectsFromArray:interestsArray];
  }
  [interestsTableView reloadData];
  
  //cause search
  [causesSearchArray removeAllObjects];
  if([searchText length] != 0) {
    for (int i = 0; i<causesArray.count ; i++)
    {
      LCInterest *interest = [causesArray[i] copy];
      NSMutableArray *causes_ = [[NSMutableArray alloc] init];
      for (LCCause *cause in interest.causes)
      {
        NSString * tempStr = cause.name;
        if (tempStr.length>=[searchBar.text length]) {
          NSComparisonResult result = [tempStr compare:searchBar.text options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchBar.text length])];
          if (result == NSOrderedSame)
          {
            [causes_ addObject:cause];
          }
        }
      }
      if (causes_.count>0)
      {
        interest.causes = [causes_ copy];
        [causesSearchArray addObject:interest];
      }
    }
    NSArray *sortedCauses = [self sortedInterestCauses:[causesSearchArray copy]];
    [causesSearchArray removeAllObjects];
    [causesSearchArray addObjectsFromArray:sortedCauses];
  }
  else
  {
    [causesSearchArray addObjectsFromArray:[self sortedInterestCauses:causesArray]];
  }
  [causesCollectionView reloadData];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (interestsArray.count==0)
  {
    return 1;
  }
  return interestsSearchArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (interestsArray.count == 0)
  {
    NSString * message = @"Search and add interests from the menu.";
    UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    return cell;
  }
  else
  {
    static NSString *MyIdentifier = @"LCInterestsCell";
    LCInterestsCellView *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"LCInterestsCellView" owner:self options:nil];
      cell = [topLevelObjects objectAtIndex:0];
    }
    
    LCInterest *interstObj = [interestsSearchArray objectAtIndex:indexPath.row];
    [cell setData:interstObj];
    tableView.backgroundColor = [tableView.superview backgroundColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.allowsSelection = YES;
    
    UIView *sel_but = [cell viewWithTag:10];
    [sel_but removeFromSuperview];
    
    UIButton *selectionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    selectionButton.center = CGPointMake(cell.frame.size.width - 30, cell.frame.size.height/2 - 8);
    [cell addSubview:selectionButton];
    selectionButton.tag = 10;
    selectionButton.userInteractionEnabled = NO;
    if ([interstObj isEqual:selectedInterest])
    {
      [selectionButton setImage:[UIImage imageNamed:kCheckedImageName] forState:UIControlStateNormal];
    }
    else
    {
      [selectionButton setImage:[UIImage imageNamed:kUnCheckedImageName] forState:UIControlStateNormal];
    }
    
    return cell;
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 135;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  selectedCause = nil;
  selectedInterest = [interestsSearchArray objectAtIndex:indexPath.row];
  
  NSArray *sortedCauses = [causesSearchArray copy];
  [causesSearchArray removeAllObjects];
  [causesSearchArray addObjectsFromArray:[self sortedInterestCauses:sortedCauses]];
  [causesCollectionView reloadData];
  [interestsTableView reloadData];
}

#pragma mark - collectionview delegates
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return [causesSearchArray count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  LCInterest *interest_ = [causesSearchArray objectAtIndex:section];
  NSLog(@"interest-->>>%@", interest_);
  return [interest_.causes count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *identifier = @"LCTagCauseCollectionCell";
  
  LCTagCauseCollectionCell *cell = (LCTagCauseCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  
  LCInterest *interstObj = [causesSearchArray objectAtIndex:indexPath.section];
  LCCause *causeObj = [interstObj.causes objectAtIndex:indexPath.row];
  [cell setCause:causeObj];
  if ([causeObj isEqual:selectedCause])
  {
    [cell.checkButton setImage:[UIImage imageNamed:kCheckedImageName] forState:UIControlStateNormal];
  }
  else
  {
    [cell.checkButton setImage:[UIImage imageNamed:kUnCheckedImageName] forState:UIControlStateNormal];
  }
  
//  cell.layer.borderColor = [UIColor blackColor].CGColor;
//  cell.layer.borderWidth = 2;
  
  return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  float size = ([[UIScreen mainScreen] bounds].size.width - 8*4)/3;
  return CGSizeMake(size, size);  // will be w120xh100 or w190x100
  // if the width is higher, only one image will be shown in a line
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
  return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
  return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  LCInterest *interest_ = [causesSearchArray objectAtIndex:indexPath.section];
  LCInterest *interest_copy = [interest_ copy];
  selectedCause = [interest_.causes objectAtIndex:indexPath.row];
  selectedInterest = nil;
  
  NSArray *sortedCauses = [causesSearchArray copy];
  [causesSearchArray removeAllObjects];
  [causesSearchArray addObjectsFromArray:[self sortedInterestCauses:sortedCauses]];
  [interestsTableView reloadData];
  
  [causesCollectionView performBatchUpdates:^{
    for (NSInteger i = 0; i < interest_.causes.count; i++) {
      NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
      NSInteger j = [interest_copy.causes indexOfObject:interest_.causes[i]];
      NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:j inSection:indexPath.section];
      [causesCollectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
    }
  } completion:^(BOOL finished) {
    [causesCollectionView reloadData];
  }];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  UICollectionReusableView *reusableview = nil;
  
  if (kind == UICollectionElementKindSectionHeader) {
    LCTagCauseCollectionSectionHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"LCTagCauseCollectionSectionHeader" forIndexPath:indexPath];
    LCInterest *interest_ = [causesSearchArray objectAtIndex:indexPath.section];
    headerView.headerLabel.text = interest_.name;
    reusableview = headerView;
  }
  if (kind == UICollectionElementKindSectionFooter) {
    UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
    
    reusableview = footerview;
  }
  return reusableview;
}



@end
