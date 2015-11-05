//
//  LCCreateActions.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LCCreateActions : UIViewController<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, retain)NSMutableString *communityDate;
@property(nonatomic, retain)NSString *interestId;

- (IBAction)cancelAction;
- (IBAction)nextButtonAction;

@end
