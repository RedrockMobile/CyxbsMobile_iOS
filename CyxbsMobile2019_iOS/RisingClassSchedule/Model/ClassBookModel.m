//
//  ClassBookModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/4.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ClassBookModel.h"

#pragma mark - ClassBookModel ()

@interface ClassBookModel ()

/// 是否是学生
@property (nonatomic) BOOL isStu;

@end

#pragma mark - ClassBookModel

@implementation ClassBookModel

#pragma mark - Life cycle

- (instancetype)init {
    self = [super init];
    if (self) {
        _startDate =
        [NSDate dateString:[NSUserDefaults.standardUserDefaults
                            stringForKey:RisingClassSchedule_classBegin_String]
             fromFormatter:NSDateFormatter.defaultFormatter
            withDateFormat:@"yyyy.M.d"];
        
        _nowWeek = [NSUserDefaults.standardUserDefaults stringForKey:RisingClassSchedule_nowWeek_String].unsignedLongValue;
        
        self.hashDic = NSMutableDictionary.dictionary;
        self.model = self.makeAry;
    }
    return self;
}

#pragma mark - Getter

- (NSArray *)makeAry {
    NSMutableArray *ma = [NSMutableArray arrayWithCapacity:25];
    for (NSInteger i = 0; i <= 24; i++) {
        NSMutableDictionary <NSIndexPath *, NSArray <SchoolLesson *> *> *dayDic = NSMutableDictionary.dictionary;
        [ma addObject:dayDic];
    }
    return ma.copy;
}

#pragma mark - Method

- (void)toModelWithLesson:(SchoolLesson *)lesson {
    // ???: 接IGList的话，应该是按周为单位
    // 由inSection + inWeek决定
    NSInteger section = lesson.inSection;
    
    NSRange range = lesson.period, remakeRange = range;
    BOOL needRemake = NO;
    for (NSIndexPath *eachRangeIndexPath in self.model[section].allKeys) {
        NSRange maxRange = NSMakeRange(eachRangeIndexPath.section, eachRangeIndexPath.item);
        if (RangeIsInRange(range, maxRange)) {
            // 如果当前在最大里面，加在最大里面
            range = maxRange;
        } else {
            remakeRange = maxRange;
            needRemake = YES;
        }
    }
    
    // 此时，range必定是最后的indexPath
    // 而remakeRange则是以前最大的那个
    // range 转 indexPath
    NSIndexPath *rangeIndexPath = IndexPathForRange(range);
    NSIndexPath *remakeRangeIndexPath = IndexPathForRange(remakeRange);
    
    if (!self.model[section][rangeIndexPath]) {
        NSMutableArray <SchoolLesson *> *sameLessonAry = NSMutableArray.array;
        self.model[section][rangeIndexPath] = sameLessonAry;
    }
    // 加入数组
    [self.model[section][rangeIndexPath] addObject:lesson];
    // 如果两个range不等，将原来的移到现有的，移除原有的
    if (needRemake) {
        [self.model[section][rangeIndexPath] addObjectsFromArray:self.model[section][remakeRangeIndexPath]];
        [self.model[section][remakeRangeIndexPath] removeAllObjects];
    }
}

- (void)toDicWithLesson:(SchoolLesson *)lesson {
    // 算法
    // weekIndexPath 对应 leftIndexPath
    NSIndexPath *weekIndexPath = lesson.weekIndexPath;
    if (!self.hashDic[weekIndexPath]) { // 第几周, 星期几
        NSMutableDictionary *weekDic = NSMutableDictionary.dictionary;
        self.hashDic[weekIndexPath] = weekDic;
    }
    
    // 检查是否有覆盖关系
    __block NSRange range = lesson.period, remakeRange = range;
    __block BOOL needRemake = NO;
    [self.hashDic[weekIndexPath] enumerateKeysAndObjectsUsingBlock:^(NSIndexPath * _Nonnull key, NSMutableArray<SchoolLesson *> * _Nonnull obj, BOOL * _Nonnull stop) {
        // 当前key就是存储中的最大range
        NSRange maxRange = NSMakeRange(key.section, key.item);

        if (RangeIsInRange(range, maxRange)) {
            // 如果当前在最大里面，加在最大里面
            range = maxRange;
            *stop = YES;
        } else if (RangeIsInRange(maxRange, range)) {
            // 如果最大在当前里面，声明要交换并移除key
            needRemake = YES;
            remakeRange = maxRange;
            *stop = YES;
        }
    }];
    
    // 此时，range必定是最后的indexPath
    // 而remakeRange则是以前最大的那个
    // range 转 indexPath
    NSIndexPath *rangeIndexPath = IndexPathForRange(range);
    NSIndexPath *remakeRangeIndexPath = IndexPathForRange(remakeRange);
    
    if (!self.hashDic[weekIndexPath][rangeIndexPath]) {
        NSMutableArray *rangeAry = NSMutableArray.array;
        self.hashDic[weekIndexPath][rangeIndexPath] = rangeAry;
    }
    // 加入数组
    [self.hashDic[weekIndexPath][rangeIndexPath] addObject:lesson];
    // 如果两个range不等，将原来的移到现有的，移除原有的
    if (needRemake) {
        [self.hashDic[weekIndexPath][rangeIndexPath] addObjectsFromArray:self.hashDic[weekIndexPath][remakeRangeIndexPath]];
        [self.hashDic[weekIndexPath][remakeRangeIndexPath] removeAllObjects];
    }
}

