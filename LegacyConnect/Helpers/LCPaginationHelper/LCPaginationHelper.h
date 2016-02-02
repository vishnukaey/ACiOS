//
//  LCPaginationHelper.h
//  LegacyConnect
//
//  Created by qbuser on 02/02/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCPaginationHelper : NSObject

+ (UIView*)getNoResultViewWithText:(NSString*)text;
+ (UIView*)getSearchNoResultViewWithText:(NSString*)text;
+ (UITableViewCell*)getNextPageLoaderCell;
+ (UITableViewCell*)getEmptyIndicationCellWithText:(NSString*)text;

@end
