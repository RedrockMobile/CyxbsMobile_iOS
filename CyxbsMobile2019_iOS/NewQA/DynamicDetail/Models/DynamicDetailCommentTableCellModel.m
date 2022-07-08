//
//  DynamicDetailCommentTableCellModel.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DynamicDetailCommentTableCellModel.h"

#define Pading SCREEN_WIDTH*0.0427
#define Margin 7
#define item_num 3

@implementation DynamicDetailCommentTableCellModel

///重写小码哥中的方法
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"reply_list":[self class]
    };
}

//防止KVC找不到值而崩溃
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (CGFloat)getCellHeight{
    //固定高度
        //头像框到顶部的距离 + 内容框到头像框的距离
    CGFloat height1 = 27 * HScaleRate_SE;
    //动态高度
        //头像框的高度
    CGFloat height2 = 0;
    if (self.reply_list.count == 0) {
        height2 = 30 * WScaleRate_SE;
    }else{
        height2 = 22 * WScaleRate_SE;
    }
    
        //内容label的高度
    CGFloat height3 = 0;
    CGFloat preferredMaxLayoutWidth = self.reply_list.count == 0 ? (MAIN_SCREEN_W - 100*WScaleRate_SE) : (MAIN_SCREEN_W - 130*WScaleRate_SE);
    NSDictionary *attr = @{NSFontAttributeName:[UIFont fontWithName:PingFangSCMedium size:15]};
    CGSize detaileLblSize = [self.content boundingRectWithSize:CGSizeMake(preferredMaxLayoutWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size;
    height3 = detaileLblSize.height + 3*HScaleRate_SE;
    
        //图片的collectionView的高度 + 到底部的距离一级评论才有，二级无
    CGFloat height4 = 0;
//    if (self.reply_list.count == 0) {
        if (self.pics > 0) {
            //内容框底部到collectionView的高度 + collectionView的高度
            height4 = (11.5*HScaleRate_SE + (self.pics.count-1)/3 * 10*HScaleRate_SE + ((self.pics.count-1)/3 + 1)* (SCREEN_WIDTH-(2 * Margin + Pading * 2))/item_num) + 10*HScaleRate_SE ;
        }
//    }
        //最后的5是容错处理 10是发布时间距离昵称的高度
    return height1 + height2 + height3 + height4 + 5*HScaleRate_SE + 10;
}
@end
