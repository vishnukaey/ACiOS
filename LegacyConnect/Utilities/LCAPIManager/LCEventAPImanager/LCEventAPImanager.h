//
//  LCEventAPImanager.h
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCEventAPImanager : NSObject

+ (void)createEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)updateEvent:(LCEvent*)event havingHeaderPhoto:(UIImage*)headerPhoto andImageStatus:(bool)status withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getEventDetailsForEventWithID:(NSString*)eventID withSuccess:(void (^)(LCEvent* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)deleteEvent:(LCEvent *)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

+ (void)addUsersWithUserIDs:(NSArray*)userIDs forEventWithEventID:(NSString*)eventID withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getMembersForEventID:(NSString*)eventID pageNumber:(NSString*)page andLastEventID:(NSString*)lastEventID withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getMemberFriendsForEventID:(NSString*)eventID searchKey:(NSString*)searchKey pageNumber:(NSString*)page lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure;
+ (void)getListOfEventsForInterestID:(NSString*)InterestID lastID:(NSString*)lastID withSuccess:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;

+ (void)followEvent:(LCEvent*)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unfollowEvent:(LCEvent*)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

+ (void)getCommentsForEvent:(NSString*)eventID lastCommentID:(NSString*)lastID withSuccess:(void (^)(id response, BOOL isMore))success andfailure:(void (^)(NSString *error))failure;
+ (void)postCommentToEvent:(LCEvent *)event comment:(NSString*)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)deleteCommentFromAction:(LCEvent *)action withComment:(LCComment *)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)blockEventWithEvent:(LCEvent*)event withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

@end
