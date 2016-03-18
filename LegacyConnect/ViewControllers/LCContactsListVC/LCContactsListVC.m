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
#import "LCPhoneContactsHelper.h"

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
  contactsTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  
  selectedContactsArray = [[NSMutableArray alloc] init];
  selectedEmailsArray = [[NSMutableArray alloc] init];
  invitedEmails = [[NSMutableArray alloc] init];
  
  contactsTable.checkedImage = [UIImage imageNamed:@"inviteBGSelected"];
  contactsTable.uncheckedImage = [UIImage imageNamed:@"inviteBG"];
  [LCUtilityManager setGIAndMenuButtonHiddenStatus:YES MenuHiddenStatus:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateCustomAddedEmailsCount];
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
                                                 contactsArray = [LCPhoneContactsHelper getPhoneContacts];
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                   [contactsTable reloadData];
                                                 });
                                               }
                                               else
                                               {
                                                 LCDLog(@"User denied acces earlier--");
                                                 // User denied access
                                                 // Display an alert telling user the contact could not be added
                                               }
                                             });
  }
  else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
  {
    // The user has previously given access, add the contact
    contactsArray = [LCPhoneContactsHelper getPhoneContacts];
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
  LCContact *con = contactsArray[sender.tag];
  contactsTable.selectedButton = sender;
  //    if (con.P_emails.count==1)
  //    {
  [contactsTable AddOrRemoveID:con.P_emails[0]];
  //    }
  //    else//only if there are multiple selections for a single cell
  //    {
  //      for (int i = 0; i<con.P_emails.count; i++)
  //      {
  //        if ([contactsTable.selectedIDs containsObject:con.P_emails[i]]) {
  //          [contactsTable AddOrRemoveID:con.P_emails[i]];
  //          return;
  //        }
  //      }
  //      UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select email-ID" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
  //      for (NSString *title in con.P_emails)
  //      {
  //        [sheet addButtonWithTitle:title];
  //      }
  //      sheet.tag = sender.tag;
  //      [sheet showInView:self.view];
  //    }
}


- (IBAction)doneButtonAction
{
  selectedContactsArray = contactsTable.selectedIDs;
  [selectedContactsArray addObjectsFromArray:selectedEmailsArray];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [LCProfileAPIManager sendFriendRequestFromContacts:selectedContactsArray withSuccess:^(id response) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Invitations Sent"];
    [self addSelectedMembersToInvitedList];
    [selectedContactsArray removeAllObjects];
    [selectedEmailsArray removeAllObjects];
    [contactsTable.selectedIDs removeAllObjects];
    [contactsTable reloadData];
    [self updateCustomAddedEmailsCount];
    
  } andFailure:^(NSString *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
  }];
}

//#pragma mark - UIActionSheet delegate
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//  if (buttonIndex>0)
//  {
//    LCContact *con = contactsArray[actionSheet.tag];
//    [contactsTable AddOrRemoveID:con.P_emails[buttonIndex-1]];
//  }
//}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (contactsArray.count == 0)
  {
    return 1;
  }
  return contactsArray.count;
}

- (UITableViewCell *)tableView:(LCMultipleSelectionTable *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (contactsArray.count == 0)
  {
    UITableViewCell *cell = [LCPaginationHelper getEmptyIndicationCellWithText:NSLocalizedString(@"no_contacts_to_display", nil)];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsSelection = NO;
    return cell;
  }
  
  static NSString *MyIdentifier = @"contactsCell";
  LCInviteFromContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
  if (cell == nil)
  {
    cell = [[LCInviteFromContactsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
  }
  
  LCContact *con = contactsArray[indexPath.row];
  cell.conatctPhotoView.layer.cornerRadius = cell.conatctPhotoView.frame.size.width/2;
  cell.conatctPhotoView.clipsToBounds = YES;
  cell.conatctPhotoView.image = con.P_image;
  cell.contactNameLabel.text = con.P_name;
  cell.contactLocationLabel.text = con.P_emails[0];

  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  UIButton *checkbutton = cell.checkButton;
  checkbutton.tag = indexPath.row;
  [checkbutton addTarget:self action:@selector(checkbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
  [tableView setStatusForButton:checkbutton byCheckingIDs:con.P_emails];
  [self setButtonTitleAndColourForCheckButton:checkbutton byCheckingID:con.P_emails[0]];
  
  return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  LCInviteFromContactsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  [self checkbuttonAction:cell.checkButton];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 93;
}


-(IBAction)backButtonTapped:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)inviteThroughEmail:(id)sender
{
  LCInviteEmailVC *inviteVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LCInviteEmailVC"];
  inviteVC.emailsArray = selectedEmailsArray;
  [self.navigationController pushViewController:inviteVC animated:YES];
}


-(void)setButtonTitleAndColourForCheckButton:(UIButton*)checkButton byCheckingID:(NSString*)email
{
  BOOL invited = NO;
  for( NSString *E_id in invitedEmails)
  {
    if([E_id isEqualToString:email])
    {
      invited = YES;
      break;
    }
  }
  
  if(invited)
  {
    [checkButton setTitle:@"Invited" forState:UIControlStateNormal];
    [checkButton setTitleColor:[UIColor colorWithRed:141/255.0 green:198/255.0 blue:63/255.0 alpha:1.0] forState:UIControlStateNormal];
    [checkButton setBackgroundImage:nil forState:UIControlStateNormal];
    [checkButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Bold" size:14.0f]];
    checkButton.userInteractionEnabled = NO;
  }
  else
  {
    [checkButton setTitle:@"Invite" forState:UIControlStateNormal];
    [checkButton.titleLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14.0f]];
  }
}


-(void)addSelectedMembersToInvitedList
{
  for(NSString *email in selectedContactsArray)
  {
    bool present = NO;
    for(NSString *invEmail in invitedEmails)
    {
      if([email isEqualToString:invEmail])
      {
        present = YES;
        break;
      }
    }
    if(!present)
    {
      [invitedEmails addObject:email];
    }
  }
}



-(void) updateCustomAddedEmailsCount
{
  if(selectedEmailsArray.count>0)
  {
    [additionalEmailsLabel setText:[NSString stringWithFormat:@"%ld added",selectedEmailsArray.count]];
    [additionalEmailsLabel setHidden:NO];
  }
  else
  {
    [additionalEmailsLabel setHidden:YES];
  }
}


@end
