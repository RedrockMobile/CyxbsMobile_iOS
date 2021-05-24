//
//  DynamicSpecificCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicDetailViewModel.h"
#import "FunctionBtn.h"
NS_ASSUME_NONNULL_BEGIN
@class DynamicSpecificCell;
@protocol DynamicSpecificCellDelegate <NSObject>
/// 点击多功能按钮
- (void)clickedFuncBtn:(UIButton *)btn;

///点击点赞按钮
- (void)clickedStarBtn:(FunctionBtn *)btn;

///点击评论按钮，直接添加一级评论
- (void)clickedCommentBtn;

///点击分享按钮
- (void)clickedShareBtn:(FunctionBtn *)btn;

///点击标签，跳转到对应的圈子界面
//- (void)clickedGroupTopicBtn:(UIButton *)btn;

@end
/**
 *概述：
 *1. 动态详情页中展示动态的具体信息的view，是对新版邮问主页推荐列表的自定义cell的一个优化
 *2.本页主要对 DynamicDetailViewModel 的数据进行处理并显示
 *
 * 构成思路：
 *
 *1.需要点击触碰等事件一律通过协议让controller处理
 *
 *2.图片排列使用UIImageView装载，利用九宫格方式动态创建UIImageView的数量。不使用collectionView可以减少很多工作量
 *
 *3.图片浏览功能利用第三方库 YBImageBrowser 实现。图片的imageView的tag值为图片url在modelpic数组中的位置，图片浏览器当前展示的图片就是点击的imageView的tag值序列
 *
 */
@interface DynamicSpecificCell : UIView
///评论∫
@property (nonatomic, strong) FunctionBtn *commendBtn;



/// 拥有动态的具体信息的数据model
@property (nonatomic, strong) DynamicDetailViewModel *dynamicDataModel;

@property (nonatomic, weak) id <DynamicSpecificCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
