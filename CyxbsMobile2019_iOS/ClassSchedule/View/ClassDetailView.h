//
//  ClassDetailView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassDetailView : UIView

/// 显示一节课详情的view
/// @param dataDict 一节课的信息
- (instancetype)initWithLessonDataDict:(NSDictionary*)dataDict;

/// 该节课的信息字典，暂时好像只有存信息的功能，先存着吧，以后或许有用。
/// 重写了setDataDict:，给dataDict赋值就可以自动完成对内部label文字的设置
@property(nonatomic, strong)NSDictionary *dataDict;
@end

NS_ASSUME_NONNULL_END
