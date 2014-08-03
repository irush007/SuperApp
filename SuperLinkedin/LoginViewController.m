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
#import "HomePageViewController.h"

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
    
    _info_url = @"/v1/people/~:(id,first-name,last-name,maiden-name,formatted-name,location:(name),positions:(title,company:(id,name)),educations:(school-name,field-of-study,start-date,end-date,degree,activities))";
    
    _firstTimeRun = YES;
    NSLog(@"count times");
}



- (void)didReceiveMemoryWarning
{    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:_libUrl                                                                                    clientId:CLIENT_ID
                                                                                clientSecret:CLIENT_SECRET
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_fullprofile", @"r_network"]];
    
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}

- (IBAction)didTapSignInLinkedin:(id)sender {
    [self.client getAuthorizationCode:^(NSString *code) {
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
    
    
    //NSLog(@"This is authtoken: %@", accessToken);
    
    [self.client GET:[NSString stringWithFormat:auth_link, accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}
@end
