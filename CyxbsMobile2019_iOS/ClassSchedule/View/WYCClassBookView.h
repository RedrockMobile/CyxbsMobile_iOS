//
//  WYCClassBookView.h
//  ChatBotTest
//
//  Created by 王一成 on 2018/8/29.
//  Copyright © 2018年 wyc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WYCClassBookViewDelegate <NSObject>
@required
- (void)showDetail:(NSArray *)array;
@end


@interface WYCClassBookView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, weak) id<WYCClassBookViewDelegate> detailDelegate;

//为了给空白处加按钮而增加的属性，初始化WYCClassBookViewDelegate这个类时必须为mark赋值
@property (nonatomic, assign)weekData *mark;

-(void)initView:(BOOL)isFirst;

/**参数date内部是7个字典，字典内部：day:某天的日期，month:某天的月份*/
-(void)addBar:(NSArray *)date isFirst:(BOOL)isFirst;

/**参数内部是存放7天的课程数据*/
-(void)addBtn:(NSMutableArray *)day;


-(void)changeScrollViewContentSize:(CGSize)contentSize;
@end
