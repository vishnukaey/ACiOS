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
#import "LCFeedsHomeViewController.h"

#pragma mark - LCInviteFromContactsCell class
@interface LCInviteFromContactsCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *contactLocationLabel;
@property(nonatomic, strong)IBOutlet UILabel *contactNameLabel;
@property(nonatomic, strong)IBOutlet UIImageView *conatctPhotoView;
@property(nonatomic, strong)IBOutlet UIButton *checkButton;
@end

@implementation LCInviteFromContactsCell
@end


#pragma mark - LCContactsListVC class
@implementation LCContactsListVC

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadContacts];
  contactsTable.checkedImage = [UIImage imageNamed:@"contact_tick"];
  contactsTable.uncheckedImage = [UIImage imageNamed:@"contact_plus"];
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
        dispatch_async(dispatch_get_main_queue(), ^{
          [contactsTable reloadData];
        });
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
    // The user has previously denied access
    // Send an alert telling user to change privacy setting in settings app
    [LCUtilityManager showAlertViewWithTitle:@"Request access" andMessage:@"Please allow access to contacts from Settings application."];
  }
}

#pragma mark - buttonActions
- (void)checkbuttonAction :(UIButton *)sender
{
  LCContact *con = [contactsArray objectAtIndex:sender.tag];
  contactsTable.selectedButton = sender;
    if (con.P_emails.count==1)
    {
      [contactsTable AddOrRemoveID:con.P_emails[0]];
    }
    else//only if there are multiple selections for a single cell
    {
      for (int i = 0; i<con.P_emails.count; i++)
      {
        if ([contactsTable.selectedIDs containsObject:con.P_emails[i]]) {
          [contactsTable AddOrRemoveID:con.P_emails[i]];
          return;
        }
      }
      UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select email-ID" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
      for (NSString *title in con.P_emails)
      {
        [sheet addButtonWithTitle:title];
      }
      sheet.tag = sender.tag;
      [sheet showInView:self.view];
    }
}

- (IBAction)doneButtonAction
{
  NSArray *selectedMailIDs = contactsTable.selectedIDs;
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCAPIManager sendFriendRequestFromContacts:selectedMailIDs withSuccess:^(id response) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
    LCFeedsHomeViewController *vc = [sb instantiateViewControllerWithIdentifier:kHomeFeedsStoryBoardID];
    [self.navigationController pushViewController:vc animated:YES];
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"%@",error);
  }];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex>0)
  {
    LCContact *con = [contactsArray objectAtIndex:actionSheet.tag];
    [contactsTable AddOrRemoveID:con.P_emails[buttonIndex -1]];
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
  static NSString *MyIdentifier = @"contactsCell";
  LCInviteFromContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
  cell = [[LCInviteFromContactsCell alloc] initWithStyle:UITableViewCellStyleDefault
                            reuseIdentifier:MyIdentifier];
  }

  

  LCContact *con = [contactsArray objectAtIndex:indexPath.row];
  cell.conatctPhotoView.layer.cornerRadius = cell.conatctPhotoView.frame.size.width/2;
  cell.conatctPhotoView.clipsToBounds = YES;
  cell.conatctPhotoView.image = con.P_image;

  cell.contactNameLabel.text = con.P_name;
  
  cell.contactLocationLabel.text = con.P_address;
  
  UIButton *checkbutton = cell.checkButton;
  checkbutton.tag = indexPath.row;
  [checkbutton addTarget:self action:@selector(checkbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
  [tableView setStatusForButton:checkbutton byCheckingIDs:con.P_emails];

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 93;
}


@end
