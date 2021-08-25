//
//  TodoDateTool.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/25.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodoDateTool : NSObject

/// 时间戳指向时间点起，根据model的重复提醒相关的数据，
/// 往未来寻找下一次提醒的时间，不考虑设置提醒界面的那一次提醒。
/// 当 模式为不重复模式时返回-1
/// 当 timeStamp< 0时返回 timeStamp
/// @param timeStamp 指向某一个时间点的时间戳
/// @param model todo数据模型
+ (long)getOverdueTimeStampFrom:(long)timeStamp inModel:(TodoDataModel*)model;
+ (void)addNotiWithModel:(TodoDataModel*)model;
@end

NS_ASSUME_NONNULL_END
