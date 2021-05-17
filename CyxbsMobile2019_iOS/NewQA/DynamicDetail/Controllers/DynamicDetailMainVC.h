//
//  DynamicDetailMainVC.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/4/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 概述：这是动态详情的主页
 
 构成：由顶部的tobBar和一个Table构成
 
 table构成：
 
 1.table的headerView为动态详情，table主体则是评论
 
 2.table分区，每一个区的第0行为一级评论，其他行则为2级评论或者评论回复。cell构成思路看自定义cell的.h文件
 
 3.利用mj_refertion进行table刷新
 
 4.根据进入后，请求得到数据后判定是否有评论。
    有评论时：动态信息View作为评论table的headerView
    无评论时，动态信息View和底部无图片的View添加在一个scrollView上，这个Scrollview的ContentSize根据动态信息多少动态设置
 */
@interface DynamicDetailMainVC : UIViewController
/// 动态的post_id
@property (nonatomic, copy) NSString *post_id;
@end

NS_ASSUME_NONNULL_END
