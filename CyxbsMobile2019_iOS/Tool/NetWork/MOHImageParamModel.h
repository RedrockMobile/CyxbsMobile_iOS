//
//  ImageParamProtocol.h
//  MoblieCQUPT_iOS
//
//  Created by user on 16/5/10.
//  Copyright © 2016年 Orange-W. All rights reserved.
//



@interface MOHImageParamModel:NSObject
@property (copy, nonatomic, nonnull) NSString *paramName;///参数名字
@property (strong, nonatomic, nonnull) UIImage *uploadImage;///上传的图片

//可选
@property (copy, nonatomic, nullable) NSString *fileName;///上传的名字 (服务器一般要求 png 结尾)
@property (assign, nonatomic)  CGFloat perproRate;///独立压缩率,不设置则使用公共压缩率

@end
