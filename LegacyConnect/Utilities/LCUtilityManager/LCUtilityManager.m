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

#define MAX_IMAGE_SIZE 1.2

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

+ (NSString*) getStringValueOfBOOL:(BOOL)value
{
  int boolInt = (int) value;
  return [NSString stringWithFormat:@"%d",boolInt];
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
  [LCDataManager sharedDataManager].headerPhotoURL = user.headerPhotoURL;
  
  /**
   * Once the user details changes, the User avatar and cover photo in Navigation menu should be refreshed.
   * For this, on each user profile update, a notification will be triggered from here and the navigation menu 
   * class will update the the required assets.
   */
  [[NSNotificationCenter defaultCenter] postNotificationName:kUserDataUpdatedNotification object:nil];

}


+ (NSData*)performNormalisedImageCompression:(UIImage*)image
{
  NSData *data = UIImageJPEGRepresentation(image, 1.0);
  if([data length] < MAX_IMAGE_SIZE*1024*1024)
  {
    return data;
  }
  CGFloat compression = 1.0f;
  CGFloat maxCompression = 0.1f;
  int maxFileSize = MAX_IMAGE_SIZE*1024*1024;
  
  NSData *imageData = UIImageJPEGRepresentation(image, compression);
  LCDLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
  while ([imageData length] > maxFileSize && compression > maxCompression)
  {
    compression -= 0.1;
    imageData = UIImageJPEGRepresentation(image, compression);
    LCDLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
  }
  LCDLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
  return imageData;
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
  if (!date) {
    return kEmptyStringValue;
  }
  NSTimeInterval timeInterval = [date timeIntervalSince1970];
  NSString *timeStampString = [NSString stringWithFormat:@"%0.0f", timeInterval * 1000];
  return timeStampString;
}

+ (NSString *)getAgeFromTimeStamp:(NSString *)timeStamp
{
  NSString *age = kEmptyStringValue;
  if (![[self performNullCheckAndSetValue:timeStamp] isEqualToString:kEmptyStringValue] && ![timeStamp isEqualToString:@"0"])
  {
    NSDate *dob = [NSDate dateWithTimeIntervalSince1970:timeStamp.longLongValue/1000];
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                     components:NSCalendarUnitYear
                                     fromDate:dob
                                     toDate:now
                                     options:0];
    age = [NSString stringWithFormat: @"%ld", (long)[ageComponents year]];
  }
  return age;
}

+ (NSString *)encodeToBase64String:(NSString *)string
{
  NSData *encodedData = [string dataUsingEncoding: NSUTF8StringEncoding];
  NSString *base64String = [encodedData base64EncodedStringWithOptions:0];
  return base64String;
}

+ (BOOL)validateEmail:(NSString*)emailString
{
  NSString *emailRegex = @"[A-Z0-9a-z._%+]+@[A-Za-z0-9.]+\\.[A-Za-z]{2,4}";
  NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
  bool isvalid = [emailTest evaluateWithObject:emailString];
  if(isvalid)
  {
    return YES;
  }
  return NO;
}

