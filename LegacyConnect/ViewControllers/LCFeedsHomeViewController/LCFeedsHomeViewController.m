  //
//  LCFeedsHomeViewController.m
//  LegacyConnect
//
//  Created by qbuser on 7/9/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCFeedsHomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GIButton.h"





@interface LCFeedsHomeViewController ()

@end

@implementation LCFeedsHomeViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
    
    GIButton * giButton = [[GIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 60, 50, 50)];
    [self.view addSubview:giButton];
    [giButton setUpMenu];
    [giButton addTarget:self action:@selector(GIBAction:) forControlEvents:UIControlEventTouchUpInside];
    giButton.P_community.tag = 0;
    [giButton.P_community addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    giButton.P_video.tag = 1;
    [giButton.P_video addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
    
    giButton.P_status.tag = 2;
    [giButton.P_status addTarget:self action:@selector(GIBComponentsAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    H_feedsTable.layer.borderColor = [UIColor yellowColor].CGColor;
//    H_feedsTable.layer.borderWidth = 4;
    [H_feedsTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
}

-(void)GIBComponentsAction :(UIButton *)sender
{
    NSLog(@"tag-->>%d", (int)sender.tag);
}

-(void)GIBAction :(GIButton *)sender
{
    NSLog(@"gib-->>");
    if (sender.tag ==0) {
        sender.tag = 1;
        [sender showMenu];
    }
    else
    {
        sender.tag = 0 ;
        [sender hideMenu];
    }
}

-(void)prepareFeedViews
{
    NSDictionary *dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Json Rogers",@"user_name",   @"1",@"type",     @"Global Employment",@"cause",  @"15 minutes ago",@"time",   @"Can't wait to run in Haiti for TeamTassy, stay tuned for details!",@"post",   @"",@"image_url",  @"0",@"favourite",   @"8",@"thanks",  @"2",@"comments",  nil];
    
    NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Mark Smith",@"user_name",   @"2",@"type",     @"Ocean Initiative group",@"cause",  @"35 minutes ago",@"time",   @"Perfect weather for today's meetup!",@"post",   @"",@"image_url",  @"0",@"favourite",   @"8",@"thanks",  @"2",@"comments",   @"",@"profile_pic",  nil];
    
    NSArray *feedsArray = [[NSArray alloc]initWithObjects:dic1, dic2, nil];
    
    
    
    float cellMargin_x = 15, cellMargin_y = 8;
    float dp_im_hight = 60;
    float in_margin = 10;
    float favWidth = 5;
    float cellSpacing_height  = 5;
    
    UIFont *bigFont = [UIFont systemFontOfSize:15];
    UIFont *smallFont = [UIFont systemFontOfSize:12];

    H_feedsViewArray = [[NSMutableArray alloc]init];
    for (int i=0; i<feedsArray.count; i++) {
        float top_space = 0;
        
        UIView *celViewFinal = [[UIView alloc] initWithFrame:CGRectMake(0, 0,H_feedsTable.frame.size.width,0)];
        
        UIView *celSpace = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, H_feedsTable.frame.size.width+4, cellSpacing_height)];//spacing  between cells
        celSpace.layer.borderColor = [UIColor lightTextColor].CGColor;
        celSpace.layer.borderWidth = 1;
        celSpace.backgroundColor = [UIColor lightGrayColor];
        [celViewFinal addSubview:celSpace];
        
        top_space+=cellSpacing_height+cellMargin_y;
        
        NSString  *userName = [[feedsArray objectAtIndex:i] valueForKey:@"user_name"];
        NSString *dp_data = [[feedsArray objectAtIndex:i] valueForKey:@"profile_pic"];
        NSString *cause = [[feedsArray objectAtIndex:i] valueForKey:@"cause"];
        NSString *time_ = [[feedsArray objectAtIndex:i] valueForKey:@"time"];
        NSString *post_ = [[feedsArray objectAtIndex:i] valueForKey:@"post"];
        NSString *thanks_ = [[feedsArray objectAtIndex:i] valueForKey:@"thanks"];
        NSString *comments_ = [[feedsArray objectAtIndex:i] valueForKey:@"comments"];
        NSString *favourite_ = [[feedsArray objectAtIndex:i] valueForKey:@"favourite"];
        NSString *type_ = @"Created a Post";
        if ([[[feedsArray objectAtIndex:i] valueForKey:@"type"] intValue] == 2) {
            type_ = @"Added a Photo";
        }
        NSString *image_ = [[feedsArray objectAtIndex:i] valueForKey:@"image_url"];
        
        UIImageView *dp_view = [[UIImageView alloc]initWithFrame:CGRectMake(cellMargin_x, top_space, dp_im_hight, dp_im_hight)];
        [dp_view setImage:[UIImage imageNamed:@"clock.jpg"]];
        [celViewFinal addSubview:dp_view];
        
        UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(dp_view.frame.origin.x + dp_view.frame.size.width + cellMargin_x, top_space, celViewFinal.frame.size.width - 2*cellMargin_x - dp_view.frame.size.width  - favWidth, 0)];
        [celViewFinal addSubview:infoLabel];
        infoLabel.numberOfLines = 0;
        
        
        NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:@""];
        //name
        NSAttributedString *name_attr = [[NSAttributedString alloc] initWithString : userName
                                                                        attributes : @{
                                                                                       NSFontAttributeName : bigFont,
                                                                                       NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                       }];
        [attributtedString appendAttributedString:name_attr];
        
        NSAttributedString *type_attr = [[NSAttributedString alloc] initWithString : [NSString stringWithFormat:@" %@\n",type_]
                                                                        attributes : @{
                                                                                       NSFontAttributeName : bigFont,
                                                                                       NSForegroundColorAttributeName : [UIColor grayColor],
                                                                                       }];
        [attributtedString appendAttributedString:type_attr];
        
        //cause
        NSAttributedString *cause_attr = [[NSAttributedString alloc] initWithString : [NSString stringWithFormat:@"%@",cause]
                                                                         attributes : @{
                                                                                        NSFontAttributeName : bigFont,
                                                                                        NSForegroundColorAttributeName : [UIColor redColor],
                                                                                        }];
        [attributtedString appendAttributedString:cause_attr];
        [infoLabel setAttributedText:attributtedString];
        
        
        CGRect rect = [attributtedString boundingRectWithSize:CGSizeMake(infoLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        [infoLabel setFrame:CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y, infoLabel.frame.size.width, rect.size.height)];
        
        
        
        
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(infoLabel.frame.origin.x, infoLabel.frame.origin.y + infoLabel.frame.size.height + 5, infoLabel.frame.size.width, smallFont.pointSize)];
        [celViewFinal addSubview:timeView];
        
        UIImageView *clockImView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, timeView.frame.size.height, timeView.frame.size.height)];
        clockImView.image = [UIImage imageNamed:@"clock.jpg"];
        [timeView addSubview:clockImView];
        
        UILabel *time_label = [[UILabel alloc]initWithFrame:CGRectMake(clockImView.frame.size.width + 5, 0, timeView.frame.size.width - clockImView.frame.size.width - 5, timeView.frame.size.height)];
        time_label.font = smallFont;
        time_label.text = time_;
        time_label.textColor = [UIColor grayColor];
        [timeView addSubview:time_label];
        
        if (timeView.frame.size.height + timeView.frame.origin.y>dp_view.frame.size.height + dp_view.frame.origin.y) {
            top_space=timeView.frame.size.height + timeView.frame.origin.y + in_margin;
        }else top_space=dp_view.frame.size.height + dp_view.frame.origin.y+in_margin;
        
        
        
        UILabel *postLabel = [[UILabel alloc]initWithFrame:CGRectMake(cellMargin_x, top_space, celViewFinal.frame.size.width - 2*cellMargin_x - favWidth, 0)];
        [celViewFinal addSubview:postLabel];
        postLabel.numberOfLines = 0;
        
        NSMutableAttributedString * post_attributtedString = [[NSMutableAttributedString alloc] initWithString:post_ attributes : @{
                                                                                                                                    NSFontAttributeName : bigFont,
                                                                                                                                    NSForegroundColorAttributeName : [UIColor blackColor],
                                                                                                                                    }];
        [postLabel setAttributedText:post_attributtedString];
        
        rect = [post_attributtedString boundingRectWithSize:CGSizeMake(postLabel.frame.size.width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        [postLabel setFrame:CGRectMake(postLabel.frame.origin.x, postLabel.frame.origin.y, postLabel.frame.size.width, rect.size.height)];
        
        top_space+=postLabel.frame.size.height + in_margin;
        
        if ([[[feedsArray objectAtIndex:i] valueForKey:@"type"] intValue] == 2)//photo
        {
            UIImageView *statusPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(cellMargin_x, top_space, celViewFinal.frame.size.width - 2*cellMargin_x, 100)];
            [statusPhoto setImage:[UIImage imageNamed:@"clock.jpg"]];
            [celViewFinal addSubview:statusPhoto];
            top_space += statusPhoto.frame.size.height + in_margin;
        }else
        {
            UIView *thinLine = [[UIView alloc]initWithFrame:CGRectMake(0, top_space, celViewFinal.frame.size.width, 1)];
            [celViewFinal addSubview:thinLine];
            [thinLine setBackgroundColor:[UIColor lightGrayColor]];
            top_space += thinLine.frame.size.height;
        }
        
        
        
        //bottom row
        float bot_row_hight = 40;
        float bot_IC_hight = 30;
        float bot_labe_width = 90;
        
        UIView * botRow = [[UIView alloc] initWithFrame:CGRectMake(cellMargin_x, top_space, celViewFinal.frame.size.width - 2*cellMargin_x, bot_row_hight)];
        [celViewFinal addSubview:botRow];
        UIImageView *likeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (bot_row_hight - bot_IC_hight)/2, bot_IC_hight, bot_IC_hight)];
        [likeIcon setImage:[UIImage imageNamed:@"clock.jpg"]];
        [botRow addSubview:likeIcon];
        
        UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(bot_row_hight + 10, (bot_row_hight - bot_IC_hight)/2, bot_IC_hight, bot_IC_hight)];
        [commentIcon setImage:[UIImage imageNamed:@"clock.jpg"]];
        [botRow addSubview:commentIcon];
        
        
        UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(botRow.frame.size.width - bot_labe_width, 0, bot_labe_width, botRow.frame.size.height)];
        commentsLabel.font = smallFont;
        [commentsLabel setText:[NSString stringWithFormat:@"%@ COMMENTS", comments_]];
        [botRow addSubview:commentsLabel];
        [commentsLabel setTextAlignment:NSTextAlignmentCenter];
        
        UILabel *thanksLabel = [[UILabel alloc] initWithFrame:CGRectMake(botRow.frame.size.width - bot_labe_width*2, 0, bot_labe_width, botRow.frame.size.height)];
        thanksLabel.font = smallFont;
        [thanksLabel setText:[NSString stringWithFormat:@"%@ THANKS", thanks_]];
        [botRow addSubview:thanksLabel];
        [thanksLabel setTextAlignment:NSTextAlignmentCenter];
        
        top_space+=botRow.frame.size.height;
        
         [celViewFinal setFrame:CGRectMake(0, 0, celViewFinal.frame.size.width, top_space)];
        
        
        [H_feedsViewArray addObject:celViewFinal];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self prepareFeedViews];
    [H_feedsTable reloadData];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)logout:(id)sender
{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:NO forKey:@"logged_in"];
  [defaults synchronize];
  if ([FBSDKAccessToken currentAccessToken])
  {
    [[FBSDKLoginManager new] logOut];
  }
  [self.navigationController popToRootViewControllerAnimated:NO];
}



#pragma mark - TableView delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;    //count of section
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return H_feedsViewArray.count;    //count number of row from counting array hear cataGorry is An Array
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    [[cell viewWithTag:10] removeFromSuperview];
    
    UIView *cellView = (UIView *)[H_feedsViewArray objectAtIndex:indexPath.row];
    [cell addSubview:cellView];
    cellView.tag = 10;
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    UIView *cellView = (UIView *)[H_feedsViewArray objectAtIndex:indexPath.row];
    
    return cellView.frame.size.height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"selected row-->>>%d", (int)indexPath.row);
}


@end
