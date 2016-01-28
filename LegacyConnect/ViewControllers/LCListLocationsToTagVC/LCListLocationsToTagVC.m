//
//  LCListLocationsToTagVC.m
//  LegacyConnect
//
//  Created by Jijo on 8/25/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCListLocationsToTagVC.h"
#import "LCMultipleSelectionTable.h"

@interface LCListLocationsToTagVC ()
{
  IBOutlet LCMultipleSelectionTable *locationsTable;
  NSMutableArray *locationsArray;
  IBOutlet LCLocationSearchField *searchTextField;
}

@end

#pragma mark - LCLocationCell class
@interface LCLocationCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *locationLabel;
@property(nonatomic, strong)IBOutlet UIButton *checkButton;
@end

@implementation LCLocationCell
@end

#pragma mark - LCListLocationsToTagVC class

#pragma mark - controller life cycle
@implementation LCListLocationsToTagVC
@synthesize alreadyTaggedLocation, delegate;
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  locationsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  locationsTable.checkedImage = [UIImage imageNamed:@"contact_tick"];
  locationsTable.uncheckedImage = [UIImage imageNamed:@"tagFirend_unselected"];
  locationsArray = [[NSMutableArray alloc] init];
  if (alreadyTaggedLocation.length>0)
  {
    [locationsArray addObject:alreadyTaggedLocation];
    [locationsTable.selectedIDs addObject:alreadyTaggedLocation];
  }
  [searchTextField setReturnKeyType:UIReturnKeyDone];
  searchTextField.locdelegate = self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
-(IBAction)doneButtonAction
{
  if (locationsTable.selectedIDs.count>0)
  {
    [delegate didfinishPickingLocation:[locationsTable.selectedIDs objectAtIndex:0]];//only one location will be available in selected ids(here id is the location name itself as no id for a location is used)
  }
  else
  {
    [delegate didfinishPickingLocation:@""];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelAction
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkbuttonAction :(UIButton *)sender
{
  if (locationsTable.selectedIDs.count>0)
  {
    
    if ([[locationsTable.selectedIDs objectAtIndex:0] isEqualToString:[locationsArray objectAtIndex:sender.tag]]) {
      [locationsTable.selectedIDs removeAllObjects];
    }
    else
    {
      [locationsTable.selectedIDs removeAllObjects];
      [locationsTable.selectedIDs addObject:[locationsArray objectAtIndex:sender.tag]];
    }
  }
  else
  {
    [locationsTable.selectedIDs addObject:[locationsArray objectAtIndex:sender.tag]];
  }
  [locationsTable reloadData];
}

#pragma mark - locationSearchField delegates
- (void)recievedLocations:(NSArray *)locations
{
  [locationsArray removeAllObjects];
  [locationsArray addObjectsFromArray:locationsTable.selectedIDs];
  [locationsArray addObjectsFromArray:locations];
  NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:locationsArray];
  NSArray *locWithoutDuplicates = [orderedSet array];
  [locationsArray removeAllObjects];
  [locationsArray addObjectsFromArray:locWithoutDuplicates];
  [locationsTable reloadData];
}

- (void)searchBar:(LCLocationSearchField *)searchBar textDidChange:(NSString *)searchText
{
  [searchBar searchForLocations:searchText];
}


-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
  [searchBar resignFirstResponder];
}
#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (locationsArray.count == 0)
  {
    return 1;
  }
  return locationsArray.count;
}

- (UITableViewCell *)tableView:(LCMultipleSelectionTable *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (locationsArray.count == 0)
  {
    NSString * message = NSLocalizedString(@"no_results_found", nil);
    UITableViewCell *cell = [LCUtilityManager getEmptyIndicationCellWithText:message];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    return cell;
  }
  
  static NSString *MyIdentifier = @"LCLocationCell";
  LCLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCLocationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:MyIdentifier];
  }
  cell.locationLabel.text = [locationsArray objectAtIndex:indexPath.row];
  [cell.checkButton addTarget:self action:@selector(checkbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
  cell.checkButton.tag = indexPath.row;
  [tableView setStatusForButton:cell.checkButton byCheckingIDs:@[locationsArray[indexPath.row]]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LCLocationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [self checkbuttonAction:cell.checkButton];
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