+ (BOOL)validatePassword:(NSString*)passwordString
{
  BOOL isValid = NO;
  if (passwordString.length>7) {
    isValid = YES;
  }
  if(isValid)
  {
    return YES;
  }
  return NO;
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

+ (UITableViewCell*)getEmptyIndicationCellWithText:(NSString*)text
{
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
  cell.textLabel.text = text;
  [cell.textLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [cell.textLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  cell.textLabel.textAlignment =NSTextAlignmentCenter;
  cell.textLabel.numberOfLines = 2;
  return cell;
}

+ (void)setLCStatusBarStyle {
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


+ (BOOL)isaValidWebsiteLink :(NSString *)link
{
//  NSURL *candidateURL = [NSURL URLWithString:link];
//  if (candidateURL && candidateURL.scheme && candidateURL.host) {
//    return true;
//  }
//  return false;

//  NSString *urlRegEx = @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//  NSString *urlRegEx =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
//  NSString *urlRegEx = @"((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?";
  
  NSString *urlRegEx =@"((http|https)://)?((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
  NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
  return [urlTest evaluateWithObject:link];
}

+ (NSString *)getSpaceTrimmedStringFromString :(NSString *)string
{
  return [string stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceCharacterSet]];
}

+ (BOOL)isEmptyString :(NSString *)string
{
  if ([string stringByReplacingOccurrencesOfString:@" " withString:@""].length) {
    return NO;
  }
  return YES;
}

//+(NSNumber*) getNSNumberFromString:(NSString*)string
//{
//  NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
//  format.numberStyle = NSNumberFormatterDecimalStyle;
//  NSNumber *myNumber = [format numberFromString:string];
//  return myNumber;
//}

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
            NSString *firstName_ = [LCUtilityManager getFirstnameOfContactForPerson:person];
            //get Last Name
            NSString *lastName_ = [LCUtilityManager getLastnameOfContactForPerson:person];
            //            contacts.contactId = ABRecordGetRecordID(person);
            //append first name and last name
            contact_.P_name = [NSString stringWithFormat:@"%@ %@", firstName_, lastName_];
            if ([contact_.P_name isEqualToString:@" "]) {
                continue;
            }
            // get contacts picture, if pic doesn't exists, show standart one
            contact_.P_image = [LCUtilityManager getImageOfContactForPerson:person];
          
            //get Phone Numbers
            contact_.P_numbers = [LCUtilityManager getPhoneNumbersOfContactForPerson:person];
            
//            if (contact_.P_numbers.count == 0) {
//                continue;
//            }
          
            //get Contact email
            contact_.P_emails = [LCUtilityManager getEmailsOfContactForPerson:person];
            if (contact_.P_emails.count == 0) {
                continue;
            }
          //get location
            contact_.P_address = [LCUtilityManager getLocationOfContactForPerson:person];
            [items addObject:contact_];
        }
    } //autoreleasepool
    CFRelease(allPeople);
    CFRelease(addressBook);
    CFRelease(source);
    return items;
}

#pragma mark- GIButton visibility
+ (void)setGIAndMenuButtonHiddenStatus:(BOOL)GIisHidden MenuHiddenStatus:(BOOL)menuisHidden
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  if (!appdel.isCreatePostOpen) {
    [appdel.GIButton setHidden:GIisHidden];
    [appdel.menuButton setHidden:menuisHidden];
  }
}

#pragma mark- twitter url proccess
+ (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
  
  NSMutableDictionary *parameterDict = [NSMutableDictionary dictionary];
  
  NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
  
  for(NSString *s in queryComponents) {
    NSArray *pair = [s componentsSeparatedByString:@"="];
    if([pair count] != 2) continue;
    
    NSString *key = pair[0];
    NSString *value = pair[1];
    
    parameterDict[key] = value;
  }
  
  return parameterDict;
}

