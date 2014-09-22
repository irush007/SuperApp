//
//  RequestTableViewCell.h
//  SuperLinkedin
//
//  Created by Eric Wu on 9/14/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *requestLabel;

@property (weak, nonatomic) IBOutlet UIImageView *deleteButtonImageView;
@end
