//
//  ClassScheduleModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/2.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ClassScheduleModel.hpp"

#import <array>

#pragma mark - ClassScheduleRequestType

ClassScheduleRequestType student = @"stu_num";

ClassScheduleRequestType custom = @"custom";

ClassScheduleRequestType teacher = @"tea";

#pragma mark - ClassScheduleModel ()

@interface ClassScheduleModel ()

/// 真正的课表存储
@property (nonatomic, strong) NSMutableArray <NSMutableArray <SchoolLesson *> *> *model;

@end

#pragma mark - ClassScheduleModel

@implementation ClassScheduleModel

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _startDate =
        [NSDate dateString:[NSUserDefaults.standardUserDefaults
                            stringForKey:RisingClassSchedule_classBegin_String]
             fromFormatter:NSDateFormatter.defaultFormatter
            withDateFormat:@"yyyy.M.d"];
        
        _nowWeek = [NSUserDefaults.standardUserDefaults stringForKey:RisingClassSchedule_nowWeek_String].unsignedLongValue;
        
        [self model];
        
        std::array <std::array <std::array <int, 13>, 8>, 25> ary = {};
        _fastAry = ary;
    }
    return self;
}

#pragma mark - Private Modthod

- (void)onceSave:(NSDictionary *)object {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
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
        self->_nowWeek = [NSUserDefaults.standardUserDefaults
                          stringForKey:RisingClassSchedule_nowWeek_String].longValue;
    });
}

#pragma mark - Method

- (void)append:(SchoolLesson *)lesson withKeyNum:(NSString *)num{
    
    BOOL insertToFirst = NO;
    for (NSInteger i = 0; i < lesson.period.length; i++) {
        if (_fastAry[lesson.inSection][lesson.inWeek][lesson.period.location + i] == 0) {
            // 原来没存数据，来了个新的
            if (![lesson.sno isEqualToString:num]) {
                // 1.别人的课表
                _fastAry[lesson.inSection][lesson.inWeek][lesson.period.location + i] = 1;
            } else {
                if ([lesson.type isEqualToString:@"自定义"]) {
                    // 2.自定义课表
                    _fastAry[lesson.inSection][lesson.inWeek][lesson.period.location + i] = 3;
                } else {
                    // 3.自己的课表
                    _fastAry[lesson.inSection][lesson.inWeek][lesson.period.location + i] = 5;
                }
            }
        } else {
            int t = _fastAry[lesson.inSection][lesson.inWeek][lesson.period.location + i];
            // 原来有数据，新添一个数据
            if (![lesson.sno isEqualToString:UserItemTool.defaultItem.stuNum]
                && t >= 1 && t <= 2) {
                // 1.别人的课表
                _fastAry[lesson.inSection][lesson.inWeek][lesson.period.location + i] = 2;
            } else {
                if ([lesson.type isEqualToString:@"自定义"]
                    && t >= 1 && t <= 4) {
                    // 2.自定义课表
                    _fastAry[lesson.inSection][lesson.inWeek][lesson.period.location + i] = 4;
                } else if (![lesson.type isEqualToString:@"自定义"]
                    && t >= 1 && t <= 6) {
                    // 3.自己的课表
                    _fastAry[lesson.inSection][lesson.inWeek][lesson.period.location + i] = 6;
                }
            }
            
            insertToFirst = YES;
        }
    }
    
    if (insertToFirst) {
        [self.model[lesson.inSection] insertObject:lesson atIndex:0];
    } else {
        [self.model[lesson.inSection] addObject:lesson];
    }
}

#pragma mark - Request

