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
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, kfeedUpdateEventKey, nil] forKeys:[NSArray arrayWithObjects:@"post", @"event", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
}

+ (void)postLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post
{
  post.likeCount = [(NSDictionary*)[response objectForKey:@"data"]objectForKey:@"likeCount"];
  post.didLike = @"1";
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, kfeedUpdateEventKey, nil] forKeys:[NSArray arrayWithObjects:@"post", @"event", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
}

+ (void)postCommentedNotificationforPost:(LCFeed *)post
{
  post.commentCount = [NSString stringWithFormat:@"%ld", [post.commentCount integerValue]+1];
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, kfeedUpdateEventKey, nil] forKeys:[NSArray arrayWithObjects:@"post", @"event", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
}

+ (void)postPostDeletedNotificationforPost: (LCFeed *)post
{
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, kfeedDeletedEventKey, nil] forKeys:[NSArray arrayWithObjects:@"post", @"event", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
  
  //to update impacts count in profile
  NSDictionary *userInfo_p = @{@"status":@"deleted"};
  [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileImpactsUpdateNotification object:nil userInfo:userInfo_p];
}

+ (void)postPostEditedNotificationForPost :(LCFeed *)post
{
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, kfeedUpdateEventKey, nil] forKeys:[NSArray arrayWithObjects:@"post", @"event", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
}

+ (void)postRemoveMilestoneNotificationForPost :(LCFeed *)post
{
  post.isMilestone = @"0";
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, kfeedUpdateEventKey, nil] forKeys:[NSArray arrayWithObjects:@"post", @"event", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kfeedUpdatedotification object:nil userInfo:userInfo];
}

#pragma mark - event notifications
+ (void)postEventCreatedNotificationWithEvent:(LCEvent*)event andResponse:(NSDictionary*)response
{
  NSDictionary *dict= response[kResponseData];
  event.eventID = ([dict[@"eventId"] isEqual:[NSNull null]] ? nil : dict[@"eventId"]);
  event.headerPhoto = ([dict[@"headerPhoto"] isEqual:[NSNull null]] ? nil : dict[@"headerPhoto"]);

  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kEventCreatedNotification object:nil userInfo:userInfo];
}

+ (void)postEventMembersCountUpdatedNotification:(LCEvent*)event
{
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kEventMemberCountUpdatedNotification object:nil userInfo:userInfo];
}

+ (void)postEventDetailsUpdatedNotificationWithResponse:(NSDictionary*)response andEvent:(LCEvent*)event
{
  NSDictionary *dict= response[kResponseData];
  NSDictionary * idDict = dict[kIDKey];
  NSString *newHeaderPhoto = idDict[@"headerPhoto"];
  event.headerPhoto = ([newHeaderPhoto isEqual:[NSNull null]] ? nil : newHeaderPhoto);
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kEventDetailsUpdatedNotification object:nil userInfo:userInfo];
}

+ (void)postEventDeletedNotification:(LCEvent*)event
{
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kEventDeletedNotification object:nil userInfo:userInfo];
}

@end
