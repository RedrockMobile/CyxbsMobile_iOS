//
//  DynamicDetailViewModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/15.
//  Copyright © 2021 Redrock. All rights reserved.
//
#define Pading SCREEN_WIDTH*0.0427
#define Margin 7
#define item_num 3
#import "DynamicDetailViewModel.h"

@implementation DynamicDetailViewModel

/// 防止没找到值而崩溃
- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key{
    
}
- (CGFloat)getModelHeight{
    //固定高度
        //内容框顶部到cell顶部的高度
    CGFloat height1 = 70.5 * HScaleRate_SE;
        //内容框底部到cell底部的高度  内容框底部到标签btn的距离 + 标签btn的height + 到cell底部的距离
//    CGFloat height2 = 12.5*HScaleRate_SE + (SCREEN_WIDTH * 0.2707 * 25.5/101.5) + ( (69 + 25)*HScaleRate_SE + 18 * fontSizeScaleRate_SE);
    CGFloat height2 = (12.5 + 25 + 88 + 17) * fontSizeScaleRate_SE;
    //动态高度
        //内容label的高度
    CGFloat height3 = 0;
    CGFloat preferredMaxLayoutWidth = MAIN_SCREEN_W - Pading * 2;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:PingFangSCRegular size:15]};
    CGSize detaileLblSize = [self.content boundingRectWithSize:CGSizeMake(preferredMaxLayoutWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    height3 = detaileLblSize.height;
    
        //图片的collectionView的高度
    CGFloat height4 = 0;
    if (self.pics > 0) {
        //内容框底部到collectionView的高度 + collectionView的高度
        height4 = 11.5*HScaleRate_SE + (self.pics.count-1)/3 * 10*HScaleRate_SE + ((self.pics.count-1)/3 + 1)* (SCREEN_WIDTH-(2 * Margin + Pading * 2))/item_num;
    }
    
//    self.cellHeight = height1 + height2 + height3 + height4;
    return height1 + height2 + height3 + height4 + 10;
}
@end
