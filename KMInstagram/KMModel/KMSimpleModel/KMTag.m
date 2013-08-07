//
//  KMTag.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMTag.h"

@implementation KMTag

- (id)initWithString:(NSString *)tagName
{
    if (self = [super init]) {
        _tagName = tagName;
    }
    return self;
}

@end
