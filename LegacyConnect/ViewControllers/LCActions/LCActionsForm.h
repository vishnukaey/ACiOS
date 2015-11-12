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
@property(nonatomic, strong) IBOutlet UITextField *actionNameField;
@property(nonatomic, retain) IBOutlet UITextView *actionAboutField;
@property(nonatomic, retain) IBOutlet UITextField *actionWebsiteField;
@property(nonatomic, retain) IBOutlet UITextField *actionDateField;
@property(nonatomic, retain) IBOutlet UITextField *actionTypeField;
@property(nonatomic, retain) IBOutlet UITextField *headerImagePlaceholder;
@property(nonatomic, retain) IBOutlet UITextField *aboutPlaceholder;
@property(nonatomic, retain) IBOutlet UIImageView *headerPhotoImageView;
@property(nonatomic, retain) IBOutlet UITableView *formTableView;
@property(nonatomic, retain) IBOutlet UIButton *nextButton, *cancelButton, *backButton, *deleteActionBut;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *imageLoadingIndicator;
@property(nonatomic, retain) IBOutlet NSLayoutConstraint *deleteActionConstraint;
@property(nonatomic, assign)BOOL isImageLoading;
@property(nonatomic, retain) NSDate *startDate, *endDate;


- (IBAction)cancelAction;
- (void)setHeaderImage :(UIImage *)image;
- (void)validateFields;
- (NSString *)getActionFormatedDateString :(NSDate *)date;

@end
