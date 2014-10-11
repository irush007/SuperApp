//
//  LoginViewController.m
//  SuperLinkedin
//
//  Created by Hua Wu on 7/28/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "LoginViewController.h"
#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"
#import "Config.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "HomePageTableViewController.h"
#import "SWRevealViewController.h"
#import "UserClass.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    LIALinkedInHttpClient *_client;
    BOOL _firstTimeRun;

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_firstTimeRun == NO) {
        [self performSegueWithIdentifier:@"login_success" sender:self];
    }
    else {
        NSLog(@"abcd");
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _client = [self client];
    _base_url = @"https://api.linkedin.com";
    _apiUrl = @"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json";
    
    _auth_url = @"/v1/people/~?oauth2_access_token=%@&format=json";
    
    _access_tkn = @"?oauth2_access_token=%@&format=json";
    
    _libUrl = @"http://www.ancientprogramming.com/liaexample";
    
    _info_url = @"/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,location:(name),positions:(title,company:(id,name),is-current,start-date,end-date),educations:(school-name,field-of-study,start-date,end-date,degree,activities),email-address,picture-url)";
    
    _firstTimeRun = YES;
    
    _signInButton.layer.cornerRadius = 5;
}



- (void)didReceiveMemoryWarning
{    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"checking");
    if ([[segue identifier] isEqualToString:@"login_success"]) {
        NSLog(@"Preparing segue.");
        SWRevealViewController *destination = [segue destinationViewController];
        UINavigationController *navViewController = (UINavigationController *) [destination frontViewController];
        HomePageTableViewController *destViewController = (HomePageTableViewController* )[navViewController topViewController];
    }
}


- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:_libUrl                                                                                    clientId:CLIENT_ID
                                                                                clientSecret:CLIENT_SECRET
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_fullprofile", @"r_network",@"r_emailaddress"]];
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

- (IBAction)didTapSignInLinkedin:(id)sender {
    NSLog(@"tap sign in");
    [self.client getAuthorizationCode:^(NSString *code) {
        NSLog(@"getting token");
        _firstTimeRun = NO;
        [_signInButton setHidden:TRUE];
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        } failure:^(NSError *error) {
            NSLog(@"Querying accessToken failed %@", error);
        }];
    } cancel:^{
        NSLog(@"Authorization was cancelled by user");
    } failure:^(NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
    
}

- (void)requestMeWithToken:(NSString *)accessToken {
    NSString *auth_link = [[_base_url stringByAppendingString:_info_url] stringByAppendingString:_access_tkn];
    
    [self.client GET:[NSString stringWithFormat:auth_link, accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        
        
        NSDictionary *education = result[@"educations"];
        NSMutableArray *schools = [[NSMutableArray alloc] init];
        for (id object in education[@"values"]) {
            [schools addObject:object[@"schoolName"]];
        }
        
        NSString *company_title;
        NSString *company_name;
        int company_id;
        
        NSDictionary *position = result[@"positions"];
        NSMutableArray *companyList = [[NSMutableArray alloc] init];
        
        for (id object in position[@"values"]) {
            if ([object[@"isCurrent"] intValue] == 1) {
                company_id = [object[@"company"][@"id"] intValue];
                company_name = object[@"company"][@"name"];
                company_title = object[@"title"];
            }
            
            if (object[@"company"][@"id"] != nil) {
                [companyList addObject:object[@"company"][@"id"]];
            }
        }
        
        NSDictionary *appUser = [[NSDictionary alloc] initWithObjectsAndKeys:result[@"id"],@"linkedinId",result[@"firstName"],@"firstName",result[@"lastName"],@"lastName",result[@"formattedName"],@"formattedName",result[@"location"][@"name"],@"location",schools,@"education",company_title,@"title",companyList,@"companyList",result[@"emailAddress"],@"email_address",result[@"pictureUrl"],@"picture_url",nil];
        
        NSDictionary *company = [[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithInt:company_id],@"company_id",company_name,@"company_name",nil];
        
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        if (![[currentInstallation objectForKey:@"channels"] containsObject:company_name]) {
            [currentInstallation addUniqueObject:company_name forKey:@"channels"];
            [currentInstallation saveInBackground];
        }
        
        [PFCloud callFunctionInBackground:@"verifyUser" withParameters:@{@"userInfo":appUser, @"company_info":company,@"access_token":accessToken} block:^(id object, NSError *error) {
            // TODO
            if (!error) {
                NSLog(@"Save user successfully.");
                UserClass *single_obj = [UserClass getInstance];
                single_obj.appUser = (PFObject *)object;
            }
        }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}
@end
