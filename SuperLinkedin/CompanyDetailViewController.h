//
//  CompanyDetailViewController.h
//  SuperLinkedin
//
//  Created by Eric Wu on 8/31/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CompanyDetailViewController : UIViewController
@property (weak, nonatomic) PFObject *company;
@property (weak, nonatomic) IBOutlet UIImageView *companyImage;
@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *industryLabel;
@property (weak, nonatomic) IBOutlet UILabel *companySizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyIntroLabel;
- (IBAction)referMeButton:(id)sender;

@end
