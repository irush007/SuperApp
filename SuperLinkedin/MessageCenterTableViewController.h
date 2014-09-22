//
//  MessageCenterTableViewController.h
//  SuperLinkedin
//
//  Created by Eric Wu on 8/31/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MessageCenterTableViewController : PFQueryTableViewController

@property (nonatomic, retain) NSMutableArray *dataArray;

@end
