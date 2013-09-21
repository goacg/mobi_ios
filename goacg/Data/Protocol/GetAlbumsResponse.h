//
//  GetAlbumsResponse.h
//  test
//
//  Created by mp on 13-9-12.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RKObjectMapping;

@interface GetAlbumsResponse : NSObject
+ (RKObjectMapping*) mapping;
+ (void)asyncRequest:(void (^)(GetAlbumsResponse* response))block;

@property (nonatomic, retain) NSNumber * error_code;
@property (nonatomic, retain) NSArray  * albums;

@end
