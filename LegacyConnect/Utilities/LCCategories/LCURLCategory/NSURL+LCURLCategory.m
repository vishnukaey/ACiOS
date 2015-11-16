//
//  NSURL+LCURLCategory.m
//  LegacyConnect
//
//  Created by qbuser on 13/11/15.
//  Copyright © 2015 Gist. All rights reserved.
//

#import "NSURL+LCURLCategory.h"

@implementation NSURL (LCURLCategory)

+ (NSURL *)HTTPURLFromString:(NSString *)string
{
  NSURL *myURL;
  if ([string.lowercaseString hasPrefix:@"http://"] || [string.lowercaseString hasPrefix:@"https://"]) {
    myURL = [NSURL URLWithString:string];
  } else {
    myURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",string]];
  }
  return myURL;
}

@end
