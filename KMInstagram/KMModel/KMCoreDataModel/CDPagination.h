//
//  CDPagination.h
//  KMInstagram
//
//  Created by Kanybek Momukeev on 8/7/13.
//  Copyright (c) 2013 Kanybek Momukeev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CDEditingProtocol.h"

@interface CDPagination : NSManagedObject<CDEditingProtocol>

@property (nonatomic, retain) NSString * nextUrl;
@property (nonatomic, retain) NSString * next_max_id;

@end
