//
//  LCContactsListVC.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCContactsListVC.h"

#import <AddressBook/AddressBook.h>

#import "contact.h"

@interface LCContactsListVC ()

@end

@implementation LCContactsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self contactPermission];
    
    UITableView *contactsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.navigationController.navigationBar.frame.origin.y)];
    
    contactsTable.layer.borderColor = [UIColor greenColor].CGColor;
    contactsTable.layer.borderWidth = 3;
    contactsTable.delegate = self;
    contactsTable.dataSource = self;
    
    
    [self.view addSubview:contactsTable];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

-(void)contactPermission
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
               H_contactsArray = [self getAllContacts];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
       H_contactsArray = [self getAllContacts];
    }
    else {
        
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}

- (NSArray *)getAllContacts {
    
    
    
    
    CFErrorRef *error = nil;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
    ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allPeople = (ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName));
    //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
    CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
    NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
    
    if (!allPeople || !nPeople) {
        NSLog(@"people nil");
    }
    
    
    for (int i = 0; i < nPeople; i++) {
        
        @autoreleasepool {
            
            //data model
            contact *contact_ = [[contact alloc] init];
            
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            
            //get First Name
            CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
            NSString *firstName_ = [(__bridge NSString*)firstName copy];
            
            if (firstName != NULL) {
                CFRelease(firstName);
            }
            if (!firstName_) {
                firstName_ = @"";
            }
            
            
            //get Last Name
            CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
            NSString *lastName_ = [(__bridge NSString*)lastName copy];
            
            if (lastName != NULL) {
                CFRelease(lastName);
            }
            
            
            
            
            if (!lastName_) {
                lastName_ = @"";
            }
            
            
            
            //            contacts.contactId = ABRecordGetRecordID(person);
            //append first name and last name
            contact_.P_name = [NSString stringWithFormat:@"%@ %@", firstName_, lastName_];
            
            if ([contact_.P_name isEqualToString:@" "]) {
                continue;
            }
            
            // get contacts picture, if pic doesn't exists, show standart one
            CFDataRef imgData = ABPersonCopyImageData(person);
            NSData *imageData = (__bridge NSData *)imgData;
            contact_.P_image = [UIImage imageWithData:imageData];
            
            if (imgData != NULL) {
                CFRelease(imgData);
            }
            
            if (!contact_.P_image) {
                contact_.P_image = [UIImage imageNamed:@"manplaceholder.jpg"];
            }
            
            
            //get Phone Numbers
            NSMutableArray *phoneNumbers = [[NSMutableArray alloc] init];
            ABMultiValueRef multiPhones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            
            for(CFIndex i=0; i<ABMultiValueGetCount(multiPhones); i++) {
                @autoreleasepool {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(multiPhones, i);
                    NSString *phoneNumber = CFBridgingRelease(phoneNumberRef);
                    if (phoneNumber != nil)[phoneNumbers addObject:phoneNumber];
                    //NSLog(@"All numbers %@", phoneNumbers);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiPhones);
            }
            
            contact_.P_numbers = phoneNumbers;
            
            if (contact_.P_numbers.count == 0) {
                continue;
            }
            
            //get Contact email
            NSMutableArray *contactEmails = [NSMutableArray new];
            ABMultiValueRef multiEmails = ABRecordCopyValue(person, kABPersonEmailProperty);
            
            for (CFIndex i=0; i<ABMultiValueGetCount(multiEmails); i++) {
                @autoreleasepool {
                    CFStringRef contactEmailRef = ABMultiValueCopyValueAtIndex(multiEmails, i);
                    NSString *contactEmail = CFBridgingRelease(contactEmailRef);
                    if (contactEmail != nil)[contactEmails addObject:contactEmail];
                    // NSLog(@"All emails are:%@", contactEmails);
                }
            }
            
            if (multiPhones != NULL) {
                CFRelease(multiEmails);
            }
            
            contact_.P_emails = contactEmails;
            
            if (contact_.P_emails.count == 0) {
                continue;
            }
            
            [items addObject:contact_];
            
#ifdef DEBUG
            NSLog(@"Person is: %@", contact_.P_name);
            NSLog(@"Phones are: %@", contact_.P_numbers);
            NSLog(@"Email is:%@", contact_.P_emails);
#endif
            
        }
    } //autoreleasepool
    CFRelease(allPeople);
    CFRelease(addressBook);
    CFRelease(source);
    return items;
    
}




#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return H_contactsArray.count;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
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
    contact *con = [H_contactsArray objectAtIndex:indexPath.row];
    
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
    
    
    
    
    [cell addSubview:contactCell];
    contactCell.tag = 10;
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
