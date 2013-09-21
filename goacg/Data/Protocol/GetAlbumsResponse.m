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

+ (void)asyncRequest:(void (^)(GetAlbumsResponse* response))block
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
    }
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/active/get_albums"
              parameters:@{@"user_id":@"3", @"begin":@"0", @"end":@"1378734808"}
                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                     GetAlbumsResponse* ar = mappingResult.firstObject;
                     block(ar);
                 }
                 failure:^(RKObjectRequestOperation *operation, NSError *error) {
                     block(nil);
                 }];
}
@end
