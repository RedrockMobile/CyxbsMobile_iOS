//
//  DetailsTaskTableViewCell.m
//  Details
//
//  Created by Edioth Jin on 2021/8/6.
//

#import "DetailsTaskTableViewCell.h"

@implementation DetailsTaskTableViewCell

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.rightTitleLabel.textColor = [UIColor colorNamed:@"255_169_47_1&*"];
    self.rightIndicatorHidden = YES;
    self.titleImgHidden = YES;
}

#pragma mark - setter

- (void)setCellModel:(DetailsTaskModel *)cellModel {
    _cellModel = cellModel;
    self.titleLabel.text = cellModel.task_name;
    self.subtitleLabel.text = [self getTimeFromTimestamp:cellModel.date];
    self.rightTitleLabel.text = [NSString stringWithFormat:@"+%zd", cellModel.task_income];
}

@end