- (void)request:(NSDictionary
                 <ClassScheduleRequestType,NSArray
                 <NSString *> *> *)requestDictionary
        success:(void (^)(NSProgress *progress))success
        failure:(void (^)(NSError * _Nonnull))failure {
    
    __block NSDictionary *apiDic = @{
        student : ClassSchedule_POST_keBiao_API,
        teacher : ClassSchedule_POST_teaKeBiao_API,
        custom : @""
    };
    
    __block NSInteger count = 0;
    __block NSInteger current = 0;
    
    [requestDictionary enumerateKeysAndObjectsUsingBlock:^(ClassScheduleRequestType  _Nonnull key, NSArray<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
        
        for (NSString *num in obj) {
            count += 1;
            
            [HttpTool.shareTool
             request:apiDic[key]
             type:HttpToolRequestTypePost
             serializer:HttpToolRequestSerializerHTTP
             bodyParameters:@{
                key : num
            }
             progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
                current += 1;
                
                [self onceSave:object];
                
                NSArray *lessonAry = [object objectForKey:@"data"];
                NSString *stuNum = object[@"stuNum"];
                
                for (NSDictionary *oneLessonDic in lessonAry) {
                    for (NSNumber *weekOfLesson in oneLessonDic[@"week"]) {
                        // 1.先copy一份，确保dic为一节课的所有信息
                        NSMutableDictionary *schoolLessonDic = oneLessonDic.mutableCopy;
                        
                        schoolLessonDic[@"week"] = weekOfLesson;
                        schoolLessonDic[@"sno"] = stuNum;
                        if ([key isEqualToString:custom]) {
                            schoolLessonDic[@"type"] = @"自定义";
                        }
                        
                        // 2.转模型，并实现快速表
                        SchoolLesson *lesson = [[SchoolLesson alloc] initWithDictionary:schoolLessonDic];
                        
                        /// int a[25][7][12];
                        /// for (int i = 0; i < lesson.period.lenth; i++) {
                        ///     if object[@"stunum"] = usertool.stu
                        ///     self.a[lesson.inSection][lesson.inWeek][lesson.period.location + i] = TODO
                        /// }
                        
                        // WCDB存
                        // TODO: [self saveLesson:lesson];
                        NSString *currentNum = (count == 1 ? stuNum : UserItemTool.defaultItem.stuNum);
                        [self append:lesson withKeyNum:currentNum];
                        
//                        [self.model[weekOfLesson.unsignedLongValue] addObject:lesson];
                    }
                    // 整周课表的存储
                    NSMutableDictionary *schoolLessonDic = oneLessonDic.mutableCopy;
                    
                    schoolLessonDic[@"week"] = @0ull;
                    schoolLessonDic[@"sno"] = stuNum;
                    if ([key isEqualToString:custom]) {
                        schoolLessonDic[@"type"] = @"自定义";
                    }
                    
                    SchoolLesson *lesson = [[SchoolLesson alloc] initWithDictionary:schoolLessonDic];
                    
                    // WCDB存
                    // TODO: [self saveLesson:lesson];
                    NSString *currentNum = (count == 1 ? stuNum : UserItemTool.defaultItem.stuNum);
                    [self append:lesson withKeyNum:currentNum];
                    
//                    [self.model[0] addObject:lesson];
                }
                
                if (success) {
                    NSProgress *progress = [[NSProgress alloc] init];
                    progress.totalUnitCount = count;
                    progress.completedUnitCount = current;
                    success(progress);
                }
            }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
    }];
}

#pragma mark - WCDB

- (void)awakeFromWCDB {
//    NSArray <SchoolLesson *> *ary = [SchoolLesson aryFromWCDB];
    NSArray <SchoolLesson *> *ary;
    if (!_model) {
        self.model = nil;
    }
    [self model];
    
    for (SchoolLesson *lesson in ary) {
        [self.model[lesson.inSection] addObject:lesson];
        /// for (int i = 0; i < lesson.period.lenth; i++) {
        ///     self.a[lesson.inSection][lesson.inWeek][lesson.period.location + i] = TODO
        /// }
    }
}

#pragma mark - Getter

- (NSArray<NSArray<SchoolLesson *> *> *)classModel {
    return self.model.copy;
}

- (NSMutableArray<NSMutableArray<SchoolLesson *> *> *)model {
    if (_model == nil) {
        NSInteger count = 25;
        _model = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; i++) {
            NSMutableArray <SchoolLesson *> *perAry = NSMutableArray.array;
            [_model addObject:perAry];
        }
    }
    return _model;
}

@end
