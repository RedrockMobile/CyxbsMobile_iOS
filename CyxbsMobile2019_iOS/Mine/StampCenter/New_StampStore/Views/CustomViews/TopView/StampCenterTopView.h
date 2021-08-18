//
//  TopView.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TopViewDelegate <NSObject>

- (void)goPageOne;
- (void)goPageTwo;
- (void)goDetail;

@end

@interface StampCenterTopView : UIView

@property (nonatomic,strong) UIView *bar;
@property (nonatomic,strong) UILabel *bigStampCountLbl;
@property (nonatomic,strong) UILabel *alertLbl;
@property (nonatomic,strong) UILabel *stampStoreLbl;
@property (nonatomic,strong) UILabel *stampTaskLbl;
@property (nonatomic,strong) UIImageView *point;
@property (nonatomic,strong) UIImageView *bigStampImage;
@property (nonatomic,strong) UIImageView *bannerImage;
@property (nonatomic,strong) UIImageView *switchbar;
@property (nonatomic,strong) UIImageView *swithPoint;
@property (nonatomic,strong) UIButton *page1btn;
@property (nonatomic,strong) UIButton *page2btn;
@property (nonatomic) UIButton *detailBtn;
@property (nonatomic,copy) NSString *stampCount;
@property (nonatomic,strong) UIView *holder;


@property (nonatomic,strong) NSNumber *number;


@property (nonatomic,strong) UILabel *mingxiLbl;
@property (nonatomic,strong) UILabel *wodeyoupiao;

@property (nonatomic,weak) id<TopViewDelegate> delegate;



@end

NS_ASSUME_NONNULL_END
