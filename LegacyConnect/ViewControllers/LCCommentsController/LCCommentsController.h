//
//  LCCommentsController.h
//  LegacyConnect
//
//  Created by qbuser on 05/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTTableViewController.h"

@interface LCCommentsController : JTTableViewController<UITextFieldDelegate>
{
  UITextField *commentTextField, *commentTextField_dup;//h_dup is for pushing the keyboard as it wont push for commentfield as it is the input accessory view
  UIButton * postBtn,*dummyPostBtn;
  UIView * commentFieldView, *dummyCommentFieldView;

}
- (void)resignAllResponders;
- (void)enableCommentField:(BOOL)enable;
- (void)changeUpdateButtonState;
- (void)hideCommentsFields;
- (void)showCommentsField;

- (void)tagTapped:(NSDictionary *)tagDetails;
@end
