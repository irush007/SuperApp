//
//  SettingsViewController.m
//  SuperLinkedin
//
//  Created by Eric Wu on 8/23/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    NSLog(@"hello");

    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone"
                                                         bundle:nil];
    LoginViewController *login =
    [storyboard instantiateViewControllerWithIdentifier:@"homePage"];
    
    [[[[UIApplication sharedApplication] delegate] window] setRootViewController:login];

//    [self presentViewController:login
//                       animated:YES
//                     completion:nil];
    
    NSLog(@"i am done");
}
@end
