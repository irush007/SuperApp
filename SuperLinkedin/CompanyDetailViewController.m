//
//  CompanyDetailViewController.m
//  SuperLinkedin
//
//  Created by Eric Wu on 8/31/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "CompanyDetailViewController.h"

@interface CompanyDetailViewController ()

@end

@implementation CompanyDetailViewController

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
}
@end
