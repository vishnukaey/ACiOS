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

//label with edge insets
@interface OSLabel : UILabel

@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end

@implementation OSLabel

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

//textField with edge insets
@interface OSTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets edgeInsets;
- (void)addBorderLinesWithColor :(UIColor *)color;

@end

@implementation OSTextField

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



@implementation LCCreateCommunity

#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  LCEvent *com = [[LCEvent alloc] init];
  com.name = @"a";
  com.interestID =@"1";
  
  [LCAPIManager createEvent:com havingHeaderPhoto:nil withSuccess:^(id response) {
    NSLog(@"%@",response);
  } andFailure:^(NSString *error) {
    NSLog(@"%@",error);
  }];
  
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
  OSLabel *nameLabel = [[OSLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  nameLabel.text = @"NAME";
  nameLabel.edgeInsets = edgeInsetLabel;
  nameLabel.font = titleFont;
  nameLabel.textColor = titleColor;
  nameLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:nameLabel];
  topSpace += nameLabel.frame.size.height;
  
  OSTextField *nameField = [[OSTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 40)];
  nameField.placeholder = @"Enter the name of your community";
  nameField.edgeInsets = edgeInsetTextField;
  nameField.font = valueFont;
  [nameField addBorderLinesWithColor:lineColor];
  [self.view addSubview:nameField];
  topSpace += nameField.frame.size.height;
  //about
  OSLabel *aboutLabel = [[OSLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  aboutLabel.text = @"ABOUT";
  aboutLabel.edgeInsets = edgeInsetLabel;
  aboutLabel.font = titleFont;
  aboutLabel.textColor = titleColor;
  aboutLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:aboutLabel];
  topSpace += aboutLabel.frame.size.height;
  
  OSTextField *aboutField = [[OSTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 60)];
  aboutField.placeholder = @"Tell people a little about it";
  aboutField.edgeInsets = edgeInsetTextField;
  aboutField.font = valueFont;
  [aboutField addBorderLinesWithColor:lineColor];
  [self.view addSubview:aboutField];
  topSpace += aboutField.frame.size.height;
  //date
  OSLabel *dateLabel = [[OSLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  dateLabel.text = @"DATE & TIME(Optional)";
  dateLabel.edgeInsets = edgeInsetLabel;
  dateLabel.font = titleFont;
  dateLabel.textColor = titleColor;
  dateLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:dateLabel];
  topSpace += dateLabel.frame.size.height;
  
  OSTextField *dateSelection = [[OSTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 40)];
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
  OSLabel *websiteLabel = [[OSLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  websiteLabel.text = @"WEBSITE(Optional)";
  websiteLabel.edgeInsets = edgeInsetLabel;
  websiteLabel.font = titleFont;
  websiteLabel.textColor = titleColor;
  websiteLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:websiteLabel];
  topSpace += websiteLabel.frame.size.height;
  
  OSTextField *websiteField = [[OSTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 40)];
  websiteField.placeholder = @"Enter the community website";
  websiteField.edgeInsets = edgeInsetTextField;
  websiteField.font = valueFont;
  [websiteField addBorderLinesWithColor:lineColor];
  [self.view addSubview:websiteField];
  topSpace += websiteField.frame.size.height;
  //headerphoto
  OSLabel *headerphotoLabel = [[OSLabel alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, titleheight)];
  headerphotoLabel.text = @"HEADER PHOTO(Optional)";
  headerphotoLabel.edgeInsets = edgeInsetLabel;
  headerphotoLabel.font = titleFont;
  headerphotoLabel.textColor = titleColor;
  headerphotoLabel.backgroundColor = titleBackGroundColor;
  [self.view addSubview:headerphotoLabel];
  topSpace += headerphotoLabel.frame.size.height;
  
  OSTextField *headerphotoSelection = [[OSTextField alloc] initWithFrame:CGRectMake(0, topSpace, self.view.frame.size.width, 40)];
  headerphotoSelection.placeholder = @"Add a background header photo";
  headerphotoSelection.edgeInsets = edgeInsetTextField;
  headerphotoSelection.font = valueFont;
  [headerphotoSelection addBorderLinesWithColor:lineColor];
  [self.view addSubview:headerphotoSelection];
  UIButton *headerphotoSelectionButton = [[UIButton alloc] initWithFrame:headerphotoSelection.frame];
  [self.view addSubview:headerphotoSelectionButton];
  [headerphotoSelectionButton addTarget:self action:@selector(headerPhotoSelection) forControlEvents:UIControlEventTouchUpInside];
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
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCInviteToCommunity *vc = [sb instantiateViewControllerWithIdentifier:@"LCInviteToCommunity"];
  [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)cancelAction
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)dateSelection
{
  UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"Community" bundle:nil];
  LCCommunityDateSelection *vc = [sb instantiateViewControllerWithIdentifier:@"LCCommunityDateSelection"];
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
  NSLog(@"image picked-->>%@", chosenImage);
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


