//
//  ModifyVC.h
//  HUDDemo
//
//  Created by 宋开开 on 2022/8/10.
//

// 此类为忘记密码的第二个界面，也即输入两个新密码并修改的界面
#import "LoginBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ModifyVCDelegate <NSObject>

/// 修改密码成功后使忘记密码界面消失
- (void)dismissVC;

@end

@interface ModifyVC : LoginBaseVC

/// 学号信息
@property (nonatomic, strong) NSString *stuIDStr;

/// 验证码
@property (nonatomic, strong) NSNumber *code;

@property (nonatomic, weak) id <ModifyVCDelegate> modifyDelegate;

@end

NS_ASSUME_NONNULL_END
