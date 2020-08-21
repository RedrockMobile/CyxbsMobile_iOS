//
//  NoteDataModel.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoteDataModel : NSObject
- (instancetype)initWithNotoDataDict:(NSDictionary*)noteDataDict;


/// @[@4,@1,@18]代表第4、1、18周的备忘
@property(nonatomic,strong)NSArray <NSNumber*> *weeksArray;

/// @[
///     @{@"weekNum":@0,  @"lessonNum":@2},
///     @{@"weekNum":@1,  @"lessonNum":@0}
/// ]
///代表某周的周一 第3节大课和周二的第一节大课的备忘
@property(nonatomic,strong)NSArray <NSDictionary*> *timeDictArray;

/// 备忘标题
@property(nonatomic,copy)NSString *noteTitleStr;

/// 备忘详情
@property(nonatomic,copy)NSString *noteDetailStr;

/// 提前多分钟提醒，0代表不提醒
@property(nonatomic,strong)NSNumber *notiBeforeTime;

///@[@"第一周"，@“第二周”]
@property(nonatomic,strong)NSArray <NSString*> *weeksStrArray;

///@[
///     @{@"weekString":@"",  @"lessonString":@""}
///@]           //周x                            //xx节课
@property(nonatomic,strong)NSArray <NSDictionary*> *timeStrDictArray;

//init时传入的字典
@property(nonatomic,strong)NSDictionary *noteDataDict;
@end

NS_ASSUME_NONNULL_END
