//
// WYCClassDetailView.h
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/23.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//@protocol WYCClassDetailViewDelegate <NSObject>
//@required
//- (void)eventWhenChooseClassListBtnClick:(NSString *)str;
//@end


@interface WYCClassDetailView : UIView

+(WYCClassDetailView *)initViewFromXib;
-(void)initWithDic:(NSDictionary *)dic;
//@property (nonatomic, weak) id<WYCClassDetailViewDelegate> classbookDetailDelegate;

@end

NS_ASSUME_NONNULL_END
