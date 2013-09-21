//
//  DataManager.h
//  test
//
//  Created by mp on 13-9-7.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (DataManager*) sharedInstance;

- (void)asyncQueryPlaysInTimeRange:(NSDate*)afterTime
                        beforeTime:(NSDate*)beforeTime
                        onComplete:(void(^)(NSArray*))onComplete
                            onFail:(void(^)(void))onFail;
@end
