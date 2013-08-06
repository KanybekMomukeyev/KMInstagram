//
//  KMInstagramRequestClient.m
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/6/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import "KMInstagramRequestClient.h"
#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"

static NSString* const kInstagramApiUrl = @"https://api.instagram.com/v1/";


@implementation KMInstagramRequestClient

+ (KMInstagramRequestClient *)sharedClient {
    static  KMInstagramRequestClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[KMInstagramRequestClient alloc] initWithBaseURL:[NSURL URLWithString:kInstagramApiUrl]];
    });
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

@end
