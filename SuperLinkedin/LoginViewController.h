//
//  LoginViewController.h
//  SuperLinkedin
//
//  Created by Hua Wu on 7/28/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property(copy, nonatomic) NSString *apiUrl;
@property(copy, nonatomic) NSString *libUrl;
@property(copy, nonatomic) NSString *base_url;
@property(copy, nonatomic) NSString *auth_url;
@property(copy, nonatomic) NSString *info_url;
@property(copy, nonatomic) NSString *access_tkn;


@property (weak, nonatomic) IBOutlet UIButton *signInButton;

- (IBAction)didTapSignInLinkedin:(id)sender;
@end
