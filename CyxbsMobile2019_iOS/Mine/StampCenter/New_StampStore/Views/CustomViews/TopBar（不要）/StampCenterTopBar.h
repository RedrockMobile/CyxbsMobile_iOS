//
//  TopBar.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol TopBarDelegate <NSObject>

@required
- (void)pop;

@end

@interface StampCenterTopBar : UIView

@property (nonatomic,strong) UIView *stampCountView;
@property (nonatomic,strong) UILabel *stampCenterLbl;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,weak) id<TopBarDelegate> delegate;
@property (nonatomic,strong) NSNumber *number;
@property (nonatomic,strong) UILabel *smallcountLbl;

@end

NS_ASSUME_NONNULL_END
