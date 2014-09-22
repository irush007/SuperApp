//
//  UserClass.m
//  SuperLinkedin
//
//  Created by Eric Wu on 9/3/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "UserClass.h"
#import <Parse/Parse.h>

@implementation UserClass
@synthesize appUser;

static UserClass *instance = nil;

+(UserClass *)getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
        {
            instance = [UserClass new];
        }
    }
    return instance;
}

@end



