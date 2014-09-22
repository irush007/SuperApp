//
//  UserClass.h
//  SuperLinkedin
//
//  Created by Eric Wu on 9/3/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserClass : NSObject {
    PFObject *appUser;
}

@property (nonatomic, retain) PFObject *appUser;
+(UserClass *)getInstance;
@end
