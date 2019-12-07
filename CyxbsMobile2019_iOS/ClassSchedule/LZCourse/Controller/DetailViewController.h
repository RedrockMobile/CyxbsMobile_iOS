//
//  DetailViewController.h
//  Demo
//
//  Created by 李展 on 2016/11/30.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LessonBtnModel;
@interface DetailViewController : BaseViewController
- (instancetype)initWithMatters:(LessonBtnModel *)matters week:(NSInteger)week;
- (void)reloadMatters:(LessonBtnModel *)matters;
@end
