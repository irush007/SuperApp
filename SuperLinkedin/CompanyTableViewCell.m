//
//  CompanyTableViewCell.m
//  SuperLinkedin
//
//  Created by Hua Wu on 7/31/14.
//  Copyright (c) 2014 ej. All rights reserved.
//

#import "CompanyTableViewCell.h"

@implementation CompanyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// set horizontal margin for cells
- (void)setFrame:(CGRect)frame {
    frame.origin.x += 5;
    frame.size.width -= 2 * 5;
    [super setFrame:frame];
}

@end
