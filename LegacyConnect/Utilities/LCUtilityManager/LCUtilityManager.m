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
  return [NSString stringWithFormat:@"%d",boolInt];;
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
  else
  {
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = MAX_IMAGE_SIZE*1024*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
      compression -= 0.1;
      imageData = UIImageJPEGRepresentation(image, compression);
      NSLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
    }
    NSLog(@"File size is : %.2f MB",(float)imageData.length/1024.0f/1024.0f);
    return imageData;
  }
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
  else
  {
    return NO;
  }
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
  else
  {
    return NO;
  }
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
//  if (candidateURL && candidateURL.host) {
//    return true;
//  }
//  return false;
  NSString *urlRegEx =
  @"((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
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
                contact_.P_image = [UIImage imageNamed:@"userProfilePic"];
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
            
//            if (contact_.P_numbers.count == 0) {
//                continue;
//            }
          
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
          
          //get location
          contact_.P_address = @"";
          ABMultiValueRef addressRef = ABRecordCopyValue(person, kABPersonAddressProperty);
          if (ABMultiValueGetCount(addressRef) > 0) {
            NSDictionary *addressDict = (__bridge NSDictionary *)ABMultiValueCopyValueAtIndex(addressRef, 0);
            
            contact_.P_address = [NSString stringWithFormat:@"%@",[addressDict objectForKey:(NSString *)kABPersonAddressCityKey]];
           
          }
          CFRelease(addressRef);
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
  
  NSMutableDictionary *md = [NSMutableDictionary dictionary];
  
  NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
  
  for(NSString *s in queryComponents) {
    NSArray *pair = [s componentsSeparatedByString:@"="];
    if([pair count] != 2) continue;
    
    NSString *key = pair[0];
    NSString *value = pair[1];
    
    md[key] = value;
  }
  
  return md;
}

+ (UIView*)getNoResultViewWithText:(NSString*)text andViewWidth:(CGFloat)width
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
  #warning should remove hardcoding the version.
  appVersion = @"0.4.0";
  return appVersion;
}

@end
