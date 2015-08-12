//
//  LCContactsListVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCContactsListVC.h"
#import <AddressBook/AddressBook.h>
#import "LCContact.h"

@implementation LCContactsListVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:NO];

  [self loadContacts];
  contactsTable = [[LCMultipleSelectionTable alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y)];

  contactsTable.layer.borderColor = [UIColor greenColor].CGColor;
  contactsTable.layer.borderWidth = 3;
  contactsTable.delegate = self;
  contactsTable.dataSource = self;
  [self.view addSubview:contactsTable];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - initial setup functions
- (void)loadContacts
{
  ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
  if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
  {
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error)
    {
      if (granted)
      {
        // First time access has been granted, add the contact
        contactsArray = [LCUtilityManager getPhoneContacts];
        [contactsTable reloadData];
      }
      else
      {
        // User denied access
        // Display an alert telling user the contact could not be added
      }
    });
  }
  else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
  {
    // The user has previously given access, add the contact
    contactsArray = [LCUtilityManager getPhoneContacts];
    [contactsTable reloadData];
  }
  else
  {
    NSLog(@"---->>>The user has previously denied access");
    // The user has previously denied access
    // Send an alert telling user to change privacy setting in settings app
  }
}

#pragma mark - buttonActions
- (void)checkbuttonAction :(UIButton *)sender
{
  LCContact *con = [contactsArray objectAtIndex:sender.tag];
  contactsTable.selectedButton = sender;
  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
  if (![contactsTable indexPathSelected:indexPath])
  {
    if (con.P_emails.count==1)
    {
      [contactsTable AddIndexPath:indexPath];
    }
    else//only if there are multiple selections for a single cell
    {
      UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select email-ID" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
      for (NSString *title in con.P_emails)
      {
        [sheet addButtonWithTitle:title];
      }
      sheet.tag = sender.tag;
      [sheet showInView:self.view];
    }
  }
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex>0)
  {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:buttonIndex - 1 inSection:actionSheet.tag];
    [contactsTable AddIndexPath:indexPath];
  }
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return contactsArray.count;
}

- (UITableViewCell *)tableView:(LCMultipleSelectionTable *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *MyIdentifier = @"MyIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                            reuseIdentifier:MyIdentifier];
  }

  [[cell viewWithTag:10] removeFromSuperview];
  UIView *contactCell = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];

  UIImageView *contactImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
  LCContact *con = [contactsArray objectAtIndex:indexPath.row];
  contactImage.image = con.P_image;
  [contactCell addSubview:contactImage];

  UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, self.view.frame.size.width - 80, 20)];
  nameLabel.text = con.P_name;
  [contactCell addSubview:nameLabel];

  UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, self.view.frame.size.width - 80, 20)];
  numberLabel.text = [con.P_numbers objectAtIndex:0];
  [contactCell addSubview:numberLabel];

  UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, self.view.frame.size.width - 80, 20)];
  emailLabel.text = [con.P_emails objectAtIndex:0];
  [contactCell addSubview:emailLabel];
  
  UIButton *checkbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
  checkbutton.tag = indexPath.row;
  checkbutton.center = CGPointMake(tableView.frame.size.width - 50, 40);
  [checkbutton addTarget:self action:@selector(checkbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
  [tableView setImageForButton:checkbutton];
  [contactCell addSubview:checkbutton];
  [cell addSubview:contactCell];
  contactCell.tag = 10;

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
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
