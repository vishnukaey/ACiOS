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
{
  NSArray *sectionTitles;
  NSMutableDictionary *contactsDictionary;
}


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
  contactsTable.sectionIndexColor = [UIColor blackColor];
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
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error){
      if (granted)
      {
        // First time access has been granted, add the contact
        contactsArray = [LCPhoneContactsHelper getPhoneContacts];
        dispatch_async(dispatch_get_main_queue(), ^{
          [self refreshTable];
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
    [self refreshTable];
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
  
}


- (IBAction)doneButtonAction
{
  selectedContactsArray = contactsTable.selectedIDs;
  [selectedContactsArray addObjectsFromArray:selectedEmailsArray];
  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  [self sendInvitations];
}


-(void)sendInvitations
{
  if(_invitingToActions)
  {
    [LCEventAPImanager addUsersWithUserIDs:nil forEventWithEventID:_eventID andEmailIDs:selectedContactsArray withSuccess:^(id response) {
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Invitations Sent"];
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      [self updateDataSource];
    } andFailure:^(NSString *error) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
  }
  else
  {
    [LCProfileAPIManager sendFriendRequestFromContacts:selectedContactsArray withSuccess:^(id response) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];
      [LCUtilityManager showAlertViewWithTitle:nil andMessage:@"Invitations Sent"];
      [self updateDataSource];
    } andFailure:^(NSString *error) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
  }
}

-(void) updateDataSource
{
  [self addSelectedMembersToInvitedList];
  [selectedContactsArray removeAllObjects];
  [selectedEmailsArray removeAllObjects];
  [contactsTable.selectedIDs removeAllObjects];
  [self refreshTable];
  [self updateCustomAddedEmailsCount];
}


#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return sectionTitles.count;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  if (contactsArray.count == 0)
  {
    return 1;
  }
  NSArray *contacts = [contactsDictionary valueForKey:sectionTitles[section]];
  return [contacts count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
  return sectionTitles;
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
  
  LCContact *con = [[contactsDictionary valueForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
  cell.conatctPhotoView.layer.cornerRadius = cell.conatctPhotoView.frame.size.width/2;
  cell.conatctPhotoView.clipsToBounds = YES;
  cell.conatctPhotoView.image = con.P_image;
  cell.contactNameLabel.text = con.P_name;
  cell.contactLocationLabel.text = con.P_emails[0];
  
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  UIButton *checkbutton = cell.checkButton;
//  checkbutton.tag = indexPath.section*10+indexPath.row;
//  [checkbutton addTarget:self action:@selector(checkbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
  [tableView setStatusForButton:checkbutton byCheckingIDs:con.P_emails];
  [self setButtonTitleAndColourForCheckButton:checkbutton byCheckingID:con.P_emails[0]];
  
  return cell;
}


-(void)tableView:(LCMultipleSelectionTable *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  LCInviteFromContactsCell *cell = (LCInviteFromContactsCell*)[tableView cellForRowAtIndexPath:indexPath];
  LCContact *con = [[contactsDictionary valueForKey:[sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
  [tableView AddOrRemoveID:con.P_emails[0]];

  if([selectedContactsArray containsObject:con.P_emails[0]])
  {
    [selectedContactsArray removeObject:con.P_emails[0]];
  }
  else
  {
    [selectedContactsArray addObject:con.P_emails[0]];
  }
  [tableView setStatusForButton:cell.checkButton byCheckingIDs:con.P_emails];
  [self updateRightBarButton];
}


-(void)updateRightBarButton
{
  if(contactsTable.selectedIDs.count)
  {
    sendButton.enabled = YES;
  }
  else
  {
    sendButton.enabled = NO;
  }
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


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
  
  return [sectionTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}


-(void)refreshTable
{
  contactsDictionary = [self createDictionaryForSectionIndex:contactsArray];
  sectionTitles = [contactsDictionary allKeys];
  [contactsTable reloadData];
}



-(NSMutableDictionary*)createDictionaryForSectionIndex:(NSArray*)array
{
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
  for (char firstChar = 'a'; firstChar <= 'z'; firstChar++)
  {
    NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
    NSArray *content = [contactsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.P_name beginswith[cd] %@", firstCharacter]];
    NSMutableArray *mutableContent = [[NSMutableArray alloc]initWithArray:content];
    
    if ([mutableContent count] > 0)
    {
      NSString *key = [firstCharacter uppercaseString];
      [dict setObject:[mutableContent mutableCopy] forKey:key];
    }
  }
  return dict;
}


@end