+ (UIView*)getNoResultViewWithText:(NSString*)text
{
  UIView * noResultView = [[UIView alloc] init];
  UILabel * noResultLabel = [[UILabel alloc] init];
  [noResultLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [noResultLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  noResultLabel.textAlignment = NSTextAlignmentCenter;
  noResultLabel.numberOfLines = 2;
  [noResultLabel setText:text];
  [noResultView addSubview:noResultLabel];
  
  //add constraints
  noResultLabel.translatesAutoresizingMaskIntoConstraints = NO;
  NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
  [noResultView addConstraint:top];
  
   NSLayoutConstraint *height =[NSLayoutConstraint constraintWithItem:noResultLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:60.0];
  [noResultView addConstraint:height];
  
  NSLayoutConstraint *left =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
  [noResultView addConstraint:left];
  
  NSLayoutConstraint *right =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
  [noResultView addConstraint:right];

  return noResultView;
}

+ (UIView*)getSearchNoResultViewWithText:(NSString*)text
{
  UIView * noResultView = [[UIView alloc] init];
  UILabel * noResultLabel = [[UILabel alloc] init];
  [noResultLabel setFont:[UIFont fontWithName:@"Gotham-Book" size:14]];
  [noResultLabel setTextColor:[UIColor colorWithRed:35.0/255 green:31.0/255 blue:32.0/255 alpha:1]];
  noResultLabel.textAlignment = NSTextAlignmentCenter;
  noResultLabel.numberOfLines = 2;
  [noResultLabel setText:text];
  [noResultView addSubview:noResultLabel];
  
  //add constraints
  noResultLabel.translatesAutoresizingMaskIntoConstraints = NO;
  NSLayoutConstraint *top =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
  [noResultView addConstraint:top];
  
  NSLayoutConstraint *height =[NSLayoutConstraint constraintWithItem:noResultLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30.0];
  [noResultView addConstraint:height];
  
  NSLayoutConstraint *left =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeLeftMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
  [noResultView addConstraint:left];
  
  NSLayoutConstraint *right =[NSLayoutConstraint constraintWithItem:noResultView attribute:NSLayoutAttributeRightMargin relatedBy:NSLayoutRelationEqual toItem:noResultLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
  [noResultView addConstraint:right];
  
  return noResultView;
}


+ (UITableViewCell*)getNextPageLoaderCell
{
  UITableViewCell * loaderCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
  UIActivityIndicatorView * loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [loaderCell addSubview:loader];
  [loader startAnimating];
  loader.center = loaderCell.center;
  return loaderCell;
}

#pragma mark- version control
+ (void)showVersionOutdatedAlert
{
  UIAlertController *versionAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"version_outdated_title", @"title") message:NSLocalizedString(@"version_outdated_message", @"message") preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *deletePostActionFinal = [UIAlertAction actionWithTitle:NSLocalizedString(@"version_update_title", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kLCiTunesLink]];
  }];
  [versionAlert addAction:deletePostActionFinal];
  
  [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:versionAlert animated:YES completion:nil];
}

+ (NSString *)getAppVersion
{
  NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  return appVersion;
}

 + (void)checkAppVersion
{
  [LCSettingsAPIManager checkVersionWithSuccess:^(id response) {
    LCDLog(@"version checked");
    } andFailure:^(NSString *error) {
  }];
}

+ (UIColor *)getThemeRedColor
{
  return [UIColor colorWithRed:250.0f/255 green:70.0f/255 blue:22.0f/255 alpha:1];
}

+ (float)getHeightOffsetForGIB
{
  return 80;
}

+(UIColor*)colorWithHexString:(NSString*)hexString
{
  NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  NSString *colorString = [[cString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
  
  // String should be 6 or 8 characters
  if ([colorString length] < 6) return [UIColor grayColor];
  
  // strip 0X if it appears
  if ([colorString hasPrefix:@"0X"]) colorString = [colorString substringFromIndex:2];
  
  if ([colorString length] != 6) return  [UIColor grayColor];
  
  // Separate into r, g, b substrings
  NSRange range;
  range.location = 0;
  range.length = 2;
  NSString *rString = [colorString substringWithRange:range];
  
  range.location = 2;
  NSString *gString = [colorString substringWithRange:range];
  
  range.location = 4;
  NSString *bString = [colorString substringWithRange:range];
  
  // Scan values
  unsigned int red, green, blue;
  [[NSScanner scannerWithString:rString] scanHexInt:&red];
  [[NSScanner scannerWithString:gString] scanHexInt:&green];
  [[NSScanner scannerWithString:bString] scanHexInt:&blue];
  
  return [UIColor colorWithRed:((float) red / 255.0f)
                         green:((float) green / 255.0f)
                          blue:((float) blue / 255.0f)
                         alpha:1.0f];
}


@end
