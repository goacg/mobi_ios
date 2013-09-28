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

- (NSArray*)queryPlaysInTimeRange:(NSDate*)timeBegin
                          timeEnd:(NSDate*)timeEnd
                         onUpdate:(void(^)(void))onUpdate;
@end
