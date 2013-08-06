//
//  KMInstagramSettings.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMInstagramSettings : NSObject

+ (NSString *)clientId;
+ (NSString *)callbackUrl;
+ (NSArray *)scopes;

@end
