//
//  SchoolLessonItem.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/3.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *SchoolLessonItemReuseIdentifier;

#pragma mark - ENUM (ClassBookItemDraw)

typedef NS_ENUM(NSUInteger, ClassBookItemDraw) {
    
    /// 上午
    ClassBookItemDrawMorning = 0,
    
    /// 下午
    ClassBookItemDrawAfternoon,
    
    /// 晚上
    ClassBookItemDrawNight,
    
    /// 别人的
    ClassBookItemDrawMulty,
    
    /// 自定义
    ClassBookItemDrawCustom
};


#pragma mark - SchoolLessonItem

@interface SchoolLessonItem : UICollectionViewCell

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

/// 绘制类型
@property (nonatomic) ClassBookItemDraw draw;

/// 空样式
- (void)emptyWithAdd;

/// 绘制课程
/// @param courseName 有课程时绘制
/// @param classRoom 地点绘制
/// @param isMulty 多人绘制
- (void)course:(NSString *)courseName classRoom:(NSString *)classRoom isMulty:(BOOL)isMulty;

@end

NS_ASSUME_NONNULL_END
