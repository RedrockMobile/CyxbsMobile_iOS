//
//  IDModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/10/29.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString* IDModelIDType;
extern const IDModelIDType IDModelIDTypeAut;
extern const IDModelIDType IDModelIDTypeCus;


@interface IDModel : NSObject
/// 身份的ID
@property (nonatomic, copy)NSString *idStr;

/// 发布这个身份的部门，只有认证身份才有这个字段
@property (nonatomic, copy)NSString *departmentStr;

/// 职位
@property (nonatomic, copy)NSString *positionStr;

//身份有效期
@property (nonatomic, copy)NSString *validDateStr;

/// 背景图片
@property (nonatomic, copy)NSString *bgImgURLStr;

/// 是否已经过期
@property (nonatomic, assign)BOOL islate;

/// 身份的类型，认证身份，还是个性身份
@property (nonatomic, copy)IDModelIDType idTypeStr;

/// 身份是拿来展示的那个身份
@property (nonatomic, assign)BOOL isshow;

//debug
@property (nonatomic, strong)UIColor *color;

@property (nonatomic, assign)NSInteger gainIDTime;

@property (nonatomic, assign)NSInteger idInvalidTime;

+ (void)deleteIdentityWithIdentityId:(NSString *)identityId
                             success:(void (^)(void))success
                             failure:(void (^)(void))failue;

@end

NS_ASSUME_NONNULL_END
/*
 "id": "C41:bd9b0dc6d532fde4c5ea29d32f7a06c857961a85",
 "position": "cybText",
 "date": "2021.8.18-2021.8.18",
 "background": "",
 "identityPic": "",
 "islate": true,
 "type": "个性身份",
 "isshow": false
 */
