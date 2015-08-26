//
//  LCListLocationsToTagVC.m
//  LegacyConnect
//
//  Created by Jijo on 8/25/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCListLocationsToTagVC.h"

@interface LCListLocationsToTagVC ()
{
  IBOutlet UITableView *locationsTable;
  NSMutableArray *locationsArray;
}

@end

#pragma mark - LCLocationCell class
@interface LCLocationCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *locationLabel;
@end

@implementation LCLocationCell
@end

#pragma mark - LCListLocationsToTagVC class

#pragma mark - controller life cycle
@implementation LCListLocationsToTagVC

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  locationsArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

#pragma mark - locationSearchField delegates
- (void)recievedLocations:(NSArray *)locations
{
  [locationsArray removeAllObjects];
  [locationsArray addObjectsFromArray:locations];
  [locationsTable reloadData];
  NSLog(@"locations--->>>>%@", locations);
}

- (void)searchBar:(LCLocationSearchField *)searchBar textDidChange:(NSString *)searchText
{
  NSLog(@"searchbar delegate");
  [searchBar searchForLocations:searchText];
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return locationsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"LCLocationCell";
  LCLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCLocationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:MyIdentifier];
  }
  cell.locationLabel.text = [locationsArray objectAtIndex:indexPath.row];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
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
