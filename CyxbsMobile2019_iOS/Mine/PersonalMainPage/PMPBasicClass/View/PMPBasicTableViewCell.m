//
//  PMPBasicTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPBasicTableViewCell.h"

@implementation PMPBasicTableViewCell

+ (NSString *)reuseIdentifier
{
    return NSStringFromClass([self class]);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self basic_configView];
    }
    return self;
}

- (void)basic_configView
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


@end
