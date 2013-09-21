//
//  Album+RestKitMapping.h
//  test
//
//  Created by mp on 13-9-12.
//  Copyright (c) 2013年 mp. All rights reserved.
//

#import "Album.h"
@class RKObjectMapping;

@interface Album (RestKitMapping)
+ (RKObjectMapping*) mapping;
@end
