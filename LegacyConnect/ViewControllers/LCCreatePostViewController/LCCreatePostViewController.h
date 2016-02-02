//
//  LCCreatePostViewController.h
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCListFriendsToTagViewController.h"
#import "LCListLocationsToTagVC.h"
#import "LCListInterestsAndCausesVC.h"
#import "LCSocialShareManager.h"
#import "LCCreatePostBC.h"

@interface LCCreatePostViewController : LCCreatePostBC <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, LCListFriendsToTagViewControllerDelegate, LCListLocationsToTagVCDelegate, LCListInterestsAndCausesVCDelegate>







@property(nonatomic, assign) BOOL isEditing, isImageEdited;

@property(nonatomic, retain)LCSocialShareManager *TWsocialShare;

@end
