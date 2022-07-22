//
//  RisingRouterResponse.h
//  Rising
//
//  Created by SSR on 2022/7/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ENUM (RisingRouterResponseError)

typedef NS_ENUM(NSUInteger, RisingRouterResponseError) {
    RouterResponseSuccess,      // 成功响应
    
    RouterParameterLoss,        // 参数缺失
    RouterParameterMatchFaild,  // 匹配失败
    RouterParameterClassError,  // 类型错误
    RouterParameterConflict,    // 参数互斥
    
    RouterWithoutNavagation     // 无栈管理
};

#pragma mark - RisingRouterResponse

@interface RisingRouterResponse : NSObject

/// 响应的类
@property (nonatomic, nullable) Class responseClass;

/// 是否被push
@property (nonatomic) BOOL pushed;

/// 错误代码
@property (nonatomic) RisingRouterResponseError errorCode;

/// 错误描述
@property (nonatomic, copy) NSString *errorDescription;

/// 成功的response
/// @param isPushed 是否被push，如果只是传值，则不需要
+ (instancetype)responseSuccessPushed:(BOOL)isPushed;

/// 失败的response
/// @param isPushed 是否被push
/// @param code 错误代码
/// @param description 错误描述
+ (instancetype)responseErrorPushed:(BOOL)isPushed
                          errorCode:(RisingRouterResponseError)code
                   errorDescription:(NSString * _Nullable)description;

@end

NS_ASSUME_NONNULL_END
