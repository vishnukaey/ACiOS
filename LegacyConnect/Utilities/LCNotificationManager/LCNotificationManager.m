//
//  LCNotificationManager.m
//  LegacyConnect
//
//  Created by Jijo on 11/2/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "LCNotificationManager.h"

@implementation LCNotificationManager

#pragma mark - post notifications
+ (void)postCreateNewPostNotificationfromResponse :(NSDictionary *)response
{
  NSError *error = nil;
  NSDictionary *dict= response[kResponseData];
  LCFeed *newPost = [MTLJSONAdapter modelOfClass:[LCFeed class] fromJSONDictionary:dict[@"post"] error:&error];
  if(!error)
  {
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:newPost, nil] forKeys:[NSArray arrayWithObjects:@"post", nil]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kCreateNewPostNFK object:nil userInfo:userInfo];
  }
}

+ (void)postUnLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post
{
  post.likeCount = [(NSDictionary*)[response objectForKey:@"data"]objectForKey:@"likeCount"];
  post.didLike = @"0";
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, nil] forKeys:[NSArray arrayWithObjects:@"post", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUnlikedPostNFK object:nil userInfo:userInfo];
}

+ (void)postLikedNotificationfromResponse :(NSDictionary *)response forPost:(LCFeed *)post
{
  post.likeCount = [(NSDictionary*)[response objectForKey:@"data"]objectForKey:@"likeCount"];
  post.didLike = @"1";
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, nil] forKeys:[NSArray arrayWithObjects:@"post", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kLikedPostNFK object:nil userInfo:userInfo];
}

+ (void)postCommentedNotificationforPost:(LCFeed *)post andComment:(LCComment *)comment
{
  post.commentCount = [NSString stringWithFormat:@"%d", [post.commentCount intValue]+1];
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post,comment, nil] forKeys:[NSArray arrayWithObjects:kEntityTypePost,kPostCommentKey, nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kCommentPostNFK object:nil userInfo:userInfo];
}

+ (void)postPostDeletedNotificationforPost: (LCFeed *)post
{
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, nil] forKeys:[NSArray arrayWithObjects:@"post", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kDeletePostNFK  object:nil userInfo:userInfo];
  
  //to update impacts count in profile
  NSDictionary *userInfo_p = @{@"status":@"deleted"};
  [[NSNotificationCenter defaultCenter] postNotificationName:kUserProfileImpactsUpdateNotification object:nil userInfo:userInfo_p];
}

+ (void)postPostEditedNotificationForPost :(LCFeed *)post
{
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, kfeedUpdateEventKey, nil] forKeys:[NSArray arrayWithObjects:@"post", @"event", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePostNFK object:nil userInfo:userInfo];
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
  NSString *newHeaderPhoto = dict[@"headerPhoto"];
  event.headerPhoto = ([newHeaderPhoto isEqual:[NSNull null]] ? nil : newHeaderPhoto);
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kEventDetailsUpdatedNotification object:nil userInfo:userInfo];
}

+ (void)postEventDeletedNotification:(LCEvent*)event
{
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kEventDeletedNotification object:nil userInfo:userInfo];
}

#pragma mark - userUpdate notifications
+ (void)postFriendUpadteNotification :(NSString *)friendID forFriendStatus :(int)status
{
  LCFriend *friend = [[LCFriend alloc] init];
  friend.friendId = friendID;
  friend.isFriend = [NSString stringWithFormat:@"%d", status];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:friend, @"friend", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:friendStatusUpdatedNotification object:nil userInfo:userInfo];
}

+ (void)postNotificationCountUpdatedNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCountUpdated object:nil userInfo:nil];
}

@end
