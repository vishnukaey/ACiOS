//
//  LCCommentsController.h
//  LegacyConnect
//
//  Created by qbuser on 05/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCFeedTableViewController.h"

@interface LCCommentsController : LCFeedTableViewController<UITextFieldDelegate>
{
  UITextField *commentTextField, *commentTextField_dup;//h_dup is for pushing the keyboard as it wont push for commentfield as it is the input accessory view
  UIButton * postBtn,*dummyPostBtn;

}

@end
