//
//  LCViewCommunity.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCViewCommunity.h"
#import <SDWebImage/UIImageView+WebCache.h>

#pragma mark - LCCommunityDetailCell class
@interface LCCommunityDetailCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *communityDetailsLabel;
@end

@implementation LCCommunityDetailCell
@end

#pragma mark - LCCommunityMemebersCountCell class
@interface LCCommunityMemebersCountCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *communityMemebersCountLabel;
@end

@implementation LCCommunityMemebersCountCell
@end

#pragma mark - LCCommunityWebsiteCell class
@interface LCCommunityWebsiteCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *communityWebsiteLabel;
@end

@implementation LCCommunityWebsiteCell
@end

#pragma mark - LCCommunityCommentsCell class
@interface LCCommunityCommentsCell : UITableViewCell
@property(nonatomic, strong)IBOutlet UILabel *commentDescriptionLabel;
@property(nonatomic, strong)IBOutlet UILabel *commentTimeLabel;
@property(nonatomic, strong)IBOutlet UILabel *commentUserNameLabel;
@property(nonatomic, strong)IBOutlet UIImageView *commentUserImageView;
@end

@implementation LCCommunityCommentsCell
@end

#pragma mark - LCViewCommunity class implementation
#define SECTION_HEIGHT 30
@implementation LCViewCommunity
@synthesize eventID;
#pragma mark - controller life cycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  mainTableView.estimatedRowHeight = 44.0;
  mainTableView.rowHeight = UITableViewAutomaticDimension;
  eventObject = [[LCEvent alloc] init];
  eventObject.eventDescription = @"";
  [self loadCommunityData];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  self.navigationController.navigationBarHidden = true;
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.menuButton setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

#pragma mark - setup functions
-(void)loadCommunityData
{
  [LCAPIManager getEventDetailsForEventWithID:eventID withSuccess:^(id response){
    NSLog(@"%@",response);
    eventObject = response;
    commentsArray = [[NSMutableArray alloc] initWithArray:[LCDummyValues dummyCommentArray]];
    [mainTableView reloadData];
  }andFailure:^(NSString *error){
    NSLog(@"%@",error);
  }];
}

#pragma mark - button actions
- (IBAction)backAction:(id)sender
{
  LCAppDelegate *appdel = (LCAppDelegate *)[[UIApplication sharedApplication] delegate];
  [appdel.GIButton setHidden:NO];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)settingsAction:(id)sender
{
  NSLog(@"settings clicked-->>");
}

- (IBAction)membersAction:(id)sender
{
  NSLog(@"members clicked-->>");
}

- (IBAction)websiteLinkAction:(id)sender
{
  NSLog(@"website link clicked-->>");
}

#pragma mark - TableView delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;    //count of section
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0)//first 3 cells
  {
    return 3;
  }
  return commentsArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return SECTION_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEIGHT)];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, tableView.frame.size.width - 8, SECTION_HEIGHT)];
  [label setFont:[UIFont boldSystemFontOfSize:12]];
  switch (section)
  {
    case 0:
    {
      label.text = @"DETAILS";
    }
      break;
      
      case 1:
    {
      label.text = @"COMMENTS";
    }
      break;
      
    default:
      break;
  }
  [label setTextColor:[UIColor grayColor]];
  [view addSubview:label];
  [view setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
  return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0)
  {
    switch (indexPath.row)
    {
      case 0:
      {
        static NSString *MyIdentifier = @"LCCommunityDetailCell";
        LCCommunityDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil)
        {
          cell = [[LCCommunityDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:eventObject.eventDescription];
        cell.communityDetailsLabel.attributedText = attributedString;
        return cell;
      }
        break;
        
      case 1:
      {
        static NSString *MyIdentifier = @"LCCommunityMemebersCountCell";
        LCCommunityMemebersCountCell * cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil)
        {
          cell = [[LCCommunityMemebersCountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        cell.communityMemebersCountLabel.text = eventObject.eventID;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
      }
        break;
        
      case 2:
      {
        static NSString *MyIdentifier = @"LCCommunityWebsiteCell";
        LCCommunityWebsiteCell * cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil)
        {
          cell = [[LCCommunityWebsiteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        }
        cell.communityWebsiteLabel.text = eventObject.website;
        return cell;
      }
        break;
        
      default:
        break;
    }
  }
  else//comments
  {
    static NSString *MyIdentifier = @"LCCommunityCommentsCell";
    LCCommunityCommentsCell * cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
    {
      cell = [[LCCommunityCommentsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    cell.commentUserNameLabel.text = commentsArray[indexPath.row][@"user_name"];
    cell.commentTimeLabel.text = commentsArray[indexPath.row][@"time"];
    cell.commentDescriptionLabel.text = commentsArray[indexPath.row][@"comment"];
    cell.commentUserImageView.layer.cornerRadius = cell.commentUserImageView.frame.size.width/2;
    [cell.commentUserImageView sd_setImageWithURL:[NSURL URLWithString:commentsArray[indexPath.row][@"profile_pic"]] placeholderImage:[UIImage imageNamed:@"userProfilePic"]];
    return cell;
  }
  
  
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"selected row-->>>%d", (int)indexPath.row);
}

#pragma mark - scrollview delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  float collapseConstant = 0;;
  if (collapseViewHeight.constant>0)
  {
    collapseConstant = collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseViewHeight.constant<170 && scrollView.contentOffset.y<0)
  {
    collapseConstant = collapseViewHeight.constant - scrollView.contentOffset.y;
    [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
  }
  if (collapseConstant<0)
  {
    collapseConstant = 0;
  }
  if (collapseConstant>170)
  {
    collapseConstant = 170;
  }
  collapseViewHeight.constant = collapseConstant;
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
