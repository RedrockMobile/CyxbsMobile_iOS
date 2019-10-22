//
//  NetWork.h
//  OrangeFrame
//
//  Created by user on 15/7/16.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//

#ifndef OrangeFrame_NetWork_h
#define OrangeFrame_NetWork_h

#endif
#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import "UIKit+AFNetworking.h"
#import "ORWRequestCache.h"
#import "MOHImageParamModel.h"

/**
 *  @author Orange-W, 15-07-17 20:07:44
 *
 *  @brief  相关头:
 *           0->网络原因
 *           2->ok,
 *           6->参数错误
 *           7->权限原因
 *           -1->未知错误
 */
@interface NetWork : NSObject{
    enum requestStatus{
        Sucess              = 200,
        NetConnectFail      = 0,
        PurviewNotEnough    = 400,
        UnkonwWrong         = -1,
    };
}

//定义返回请求数据的block类型
typedef void (^SucessWithJson) (id returnValue);
typedef void (^ErrorCode) (id errorCode);
typedef void (^FailureFunction)(void);
typedef void (^NetWorkBlock)(BOOL netConnetState);

+ (void)NetRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (SucessWithJson) successFunction
                  //WithErrorCodeBlock: (ErrorCode) errorBlock
                    WithFailureBlock: (FailureFunction) failureFunction;

+ (void)NetRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (SucessWithJson) block
                   //WithErrorCodeBlock: (ErrorCode) errorBlock
                     WithFailureBlock: (FailureFunction) failureBlock;

+ (BOOL) netWorkReachability:(NSString *) strUrl;

+ (void)uploadImageWithUrl:(NSString *)url
               imageParams:(NSArray<MOHImageParamModel *> *)imageParamsArray
               otherParams:(NSDictionary *)params
          imageQualityRate:(CGFloat)rate
              successBlock:(SucessWithJson) block
              failureBlock:(FailureFunction) failureBlock;

@end
