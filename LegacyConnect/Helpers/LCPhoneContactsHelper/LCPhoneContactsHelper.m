//
//  LCPhoneContactsHelper.m
//  LegacyConnect
//
//  Created by qbuser on 02/02/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCPhoneContactsHelper.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "LCContact.h"

@implementation LCPhoneContactsHelper


#pragma mark- Get Contacts
+ (NSString *)getFirstnameOfContactForPerson :(ABRecordRef)person
{
  CFStringRef firstName = (CFStringRef)ABRecordCopyValue(person,kABPersonFirstNameProperty);
  NSString *firstName_ = [(__bridge NSString*)firstName copy];
  if (firstName != NULL) {
    CFRelease(firstName);
  }
  if (!firstName_) {
    firstName_ = @"";
  }
  return firstName_;
}

+ (NSString *)getLastnameOfContactForPerson :(ABRecordRef)person
{
  CFStringRef lastName = (CFStringRef)ABRecordCopyValue(person,kABPersonLastNameProperty);
  NSString *lastName_ = [(__bridge NSString*)lastName copy];
  
  if (lastName != NULL) {
    CFRelease(lastName);
  }
  if (!lastName_) {
    lastName_ = @"";
  }
  return lastName_;
}

+ (UIImage *)getImageOfContactForPerson :(ABRecordRef)person
{
  CFDataRef imgData = ABPersonCopyImageData(person);
  NSData *imageData = (__bridge NSData *)imgData;
  UIImage *dpImage = [UIImage imageWithData:imageData];
  if (imgData != NULL) {
    CFRelease(imgData);
  }
  if (!dpImage) {
    dpImage = [UIImage imageNamed:@"userProfilePic"];
  }
  return dpImage;
}

+ (NSArray *)getPhoneNumbersOfContactForPerson :(ABRecordRef)person
{
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
  return phoneNumbers;
}

+ (NSArray *)getEmailsOfContactForPerson :(ABRecordRef)person
{
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
  
  if (multiEmails != NULL) {
    CFRelease(multiEmails);
  }
  return contactEmails;
}

+ (NSString *)getLocationOfContactForPerson :(ABRecordRef)person
{
  NSString *address = @"";
  ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
  if (ABMultiValueGetCount(addressRef) > 0) {
    NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
    
    address = [NSString stringWithFormat:@"%@",addressDict[(NSString *)kABPersonAddressCityKey]];
    
  }
  CFRelease(addressRef);
  return address;
}

+ (NSArray *)getPhoneContacts {
  CFErrorRef *error = nil;
  ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, error);
  ABRecordRef source = ABAddressBookCopyDefaultSource(addressBook);
  CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, source, kABPersonSortByFirstName);
  //CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);
  CFIndex nPeople = CFArrayGetCount(allPeople); // bugfix who synced contacts with facebook
  NSMutableArray* items = [NSMutableArray arrayWithCapacity:nPeople];
  for (int i = 0; i < nPeople; i++) {
    @autoreleasepool {
      //data model
      LCContact *contact_ = [[LCContact alloc] init];
      ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
      //get First Name
      NSString *firstName_ = [LCPhoneContactsHelper getFirstnameOfContactForPerson:person];
      //get Last Name
      NSString *lastName_ = [LCPhoneContactsHelper getLastnameOfContactForPerson:person];
      //            contacts.contactId = ABRecordGetRecordID(person);
      //append first name and last name
      contact_.P_name = [NSString stringWithFormat:@"%@ %@", firstName_, lastName_];
      if ([contact_.P_name isEqualToString:@" "]) {
        continue;
      }
      // get contacts picture, if pic doesn't exists, show standart one
      contact_.P_image = [LCPhoneContactsHelper getImageOfContactForPerson:person];
      
      //get Phone Numbers
      contact_.P_numbers = [LCPhoneContactsHelper getPhoneNumbersOfContactForPerson:person];
      
      //            if (contact_.P_numbers.count == 0) {
      //                continue;
      //            }
      
      //get Contact email
      contact_.P_emails = [LCPhoneContactsHelper getEmailsOfContactForPerson:person];
      if (contact_.P_emails.count == 0) {
        continue;
      }
      //get location
      contact_.P_address = [LCPhoneContactsHelper getLocationOfContactForPerson:person];
      [items addObject:contact_];
    }
  } //autoreleasepool
  CFRelease(allPeople);
  CFRelease(addressBook);
  CFRelease(source);
  return items;
}


@end
