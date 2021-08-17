//
//  TODOModel.h
//  ZY
//
//  Created by 欧紫浩 on 2021/8/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TODOModel : NSObject
///事件
@property (nonatomic,copy) NSString *modeltodo_thing;
//@property (nonatomic,copy) NSString *modeltodo_time;
/// 时间戳
@property(nonatomic, assign) NSInteger timestamp;
/// 是否已经完成
@property(nonatomic, assign) BOOL isDone;
@end

NS_ASSUME_NONNULL_END
