//
//  SportAttendanceTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2022/8/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SportAttendanceItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface SportAttendanceTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dateLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *spotLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *valiLab;
@property (nonatomic, strong) UIImageView *awardImgView;
@property (nonatomic, assign) bool is_award;
@property (nonatomic, assign) bool valid;
/// Item数据模型
@property (nonatomic, strong) SportAttendanceItem *sa;

@end

NS_ASSUME_NONNULL_END
