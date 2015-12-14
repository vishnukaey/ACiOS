//
//  LCFeedAPIManager.h
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCFeedAPIManager : NSObject

+ (void)getHomeFeedsWithLastFeedId:(NSString*)lastId success:(void (^)(NSArray* response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getPostDetailsOfPost:(NSString*)postID WithSuccess:(void (^)(LCFeed* response))success andFailure:(void (^)(NSString *error))failure;

+ (void)likePost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)unlikePost:(LCFeed *)post withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;

+ (void)commentPost:(LCFeed *)post comment:(NSString*)comment withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)deleteCommentWithId:(NSString *)commentId withSuccess:(void (^)(id response))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCommentsForPost:(NSString*)postId lastCommentId:(NSString*)lastId withSuccess:(void (^)(id response, BOOL isMore))success andfailure:(void (^)(NSString *error))failure;

@end
