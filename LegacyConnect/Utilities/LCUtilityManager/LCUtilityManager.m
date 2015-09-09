//
//  LCUtilityManager.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUtilityManager.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <AddressBook/AddressBook.h>
#import <Reachability/Reachability.h>
#import "LCContact.h"
#import <SDWebImage/UIImageView+WebCache.h>



@implementation LCUtilityManager

+ (BOOL)isNetworkAvailable
{
  Reachability *reach= [Reachability reachabilityForInternetConnection];
  return reach.isReachable;
}

+ (NSString *)performNullCheckAndSetValue:(NSString *)value
{
  if (value && ![value isKindOfClass:[NSNull class]])
  {
    return value;
  }
  return kEmptyStringValue;
}


+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
  [alert show];
}

+ (void)saveUserDefaultsForNewUser
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:YES forKey:kLoginStatusKey];
  [defaults setValue:[LCDataManager sharedDataManager].userToken forKey:kUserTokenKey];
  [defaults setValue:[LCDataManager sharedDataManager].userID forKey:kUserIDKey];
  [defaults synchronize];
}

+ (void)saveUserDetailsToDataManagerFromResponse:(LCUserDetail*)user
{
  if(![[LCUtilityManager performNullCheckAndSetValue:user.accessToken] isEqualToString:kEmptyStringValue])
  {
    [LCDataManager sharedDataManager].userToken = user.accessToken;
  }
  if(![[LCUtilityManager performNullCheckAndSetValue:user.userID] isEqualToString:kEmptyStringValue])
  {
    [LCDataManager sharedDataManager].userID = user.userID;
  }
  [LCDataManager sharedDataManager].userEmail = user.email;
  [LCDataManager sharedDataManager].firstName = user.firstName;
  [LCDataManager sharedDataManager].lastName = user.lastName;
  [LCDataManager sharedDataManager].dob = user.dob;
  [LCDataManager sharedDataManager].avatarUrl = user.avatarURL;
}



+ (void)clearUserDefaultsForCurrentUser
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:kLoginStatusKey];
  [defaults synchronize];
  [LCDataManager sharedDataManager].userToken = kEmptyStringValue;
  [LCDataManager sharedDataManager].userID = kEmptyStringValue;
  [defaults setValue:kEmptyStringValue forKey:kUserTokenKey];
  [defaults setValue:nil forKey:kUserTokenKey];
  [defaults setValue:nil forKey:kUserIDKey];
}


+ (NSString *)getDateFromTimeStamp:(NSString *)timeStamp WithFormat:(NSString *)format
{
  NSString *date = kEmptyStringValue;
  if (![[self performNullCheckAndSetValue:timeStamp] isEqualToString:kEmptyStringValue] && ![timeStamp isEqualToString:@"0"])
  {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp.longLongValue/1000]];
  }
  return date;
}


+ (NSString *)getTimeStampStringFromDate:(NSDate *)date
{
  NSTimeInterval timeInterval = [date timeIntervalSince1970];
  NSString *timeStampString = [NSString stringWithFormat:@"%0.0f", timeInterval * 1000];
  return timeStampString;
}


+ (NSString *)encodeToBase64String:(NSString *)string
{
  NSData *encodedData = [string dataUsingEncoding: NSUTF8StringEncoding];
  NSString *base64String = [encodedData base64EncodedStringWithOptions:0];
  return base64String;
}


+ (NSString *)decodeFromBase64String:(NSString *)string
{
  NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:string options:0];
  NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
  return decodedString;
}

+ (NSString *) generateUserTokenForUserID:(NSString*)userEmail andPassword:(NSString *)password
{
  NSString *appendedString = [NSString stringWithFormat:@"%@:%@",userEmail,password];
  return [LCUtilityManager encodeToBase64String:appendedString];
}

//+(NSNumber*) getNSNumberFromString:(NSString*)string
//{
//  NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
//  format.numberStyle = NSNumberFormatterDecimalStyle;
//  NSNumber *myNumber = [format numberFromString:string];
//  return myNumber;
//}

#pragma mark- Get Contacts
+ (NSArray *)getPhoneContacts {
  
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
            LCContact *contact_ = [[LCContact alloc] init];
            
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

@end
