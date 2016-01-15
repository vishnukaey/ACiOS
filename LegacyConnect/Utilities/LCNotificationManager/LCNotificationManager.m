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
}

+ (void)postPostEditedNotificationForPost :(LCFeed *)post
{
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, nil] forKeys:[NSArray arrayWithObjects:kEntityTypePost, nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePostNFK object:nil userInfo:userInfo];
}

+ (void)postRemoveMilestoneNotificationForPost :(LCFeed *)post
{
  post.isMilestone = @"0";
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:post, nil] forKeys:[NSArray arrayWithObjects:@"post", nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveMileStoneNFK object:nil userInfo:userInfo];
}

#pragma mark - event notifications
+ (void)postEventFollowedNotificationWithEvent:(LCEvent*)event andResponse:(NSDictionary*)response
{
  event.isFollowing = YES;
  NSDictionary *dict= response[kResponseData];
  event.followerCount = dict[@"followerCount"];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, kEntityTypeEvent, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kFollowEventNFK object:nil userInfo:userInfo];
}

+ (void)postEventUnFollowedNotificationWithEvent:(LCEvent*)event andResponse:(NSDictionary*)response
{
  event.isFollowing = NO;
  NSDictionary *dict= response[kResponseData];
  event.followerCount = dict[@"followerCount"];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, kEntityTypeEvent, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUnfollowEventNFK object:nil userInfo:userInfo];
}


+ (void)postEventCreatedNotificationWithResponse:(NSDictionary*)response
{
  NSError *error = nil;
  LCEvent *event = [MTLJSONAdapter modelOfClass:[LCEvent class] fromJSONDictionary:response[kResponseData] error:&error];

  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kCreateEventNFK object:nil userInfo:userInfo];
}

+ (void)postEventDetailsUpdatedNotificationWithResponse:(NSDictionary*)response andEvent:(LCEvent*)event
{
  NSDictionary *dict= response[kResponseData];
  NSString *newHeaderPhoto = dict[@"headerPhoto"];
  event.headerPhoto = ([newHeaderPhoto isEqual:[NSNull null]] ? nil : newHeaderPhoto);
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, kEntityTypeEvent, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateEventNFK object:nil userInfo:userInfo];
}

+ (void)postEventDeletedNotification:(LCEvent*)event
{
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteEventNFK object:nil userInfo:userInfo];
}

+ (void)postEventRejectedNotification: (NSString *)eventID
{
  LCEvent *event = [[LCEvent alloc] init];
  event.eventID = eventID;
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:event, @"event", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kRejectEventRequestNFK object:nil userInfo:userInfo];
}

+ (void)postEventCommentedNotificationWithComment:(LCComment*)comment andEvent:(LCEvent*)event
{
  NSDictionary *userInfo = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:event,comment, nil] forKeys:[NSArray arrayWithObjects:kEntityTypeEvent,kPostCommentKey, nil]];
  [[NSNotificationCenter defaultCenter] postNotificationName:kCommentEventNFK object:nil userInfo:userInfo];
}

#pragma mark - userUpdate notifications

+ (void)postProfileUpdatedNotification :(LCUserDetail *)userDetails
{
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:userDetails, @"userDetail", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateProfileNFK object:nil userInfo:userInfo];
}

+ (void)postSendFriendRequestNotification :(NSString *)friendID forFriendStatus :(int)status
{
  LCFriend *friend = [[LCFriend alloc] init];
  friend.friendId = friendID;
  friend.isFriend = [NSString stringWithFormat:@"%d", status];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:friend, @"friend", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kSendFriendRequestNFK object:nil userInfo:userInfo];
}

+ (void)postCancelFriendRequestNotification :(NSString *)friendID forFriendStatus :(int)status
{
  LCFriend *friend = [[LCFriend alloc] init];
  friend.friendId = friendID;
  friend.isFriend = [NSString stringWithFormat:@"%d", status];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:friend, @"friend", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kCancelFriendRequestNFK object:nil userInfo:userInfo];
}

+ (void)postRemoveFriendNotification :(NSString *)friendID forFriendStatus :(int)status
{
  LCFriend *friend = [[LCFriend alloc] init];
  friend.friendId = friendID;
  friend.isFriend = [NSString stringWithFormat:@"%d", status];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:friend, @"friend", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kRemoveFriendNFK object:nil userInfo:userInfo];
}

+ (void)postAcceptFriendRequestNotification :(NSString *)friendID forFriendStatus :(int)status
{
  LCFriend *friend = [[LCFriend alloc] init];
  friend.friendId = friendID;
  friend.isFriend = [NSString stringWithFormat:@"%d", status];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:friend, @"friend", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kAcceptFriendRequestNFK object:nil userInfo:userInfo];
}

+ (void)postRejectFriendRequestNotification :(NSString *)friendID
{
  LCFriend *friend = [[LCFriend alloc] init];
  friend.friendId = friendID;
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:friend, @"friend", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kRejectFriendRequestNFK object:nil userInfo:userInfo];
}

+ (void)postNotificationCountUpdatedNotification
{
  [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationCountUpdated object:nil userInfo:nil];
}

+ (void)postInterestFollowedNotificationWithInterest:(LCInterest*)interest
{
  interest.isFollowing = YES;
  NSInteger followers = [interest.followers integerValue] + 1 ;
  interest.followers = [NSString stringWithFormat:@"%d", followers];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:interest, kInterestObj, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kFollowInterestNFK object:nil userInfo:userInfo];
}

+ (void)postInterestUnFollowedNotificationWithInterest:(LCInterest*)interest
{
  interest.isFollowing = NO;
  NSInteger followers = [interest.followers integerValue] - 1 ;
  interest.followers = [NSString stringWithFormat:@"%d", followers];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:interest, kInterestObj, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUnfollowInterestNFK object:nil userInfo:userInfo];
}

+ (void)postCauseFollowedNotificationWithCause:(LCCause *)cause
{
  cause.isSupporting = YES;
  cause.supporters = [NSString stringWithFormat:@"%d",[cause.supporters intValue]+1];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:cause, kCauseObj, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kSupportCauseNFK object:nil userInfo:userInfo];
}

+ (void)postCauseUnFollowedNotificationWithCause:(LCCause *)cause
{
  cause.isSupporting = NO;
  cause.supporters = [NSString stringWithFormat:@"%d",[cause.supporters intValue]-1];
  NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:cause, kCauseObj, nil];
  [[NSNotificationCenter defaultCenter] postNotificationName:kUnsupportCauseNFK object:nil userInfo:userInfo];
}


@end
