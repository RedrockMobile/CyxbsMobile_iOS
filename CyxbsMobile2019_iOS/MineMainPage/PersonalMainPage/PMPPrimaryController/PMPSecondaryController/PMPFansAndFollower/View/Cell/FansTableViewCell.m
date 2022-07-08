//
//  FansTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/9/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FansTableViewCell.h"

@implementation FansTableViewCell

#pragma mark - setter

- (void)setCellModel:(FansAndFollowersModel *)cellModel {
    _cellModel = cellModel;
    self.nameLabel.text = cellModel.nickname;
    self.bioLabel.text = cellModel.introduction;
    [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:cellModel.avatar]];
    self.followBtn.selected = cellModel.is_focus;
}


@end
