//
//  LCDummyValues.m
//  LegacyConnect
//
//  Created by User on 7/22/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCDummyValues.h"

@implementation LCDummyValues

+ (NSArray *)dummyFeedArray
{
  NSDictionary *dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Json Rogers",@"user_name",     @"Global Employment",@"cause",  @"15 minutes ago",@"time",   @"Can't wait to run in Haiti for TeamTassy, stay tuned for details!",@"post",   @"",@"image_url",  @"0",@"favourite",   @"8",@"thanks",  @"2",@"comments",  nil];
  NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Mark Smith",@"user_name",   @"2",@"type",     @"Ocean Initiative group",@"cause",  @"35 minutes ago",@"time",   @"Perfect weather for today's meetup!",@"post",   @"photoPost_dummy.png",@"image_url",  @"0",@"favourite",   @"8",@"thanks",  @"2",@"comments",   @"",@"profile_pic",  nil];
  NSArray *feedsArray = [[NSArray alloc]initWithObjects:dic1, dic2, nil];
  
  return feedsArray;
}

+ (NSArray *)dummyPROFILEFeedArray
{
  NSDictionary *dic1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Json Rogers",@"user_name",   @"1",@"type",     @"Global Employment",@"cause",  @"15 minutes ago",@"time",   @"Can't wait to run in Haiti for TeamTassy, stay tuned for details!",@"post",   @"",@"image_url",  @"0",@"favourite",   @"8",@"thanks",  @"2",@"comments",  nil];
  NSDictionary *dic2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Json Rogers",@"user_name",   @"1",@"type",     @"WATER",@"cause",  @"15 minutes ago",@"time",   @"Just arrived at Ocean Grove. Who's ready for some sun and sand?",@"post",   @"photoPost_dummy.png",@"image_url",  @"0",@"favourite",   @"8",@"thanks",  @"2",@"comments",  nil];
  NSArray *feedsArray = [[NSArray alloc]initWithObjects:dic1, dic2, nil];
  
  return feedsArray;
}

+ (NSArray *)dummyCommentArray
{
  NSDictionary *comm1 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Mel Matthews",@"user_name",         @"5 mins",@"time",   @"Amazing Json! Best of luck.",@"comment",    @"",@"profile_pic",  nil];
  NSDictionary *comm2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Amy Samson",@"user_name",         @"10 mins",@"time",   @"This is incredible! All the best and keep us posted in your journy.This is incredible! All the best and keep us posted in your journy.This is incredible! All the best and keep us posted in your journy.This is incredible! All the best and keep us posted in your journy.This is incredible! All the best and keep us posted in your journy.This is incredible! All the best and keep us posted in your journy.This is incredible! All the best and keep us posted in your journy.This is incredible! All the best and keep us posted in your journy.",@"comment",    @"",@"profile_pic",  nil];
  NSDictionary *comm3 = [[NSDictionary alloc]initWithObjectsAndKeys:@"Mel Matthews",@"user_name",         @"5 mins",@"time",   @"Amazing Json! Best of luck.",@"comment",    @"",@"profile_pic",  nil];
  NSArray *commentsArray = [[NSArray alloc]initWithObjects:comm1, comm2, comm3, nil];
  
  return commentsArray;
}

+ (NSArray *)dummyFriendsArray
{
  NSArray *friendsArray = [[NSArray alloc]initWithObjects:@"Adam Murry", @"Amanda Jones", @"Billy Johnson", nil];
  
  return friendsArray;
}

@end
