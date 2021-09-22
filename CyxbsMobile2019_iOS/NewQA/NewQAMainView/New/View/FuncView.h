//
//  FuncView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN
@protocol FuncViewProtocol <NSObject>
- (void)ClickedStarGroupBtn:(UIButton *)sender;
- (void)ClickedShieldBtn:(UIButton *)sender;
- (void)ClickedReportBtn:(UIButton *)sender;

@end

@interface FuncView : UIView
@property (nonatomic, strong) UIButton *starGroupBtn;

@property (nonatomic, strong) UIButton *shieldBtn;

@property (nonatomic, strong) UIButton *reportBtn;

@property (nonatomic, strong) NSNumber *funcViewTag;

@property (nonatomic, weak) id<FuncViewProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
