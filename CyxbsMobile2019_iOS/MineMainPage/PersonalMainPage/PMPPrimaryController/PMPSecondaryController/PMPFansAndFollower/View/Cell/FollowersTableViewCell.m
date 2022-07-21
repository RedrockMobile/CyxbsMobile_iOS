//
//  FollowersTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FollowersTableViewCell.h"

@implementation FollowersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.followBtn.hidden = YES;
    }
    return self;
}

#pragma mark - setter

- (void)setCellModel:(FansAndFollowersModel *)cellModel {
    _cellModel = cellModel;
    self.nameLabel.text = cellModel.nickname;
    self.bioLabel.text = cellModel.introduction;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.avatar]];
}

@end
