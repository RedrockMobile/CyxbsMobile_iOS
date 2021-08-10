//
//  DetailsCommodityTableViewCell.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsCommodityTableViewCell.h"

@interface DetailsCommodityTableViewCell ()

@end

@implementation DetailsCommodityTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.titleImgView.image = [UIImage imageNamed:@"details_isCollected"];
    self.rightTitleLabel.textColor = [UIColor colorNamed:@"75_102_240_1"];
}

#pragma mark - setter

- (void)setCellModel:(DetailsCommodityModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.commodity_name;
    self.subtitleLabel.text = cellModel.date;
    self.rightTitleLabel.text = [NSString stringWithFormat:@"-%zd", cellModel.price];
    self.titleImgHidden = cellModel.isCollected;
}

@end
