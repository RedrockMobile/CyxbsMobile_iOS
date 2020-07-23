//
//  HistoryView.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 该View接受一个数组，将数组中的所有数据以一个一个Item的形式展示出来，自动换行
@interface HistoryView : UIView
@property (nonatomic, strong) NSMutableArray *dataArray;

/// 请设置好这个Label的字体大小，字体颜色,圆角等一切想要自己定制的属性，创造出来的Item样式将取决于此exampleLabel
@property (nonatomic, weak) UIButton *exampleButton;
@property (nonatomic, strong)NSMutableArray <UIButton*>*buttonArray;//每一个button
- (instancetype) initWithFrame:(CGRect)frame button:(UIButton *)exampleButton dataArray: (NSMutableArray*) dataArray;
- (void)addHistoryBtnWithString:(NSString*)string reLayout:(BOOL)is;
@end

NS_ASSUME_NONNULL_END
