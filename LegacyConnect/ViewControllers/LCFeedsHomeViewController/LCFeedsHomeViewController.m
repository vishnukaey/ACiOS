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
    

    H_feedsViewArray = [[NSMutableArray alloc]init];
    for (int i=0; i<feedsArray.count; i++) {        
        feedCellView *celViewFinal = [[feedCellView alloc]init];
        [celViewFinal arrangeSelfForData:[feedsArray objectAtIndex:i] forWidth:H_feedsTable.frame.size.width];
        celViewFinal.delegate = self;
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

#pragma mark - feedCell delegates
-(void)feedCellActionWithType:(int)type andID:(NSString *)postID
{
    NSLog(@"actionType--->>>%d", type);
}

@end
