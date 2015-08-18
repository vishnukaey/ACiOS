//
//  LCCreateCommunity.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCCreateCommunity.h"
#import "LCInviteToCommunity.h"
#import "LCCommunityDateSelection.h"

#pragma mark - insetLabel class
@interface insetLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation insetLabel

- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  }
  return self;
}

- (void)drawTextInRect:(CGRect)rect {
  [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize
{
  CGSize size = [super intrinsicContentSize];
  size.width  += self.edgeInsets.left + self.edgeInsets.right;
  size.height += self.edgeInsets.top + self.edgeInsets.bottom;
  return size;
}

@end

#pragma mark - insetTextField class
@interface insetTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
- (void)addBorderLinesWithColor :(UIColor *)color;

@end

@implementation insetTextField

- (id)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
  }
  return self;
}

- (void)addBorderLinesWithColor :(UIColor *)color;
{
  UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
  [topLine setBackgroundColor:color];
  [self addSubview:topLine];
  
  UIView *botLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
  [botLine setBackgroundColor:color];
  [self addSubview:botLine];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
  return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
  return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

@end


#pragma mark - LCCreateCommunity class

@interface LCCreateCommunity ()
{
  insetTextField *communityNameField;
  insetTextField *aboutCommunityField;
  insetTextField *communityWebsiteField;
  UIImageView *headerPhotoImageView;
}

@end

@implementation LCCreateCommunity
@synthesize communityDate, interestId;

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view
  float topSpace = 64;
  float titleheight = 40;
  UIEdgeInsets edgeInsetLabel = UIEdgeInsetsMake(0, 10, -20, 0);
  UIEdgeInsets edgeInsetTextField = UIEdgeInsetsMake(0, 10, 0, 0);
  UIFont *titleFont = [UIFont boldSystemFontOfSize:12];
  UIFont *valueFont = [UIFont systemFontOfSize:14];
  UIColor *titleColor = [UIColor darkGrayColor];
  UIColor *titleBackGroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
  UIColor *lineColor = [UIColor lightGrayColor];
  //name
  insetLabel *nameLabel = [[insetLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  nameLabel.text = @"NAME";
  nameLabel.edgeInsets = edgeInsetLabel;
  nameLabel.font = titleFont;
  nameLabel.textColor = titleColor;
  nameLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:nameLabel];
  topSpace += nameLabel.frame.size.height;
  
  communityNameField = [[insetTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 40)];
  communityNameField.placeholder = @"Enter the name of your community";
  communityNameField.edgeInsets = edgeInsetTextField;
  communityNameField.font = valueFont;
  [communityNameField addBorderLinesWithColor:lineColor];
  [self.view addSubview:communityNameField];
  topSpace += communityNameField.frame.size.height;
  //about
  insetLabel *aboutLabel = [[insetLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  aboutLabel.text = @"ABOUT";
  aboutLabel.edgeInsets = edgeInsetLabel;
  aboutLabel.font = titleFont;
  aboutLabel.textColor = titleColor;
  aboutLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:aboutLabel];
  topSpace += aboutLabel.frame.size.height;
  
  aboutCommunityField = [[insetTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 60)];
  aboutCommunityField.placeholder = @"Tell people a little about it";
  aboutCommunityField.edgeInsets = edgeInsetTextField;
  aboutCommunityField.font = valueFont;
  [aboutCommunityField addBorderLinesWithColor:lineColor];
  [self.view addSubview:aboutCommunityField];
  topSpace += aboutCommunityField.frame.size.height;
  //date
  insetLabel *dateLabel = [[insetLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  dateLabel.text = @"DATE & TIME(Optional)";
  dateLabel.edgeInsets = edgeInsetLabel;
  dateLabel.font = titleFont;
  dateLabel.textColor = titleColor;
  dateLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:dateLabel];
  topSpace += dateLabel.frame.size.height;
  
  insetTextField *dateSelection = [[insetTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 40)];
  dateSelection.placeholder = @"None";
  dateSelection.edgeInsets = edgeInsetTextField;
  dateSelection.font = valueFont;
  [dateSelection addBorderLinesWithColor:lineColor];
  [self.view addSubview:dateSelection];
  dateSelection.userInteractionEnabled = NO;
  UIButton *dateSelectionButton = [[UIButton alloc] initWithFrame:dateSelection.frame];
  [self.view addSubview:dateSelectionButton];
  [dateSelectionButton addTarget:self action:@selector(dateSelection) forControlEvents:UIControlEventTouchUpInside];
  topSpace += dateSelection.frame.size.height;
  //website
  insetLabel *websiteLabel = [[insetLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  websiteLabel.text = @"WEBSITE(Optional)";
  websiteLabel.edgeInsets = edgeInsetLabel;
  websiteLabel.font = titleFont;
  websiteLabel.textColor = titleColor;
  websiteLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:websiteLabel];
  topSpace += websiteLabel.frame.size.height;
  
  communityWebsiteField = [[insetTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 40)];
  communityWebsiteField.placeholder = @"Enter the community website";
  communityWebsiteField.edgeInsets = edgeInsetTextField;
  communityWebsiteField.font = valueFont;
  [communityWebsiteField addBorderLinesWithColor:lineColor];
  [self.view addSubview:communityWebsiteField];
  topSpace += communityWebsiteField.frame.size.height;
  //headerphoto
  insetLabel *headerphotoLabel = [[insetLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  headerphotoLabel.text = @"HEADER PHOTO(Optional)";
  headerphotoLabel.edgeInsets = edgeInsetLabel;
  headerphotoLabel.font = titleFont;
  headerphotoLabel.textColor = titleColor;
  headerphotoLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:headerphotoLabel];
  topSpace += headerphotoLabel.frame.size.height;
  
  insetTextField *headerphotoSelection = [[insetTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 40)];
  headerphotoSelection.placeholder = @"Add a background header photo";
  headerphotoSelection.edgeInsets = edgeInsetTextField;
  headerphotoSelection.font = valueFont;
  [headerphotoSelection addBorderLinesWithColor:lineColor];
  [self.view addSubview:headerphotoSelection];
  UIButton *headerphotoSelectionButton = [[UIButton alloc] initWithFrame:headerphotoSelection.frame];
  [self.view addSubview:headerphotoSelectionButton];
  [headerphotoSelectionButton addTarget:self action:@selector(headerPhotoSelection) forControlEvents:UIControlEventTouchUpInside];
  
  headerPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - headerphotoSelectionButton.frame.size.height, headerphotoSelectionButton.frame.origin.y, headerphotoSelectionButton.frame.size.height, headerphotoSelectionButton.frame.size.height)];
  [self.view addSubview:headerPhotoImageView];
  
  topSpace += headerphotoSelection.frame.size.height;
}

- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:true];
  [appdel.menuButton setHidden:true];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - button actions
- (IBAction)nextButtonAction
{
  LCCommunity *com = [[LCCommunity alloc] init];
  com.name = communityNameField.text;
  com.interestID = self.interestId;
  com.website = communityWebsiteField.text;
  com.communityDescription = aboutCommunityField.text;
  com.time = self.communityDate;
  com.headerPhoto = headerPhotoImageView.image;
  
  NSLog(@"comm--->>%@", com);
  
  [LCAPIManager createCommunity:com withSuccess:^(id response) {
    NSLog(@"%@",response);
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
    LCInviteToCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCInviteToCommunity"];
    [self.navigationController pushViewController:vc animated:YES];
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
}

- (IBAction)cancelAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)dateSelection
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCCommunityDateSelection *vc = [sb instantiateViewControllerWithIdentifier:@"LCCommunityDateSelection"];
  communityDate = [[NSMutableString alloc]initWithString:@"test"];;
  vc.datePointer = communityDate;
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)headerPhotoSelection
{
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Photo" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"From Library", @"From Camera", nil];
  [sheet showInView:self.view];
}

#pragma mark - UIActionSheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex < 2)
  {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    UIImagePickerControllerSourceType type;
    switch (buttonIndex)
    {
      case 0:
        type = UIImagePickerControllerSourceTypePhotoLibrary;
        break;
      case 1:
        type = UIImagePickerControllerSourceTypeCamera;
        break;

      default:
        break;
    }
    imagePicker.sourceType = type;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:^{ }];
  }
}

#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  [picker dismissViewControllerAnimated:YES completion:NULL];
  UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
  headerPhotoImageView.image = chosenImage;
//  NSLog(@"image picked-->>%@", chosenImage);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


