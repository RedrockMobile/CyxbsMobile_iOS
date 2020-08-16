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
//7天的课表数据，schedulData[i][j]是一个数组，代表（星期i+1）的（第j+1节大课）的课，count>1代表有多节课
@property (nonatomic, strong)NSMutableArray *schedulData;

-(void)initViewIsFirst:(BOOL)isFirst;

/**参数date内部是7个字典，字典内部：day:某天的日期，month:某天的月份*/
-(void)addBar:(NSArray *)date isFirst:(BOOL)isFirst;

/**显示自己课表和同学课表时要调用这个方法，参数day内部是存放7天的课程数据*/
-(void)addBtn:(NSMutableArray *)day;

/**显示没课约页面的课表时要调用这个方法，参数day内部是存放7天的课程数据*/
- (void)addBtnForWedate:(NSMutableArray *)day;

-(void)changeScrollViewContentSize:(CGSize)contentSize;

@end
