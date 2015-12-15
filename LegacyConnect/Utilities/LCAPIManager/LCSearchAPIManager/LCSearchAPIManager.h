//
//  LCSearchAPIManager.h
//  LegacyConnect
//
//  Created by qbuser on 11/12/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCSearchAPIManager : NSObject

+ (void)searchForItem:(NSString*)searchItem withSuccess:(void (^)(LCSearchResult* searchResult))success andFailure:(void (^)(NSString *error))failure;
+ (void)searchUserUsingsearchKey:(NSString*)searchKey lastUserId:(NSString*)lastUserId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure;
+ (void)getUserInterestsAndCausesWithSearchKey: (NSString *)searchKey withSuccess:(void (^)(NSArray* responses))success andFailure:(void (^)(NSString *error))failure;
+ (void)getCauseSearchResultsWithSearchKey:(NSString*)searchText withFastId:(NSString*)lastId success:(void (^)(id response))success
                                andfailure:(void (^)(NSString *error))failure;
+ (void)getInterestsSearchResultsWithSearchKey:(NSString*)searchText withFastId:(NSString*)lastId success:(void (^)(id response))success
                                    andfailure:(void (^)(NSString *error))failure;

+ (void)searchCausesWithInterestForSearchText:(NSString*)searchkey lastId:(NSString*)lastId withSuccess:(void (^)(id response))success andfailure:(void (^)(NSString *error))failure;

@end
