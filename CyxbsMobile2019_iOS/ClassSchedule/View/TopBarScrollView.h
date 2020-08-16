//
//  TopBarScrollView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TopBarScrollViewDelegate <NSObject>
//index里面是0，代表点击整学期，是17代表点击十七周
- (void)gotoWeekAtIndex:(NSNumber*)index;
@end
//@protocol TopBarScrollViewNowWeekBarDelegate <NSObject>
//
//- (void)
//
//@end
@interface TopBarScrollView : UIScrollView

//正确的下标，修改correctIndex后自动把该下标对应的view移动到中央
//改变correctIndex，KVO会根据correctIndex的改变完成一系列相关操作,0代表在整学期页
@property (nonatomic,assign)NSNumber *correctIndex;
@property (nonatomic,weak)id<TopBarScrollViewDelegate>weekChooseDelegate;

@end

NS_ASSUME_NONNULL_END
