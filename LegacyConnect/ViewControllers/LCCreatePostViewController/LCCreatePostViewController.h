//
//  LCCreatePostViewController.h
//  LegacyConnect
//
//  Created by Govind_Office on 11/08/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol createPostDelegate <NSObject>

- (void)dismissView;

@end

@interface LCCreatePostViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>


@property (nonatomic, unsafe_unretained) NSObject <createPostDelegate> *delegate;

@property(nonatomic,retain) IBOutlet UIView *popUpView;

@property(nonatomic,retain) IBOutlet UITextView *postTextView;


@end
