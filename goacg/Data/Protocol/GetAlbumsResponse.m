//
//  GetAlbumsResponse.m
//  test
//
//  Created by mp on 13-9-12.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import "GetAlbumsResponse.h"
#import "Album+RestKitMapping.h"
#import <RestKit/RestKit.h>

@implementation GetAlbumsResponse
+ (RKObjectMapping*) mapping
{
    RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[self class]];
    [mapping addAttributeMappingsFromArray:@[@"error_code"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"albums" mapping:[Album mapping]];
    return mapping;
}

+ (void)asyncRequest:(NSString*)userId
           beginTime:(NSDate*)beginTime
             endTime:(NSDate*)endTime
               block:(void (^)(GetAlbumsResponse* response))block
{
    static bool s_desc_done = false;
    if ( !s_desc_done )
    {
        s_desc_done = true;
        RKResponseDescriptor* rd = [RKResponseDescriptor responseDescriptorWithMapping:[GetAlbumsResponse mapping]
                                                                                method:RKRequestMethodGET
                                                                           pathPattern:@"/active/get_albums"
                                                                               keyPath:nil
                                                                           statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
        
        [[RKObjectManager sharedManager] addResponseDescriptor:rd];
        
        //!FIXME: 没办法确定缓存中的Album对象是否已经在服务器端删除
        /*
        [[RKObjectManager sharedManager] addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
            if ( [URL.relativePath isEqualToString:@"/active/get_albums"] )
            {
                NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
                fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES] ];
                return fetchRequest;
            }
            
            return nil;
        }];
        */
        
        [[RKObjectManager sharedManager] addFetchRequestBlock:^NSFetchRequest *(NSURL *URL) {
            RKPathMatcher *pathMatcher = [RKPathMatcher pathMatcherWithPattern:@"/active/get_albums"];
            
            NSDictionary *argsDict = nil;
            BOOL match = [pathMatcher matchesPath:[URL relativeString] tokenizeQueryStrings:YES parsedArguments:&argsDict];

            if (match) {
                NSString* begin = [argsDict objectForKey:@"begin"];
                NSString* end   = [argsDict objectForKey:@"end"];
                
                NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Play"];
                fetchRequest.predicate = [NSPredicate predicateWithFormat:@"show_time>=%d and show_time <%d", [begin intValue], [end intValue]];
                fetchRequest.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"play_id" ascending:YES] ];
                return fetchRequest;
            }
            
            return nil;
        }];
    }
    
    NSString* strTimeBegin = [[NSNumber numberWithDouble:[beginTime timeIntervalSince1970]] stringValue];
    NSString* strTimeEnd   = [[NSNumber numberWithDouble:[endTime timeIntervalSince1970]] stringValue];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/active/get_albums"
              parameters:@{@"user_id":userId, @"begin":strTimeBegin, @"end":strTimeEnd}
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     GetAlbumsResponse* ar = mappingResult.firstObject;
                     block(ar);
                 }
                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     block(nil);
                 }];
}
@end
