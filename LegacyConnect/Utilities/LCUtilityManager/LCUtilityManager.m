//
//  LCUtilityManager.m
//  LegacyConnect
//
//  Created by Vishnu on 7/15/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCUtilityManager.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <Reachability/Reachability.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MFSideMenuContainerViewController.h"

#define MAX_IMAGE_SIZE 1.2

static NSString *const kWhiteSpace = @" ";

@implementation LCUtilityManager

#pragma mark - genearal method implementation
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

+ (void)setLCStatusBarStyle {
  
  [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

+ (BOOL)isNetworkAvailable
{
  Reachability *reach= [Reachability reachabilityForInternetConnection];
  return reach.isReachable;
}

#pragma mark - Alert
+ (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
  [alert show];
}

#pragma maek - User defaults saving/Retriving.
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

#pragma mark - Data and Time method implemenatation
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

#pragma mark -Encode and Decode methods
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

#pragma mark - Validation methods
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
  if (passwordString.length>7)
  {
    return YES;
  }
  return NO;
}

+ (NSString *) generateUserTokenForUserID:(NSString*)userEmail andPassword:(NSString *)password
{
  NSString *appendedString = [NSString stringWithFormat:@"%@:%@",userEmail,password];
  return [LCUtilityManager encodeToBase64String:appendedString];
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

+ (BOOL)isaValidWebsiteLink :(NSString *)link
{
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
  if ([string stringByReplacingOccurrencesOfString:kWhiteSpace withString:kEmptyStringValue].length) {
    return NO;
  }
  return YES;
}


+ (long)trueStringLength:(NSString *)string
{
  return [string stringByReplacingOccurrencesOfString:kWhiteSpace withString:kEmptyStringValue].length;
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

#pragma mark- version control
+ (void)showVersionOutdatedAlert
{
  UIAlertController *versionAlert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"version_outdated_title", @"title") message:NSLocalizedString(@"version_outdated_message", @"message") preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *deletePostAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"version_update_title", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kLCiTunesLink]];
  }];
  [versionAlert addAction:deletePostAction];
  
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

#pragma mark - GI Button method implementation


+ (void)setGIAndMenuButtonHiddenStatus:(BOOL)GIisHidden MenuHiddenStatus:(BOOL)menuisHidden
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  
  if (!appdel.isCreatePostOpen) {
    [appdel.GIButton setHidden:GIisHidden];
    [appdel.menuButton setHidden:menuisHidden];
  }
  else
  {
    [appdel.GIButton setHidden:true];
    [appdel.menuButton setHidden:true];
    appdel.mainContainer.panMode = MFSideMenuPanModeNone;
    [appdel.mainContainer panGestureRecognizer].enabled = NO;
    for(id vb in appdel.window.rootViewController.view.gestureRecognizers)
    {
      if([vb isKindOfClass:[UIPanGestureRecognizer class]])
      {
        [appdel.window.rootViewController.view removeGestureRecognizer:vb];
      }
    }
    return;
  }
  if(menuisHidden)
  {
    if (appdel.mainContainer) {
      appdel.mainContainer.panMode = MFSideMenuPanModeNone;
      [appdel.mainContainer panGestureRecognizer].enabled = NO;
      for(id vb in appdel.window.rootViewController.view.gestureRecognizers)
      {
        if([vb isKindOfClass:[UIPanGestureRecognizer class]])
        {
          [appdel.window.rootViewController.view removeGestureRecognizer:vb];
        }
      }
    }
  }
  else
  {
    [appdel.window.rootViewController.view addGestureRecognizer:[appdel.mainContainer panGestureRecognizer]];
  }
}

+ (float)getHeightOffsetForGIB
{
  return 80;
}

#pragma mark - LC Colour - implementation.
+ (UIColor*)colorWithHexString:(NSString*)hexString
{
  NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
  NSString *colorString = [[cString stringByReplacingOccurrencesOfString: @"#" withString: kEmptyStringValue] uppercaseString];
  
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

+ (UIColor *)getThemeRedColor
{
  return [UIColor colorWithRed:250.0f/255 green:70.0f/255 blue:22.0f/255 alpha:1];
}

+ (void)logoutUserClearingDefaults
{
  [LCUtilityManager clearUserDefaultsForCurrentUser];
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  UIStoryboard* storyboard = [UIStoryboard storyboardWithName:kMainStoryBoardIdentifier bundle:nil];
  UIViewController* myStoryBoardInitialViewController = [storyboard instantiateInitialViewController];
  appdel.window.rootViewController = myStoryBoardInitialViewController;
  [appdel.window makeKeyAndVisible];
  LCDLog(@"401");
}


+ (void)clearWebCache
{
  SDImageCache *imageCache = [SDImageCache sharedImageCache];
  [imageCache clearMemory];
  [imageCache clearDisk];
}

@end
