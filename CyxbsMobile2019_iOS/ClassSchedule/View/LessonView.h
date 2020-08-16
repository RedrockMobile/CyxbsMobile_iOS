//
//  LessonView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LessonView : UIView
/// 这节课的信息字典
@property(nonatomic,strong)NSDictionary *courseDataDict;

/// 通过信息字典初始化这个类
/// @param dataDict 这节课的信息字典
- (instancetype)initWithDataDict:(NSDictionary*)courseDataDict;
@end

NS_ASSUME_NONNULL_END
