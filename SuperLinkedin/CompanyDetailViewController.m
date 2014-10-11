//
//  CompanyDetailViewController.m
//  SuperLinkedin
//
//  Created by Eric Wu on 8/31/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "CompanyDetailViewController.h"
#import "UserClass.h"

@interface CompanyDetailViewController ()
@property (nonatomic, retain) UserClass *user_class;

@end

@implementation CompanyDetailViewController
@synthesize user_class = _user_class;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"i am here");
        // Custom initialization
        self.user_class = [UserClass getInstance];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self =[super initWithCoder:aDecoder];
    if (self) {
        NSLog(@"i am here 2");
        self.user_class = [UserClass getInstance];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString *url_str = [_company objectForKey:@"image_url"];
    self.companyImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url_str]]];
    
    self.companyNameLabel.text = [_company objectForKey:@"name"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)referMeButton:(id)sender {
    NSLog(@"refer me button tapped.");
    
    PFObject *application = [PFObject objectWithClassName:@"Apply"];
    
    PFObject *appUser = self.user_class.appUser;
    NSLog(@"This is user id: %@", [appUser objectId]);
    NSLog(@"This is user object: %@", appUser);
    
    PFObject *company = _company;
    NSLog(@"This is company id : %@", [company objectId]);
    NSLog(@"This is company object: %@", company);
    
    application[@"from"] = [PFObject objectWithoutDataWithClassName:@"AppUser" objectId:[appUser objectId]];
    application[@"company"] = [PFObject objectWithoutDataWithClassName:@"Company" objectId:[company objectId]];
    
    [application saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"succeedd....");
        }
    }];
    
    
    
//    [PFCloud callFunctionInBackground:@"referMainFunc" withParameters:@{@"user_id":[appUser objectId], @"company_id":[company objectId]} block:^(id object, NSError *error) {
//        // TODO
//        if (!error) {
//            NSLog(@"request sent successfully.");
//        }
//    }];
    
    
}

@end
