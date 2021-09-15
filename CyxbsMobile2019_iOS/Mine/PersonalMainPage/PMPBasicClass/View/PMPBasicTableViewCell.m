//
//  IPXBaseTableViewCell.m
//  GUBaseLib
//
//  Created by Edioth on 22/12/2017.
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
