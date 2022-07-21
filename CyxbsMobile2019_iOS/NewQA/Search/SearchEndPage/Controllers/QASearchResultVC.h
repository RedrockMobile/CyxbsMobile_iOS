//
//  QASearchResultVC.h
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 这是搜索结果页面的VC
 
 一 界面构成
 1.最底部一个ScrollView：VerticalScroll。负责整个界面的上下滑动
 2.Vertical上的界面：
        2.1:一个上半部分的View：TopViw。其上层容纳：顶部一个搜索的Bar，一个知识库页面，一个显示底部table在哪边的小白块
        2.2:一个左右滑动的Scroll：horizontalScrollScroll,其上两个table，分别呈现搜索的动态，用户的两个table
 
 */
@interface QASearchResultVC : UIViewController
/// 重邮知识库的内容数组
@property (nonatomic, strong) NSArray *knowlegeAry;

/// 搜索的文字
@property (nonatomic, copy) NSString *searchStr;
@end

NS_ASSUME_NONNULL_END
