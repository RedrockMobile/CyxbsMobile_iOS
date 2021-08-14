//
//  DetailsgoodsTableViewCell.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsGoodsTableViewCell.h"

@interface DetailsGoodsTableViewCell ()

@end

@implementation DetailsGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.titleImgView.image = [UIImage imageNamed:@"details_isReceived"];
    self.rightTitleLabel.textColor = [UIColor colorNamed:@"75_102_240_1&*"];
}

#pragma mark - setter

- (void)setCellModel:(DetailsGoodsModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.goods_name;
    self.subtitleLabel.text = [self getTimeFromTimestamp: cellModel.date];
    self.rightTitleLabel.text = [NSString stringWithFormat:@"-%zd", cellModel.goods_price];
    self.titleImgHidden = cellModel.is_received;
}

@end