- (void)saveLesson:(SchoolLesson *)model {
    if (!self.needSave) {
        return;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 删库（除自定义不删）
        [SchoolLesson deleteAll];
    });
    // >>> 查课表，多人课表 可以不用存？ 
    [model save];
}

- (void)saveAryWithNum:(NSString *)num
             fromNetAry:(NSArray *)lessonArray {
    for (NSDictionary *oneLessonDic in lessonArray) {
        for (NSNumber *weekOfLesson in oneLessonDic[@"week"]) {
            // 单个课表的存储
            NSMutableDictionary *schoolLessonDic = oneLessonDic.mutableCopy;
            
            schoolLessonDic[@"save_type"] = (self.isStu ?
            [NSNumber numberWithLong:![num isEqualToString:UserItemTool.defaultItem.stuNum]]
            : @0);
            
            schoolLessonDic[@"week"] = weekOfLesson;
            
            SchoolLesson *lesson = [[SchoolLesson alloc] initWithDictionary:schoolLessonDic];
            
            // WCDB存
            [self saveLesson:lesson];
            
            [self toDicWithLesson:lesson];
//            [self toModelWithLesson:lesson];// test
        }
        // 整周课表的存储
        NSMutableDictionary *schoolLessonDic = oneLessonDic.mutableCopy;
        
        schoolLessonDic[@"save_type"] = (self.isStu ?
        [NSNumber numberWithLong:![num isEqualToString:UserItemTool.defaultItem.stuNum]]
        : @0);
        
        schoolLessonDic[@"week"] = @0;
        
        SchoolLesson *lesson = [[SchoolLesson alloc] initWithDictionary:schoolLessonDic];
        
        [self toDicWithLesson:lesson];
//        [self toModelWithLesson:lesson];// test
    }
}

#pragma mark - Request

- (void)readFromWCDB {
    [self.hashDic removeAllObjects];
    NSArray <SchoolLesson *> *modelAry = [SchoolLesson aryFromWCDB];
    for (SchoolLesson *model in modelAry) {
        // 单个课进入课表管理
        [self toDicWithLesson:model];
        // 整体学期进入课表管理
        SchoolLesson *totleModel = model.copy;
        totleModel.inSection = 0;
        [self toDicWithLesson:totleModel];
    }
}

- (void)requestType:(ClassBookRequestType)requestType
                num:(NSString *)num
            success:(void (^)(void))success
            failure:(void (^)(NSError * _Nonnull))failure {
    NSString *url;
    NSDictionary *dic;
    switch (requestType) {
        case ClassBookRequestStudent: {
            url = ClassSchedule_POST_keBiao_API;
            dic = @{
                @"stu_num": num
            };
        } break;
            
        case ClassBookRequestTeacher: {
            url = ClassSchedule_POST_teaKeBiao_API;
            dic = @{
                @"tea" : num
            };
        } break;
    }
    [HttpTool.shareTool
     request:url
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:dic
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)requestWithNum:(NSString *)stu_Num
               success:(void (^)(void))success
               failure:(void (^)(NSError *error))failure {
    [HttpTool.shareTool
     request:ClassSchedule_POST_keBiao_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{
        @"stu_num": stu_Num
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        if (self.needReset) {
            [self.hashDic removeAllObjects];
        }
        // 如果是单人，肯定要存
        if (self.needSave) {
            // 检查日期
            NSString *startDateStr = object[@"version"];
            NSString *nowWeek = object[@"nowWeek"];
            if (startDateStr) {
                // 不为空则直接设置
                [NSUserDefaults.standardUserDefaults setValue:startDateStr forKey:RisingClassSchedule_classBegin_String];
                [NSUserDefaults.standardUserDefaults setValue:nowWeek forKey:RisingClassSchedule_nowWeek_String];
            }
            self->_startDate =
            [NSDate dateString:[NSUserDefaults.standardUserDefaults
                                stringForKey:RisingClassSchedule_classBegin_String]
                 fromFormatter:NSDateFormatter.defaultFormatter
                withDateFormat:@"yyyy.M.d"];
            self->_nowWeek = [nowWeek intValue];
        }
        
        // 开始存储
        NSArray *lessonArray = [object objectForKey:@"data"];
        
        [self saveAryWithNum:UserItemTool.defaultItem.stuNum fromNetAry:lessonArray];
        
        if (success) {
            success();
        }
        
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 失败取以前的，如果没以前的，就报错，但都得提示error
        if (failure) {
            failure(error);
        }
    }];
}

- (void)requestWithTeacher:(NSString *)tea_Num
                   success:(void (^)(void))success
                   failure:(void (^)(NSError *error))failure {
    self.needSave = NO;
    
    [HttpTool.shareTool
     request:ClassSchedule_POST_teaKeBiao_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:@{
        @"tea" : tea_Num
    }
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        self.isStu = NO;
        
        [self.hashDic removeAllObjects];
        
        NSString *tea_Num = object[@"stu_num"];
        
        NSArray *modelAry = object[@"data"];
        
        [self saveAryWithNum:tea_Num fromNetAry:modelAry];
        
        if (success) {
            success();
        }
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
