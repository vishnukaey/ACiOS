//
//  LCCreateActions.h
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCActionsDateSelection.h"


typedef enum actionSectionTypes
{
  SECTION_NAME,
  SECTION_ACTIONTYPE,
  SECTION_DATE,
  SECTION_WEBSITE,
  SECTION_HEADER,
  SECTION_ABOUT
} sectionType;

@protocol LCActionFormDelegate <NSObject>
- (void)selectHeaderPhoto;
- (UITableViewCell *)tableview:(UITableView *)tableview cellForRowAtIndexPathDelegate:(NSIndexPath *)indexPath;
@optional
- (void)nextButtonAction;
- (void)cancelAction;
- (void)delegatedViewDidLoad;
- (void)deleteActionEvent;

@end

static NSString *  kCellIdentifierName = @"LCActionNameCell";
static NSString *  kCellIdentifierType = @"LCActionTypeCell";
static NSString *  kCellIdentifierDate = @"LCActionDateCell";
static NSString *  kCellIdentifierWebsite = @"LCActionWebsiteCell";
static NSString *  kCellIdentifierHeaderBG = @"LCActionHeaderCell";
static NSString *  kCellIdentifierAbout = @"LCActionAboutCell";
static NSString *  kCellIdentifierSection = @"LCActionSectionHeader";

@interface LCActionsForm : UIViewController<UITextViewDelegate, actionDateDelegate>

@property(nonatomic, retain) id delegate;
@property(nonatomic, strong)  UITextField *actionNameField;
@property(nonatomic, retain)  UITextView *actionAboutField;
@property(nonatomic, retain)  UITextField *actionWebsiteField;
@property(nonatomic, retain)  UITextField *actionDateField;
@property(nonatomic, retain)  UITextField *actionTypeField;
@property(nonatomic, retain)  UITextField *headerImagePlaceholder;
@property(nonatomic, retain)  UITextField *aboutPlaceholder;
@property(nonatomic, retain)  UIImageView *headerPhotoImageView;
@property(nonatomic, retain) IBOutlet UITableView *formTableView;
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UIButton *nextButton, *cancelButton, *backButton, *deleteActionBut;
@property(nonatomic, retain)
UIActivityIndicatorView *imageLoadingIndicator;
@property(nonatomic, retain) IBOutlet NSLayoutConstraint *deleteActionConstraint;
@property(nonatomic, assign)BOOL isImageLoading;
@property(nonatomic, retain) NSDate *startDate, *endDate;


- (IBAction)cancelAction;
- (void)setHeaderImage :(UIImage *)image;
- (void)validateFields;
- (NSString *)getActionFormatedDateString :(NSDate *)date;

@end
