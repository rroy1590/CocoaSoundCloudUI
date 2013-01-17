//
//  NSDictionary+SoundCloudUI.m
//  SoundCloudUI
//
//  Created by r/o/b on 1/11/13.
//  Copyright (c) 2013  SoundCloud Ltd. All rights reserved.
//

#import "NSDictionary+SoundCloudUI.h"

@implementation NSDictionary (SoundCloudUI)

- (id)objectForKeyOrNil:(id)aKey
{
    id object = [self objectForKey:aKey];
    if ([object isEqual:[NSNull null]]) {
        return nil;
    }

    return object;
}

@end
