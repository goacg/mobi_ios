//
//  DataManager.m
//  test
//
//  Created by mp on 13-9-7.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import "DataManager.h"
#import "GetAlbumsResponse.h"
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>

@interface DataManager()
@property(nonatomic, strong) NSDate* cacheBegin;
@property(nonatomic, strong) NSDate* cacheEnd;
@end

@implementation DataManager

static DataManager* s_sharedInstance = nil;

- (id) init
{
    if ( self = [super init] )
    {
        s_sharedInstance = self;
        
        NSDateComponents* today_comps = [[NSCalendar currentCalendar] components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
        NSDate* today = [[NSCalendar currentCalendar] dateFromComponents:today_comps];
        _cacheBegin = _cacheEnd = today;
    }
    
    return self;
}

+ (DataManager*) sharedInstance
{
    return s_sharedInstance;
}

- (void)touchCacheData:(NSDate*)timeBegin
            beforeTime:(NSDate*)timeEnd
              onUpdate:(void(^)(void))onUpdate
{
    NSAssert( [timeBegin timeIntervalSinceDate:timeEnd] < 0, @"time range invalid" );
    
    if ( [timeBegin timeIntervalSinceDate:self.cacheBegin] >= 0 &&
         [timeEnd timeIntervalSinceDate:self.cacheEnd] <= 0 )
        
    {
        return;
    }
    
    NSDate* requestBegin = timeBegin;
    NSDate* requestEnd = timeEnd;
    
    NSTimeInterval secs = [requestEnd timeIntervalSinceDate:requestBegin];
    if ( secs < 30 * 24 * 3600 )
    {
        requestBegin = [requestBegin dateByAddingTimeInterval: (secs - 30 * 24 * 3600) / 2];
        requestEnd   = [requestEnd   dateByAddingTimeInterval: (- secs + 30 * 24 * 3600) / 2];
    }
    
    
    if ( [requestBegin timeIntervalSinceDate:self.cacheBegin] >= 0 &&
         [requestBegin timeIntervalSinceDate:self.cacheEnd] <= 0 )
    {
        requestBegin = self.cacheEnd;
    }
    
    if ( [requestEnd timeIntervalSinceDate:self.cacheBegin] >= 0 &&
         [requestEnd timeIntervalSinceDate:self.cacheEnd] <= 0 )
    {
        requestEnd = self.cacheBegin;
    }
    
    NSAssert( [requestEnd timeIntervalSinceDate:requestBegin] > 0, @"request time range invalid" );

    if ( [requestBegin timeIntervalSinceDate:self.cacheBegin] < 0 )
    {
        self.cacheBegin = requestBegin;
    }
    if ( [requestEnd timeIntervalSinceDate:self.cacheEnd] > 0 )
    {
        self.cacheEnd = requestEnd;
    }
    
    [GetAlbumsResponse asyncRequest:@"3" beginTime:requestBegin endTime:requestEnd block:^(GetAlbumsResponse *response) {
        onUpdate();
    }];
}

- (NSArray*)queryPlaysInTimeRange:(NSDate*)timeBegin
                          timeEnd:(NSDate*)timeEnd
                         onUpdate:(void(^)(void))onUpdate
{
    [self touchCacheData:timeBegin beforeTime:timeEnd onUpdate:onUpdate];
    
    NSManagedObjectContext *moc = [[[RKObjectManager sharedManager] managedObjectStore] mainQueueManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Play" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(show_time >= %d) AND (show_time < %d)", (int)[timeBegin timeIntervalSince1970], (int)[timeEnd timeIntervalSince1970] ];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"show_time" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    return array;
}

@end
