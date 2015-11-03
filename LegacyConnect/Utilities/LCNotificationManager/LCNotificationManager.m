//
//  LCNotificationManager.m
//  LegacyConnect
//
//  Created by Jijo on 11/2/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCNotificationManager.h"

@implementation LCNotificationManager

+ (void)postUnLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post
{
  post.likeCount = [(NSDictionary*)[response objectForKey:@"data"]objectForKey:@"likeCount"];
  post.didLike = @"0";
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:post] forKeys:[NSArray arrayWithObject:@"post"]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
}

+ (void)postLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post
{
  post.likeCount = [(NSDictionary*)[response objectForKey:@"data"]objectForKey:@"likeCount"];
  post.didLike = @"1";
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:post] forKeys:[NSArray arrayWithObject:@"post"]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
}

+ (void)postCommentedNotificationforPost:(LCFeed *)post
{
  post.commentCount = [NSString stringWithFormat:@"%ld", [post.commentCount integerValue]+1];
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObject:post] forKeys:[NSArray arrayWithObject:@"post"]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
}

@end
