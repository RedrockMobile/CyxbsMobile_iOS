//
//  ScheduleCombineModel.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/28.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleCombineModel.h"

#import "ScheduleCourse+WCTTableCoding.h"

#import <vector>
#import <array>
#import <map>

using namespace std;

ScheduleCombineType const ScheduleCombineSystem = @"system";

ScheduleCombineType const ScheduleCombineCustom = @"custom";

#pragma mark - ScheduleCombineModel

@implementation ScheduleCombineModel {
    vector< array <map <NSValue *, ScheduleCourse *>, 7>> _drawEntry;
    NSArray *_fiAry;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _courseAry = NSMutableArray.array;
    }
    return self;
}

+ (instancetype)combineWithSno:(NSString *)sno type:(ScheduleCombineType)type {
    BOOL check = ((!sno || sno.length < 2) || (!type));
    if (check) {
        NSAssert(!check, @"\n🔴%s sno : %@, type : %@", __func__, sno, type);
        return nil;
    }
    
    ScheduleCombineModel *model = [[ScheduleCombineModel alloc] init];
    
    model->_sno = sno.copy;
    model->_combineType = type.copy;
    
    return model;
}

#pragma mark - Getter

- (NSString *)identifier {
    return [NSString stringWithFormat:@"%@%@", _combineType, _sno];
}

- (NSArray<NSArray<NSDictionary<NSValue *,ScheduleCourse *> *> *> *)transDraw {
    if (_fiAry) {
        return _fiAry;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:_drawEntry.size()];
    for (auto section : _drawEntry) {
        NSMutableArray *sAry = [NSMutableArray arrayWithCapacity:section.size()];
        [array addObject:sAry];
        for (auto range : section) {
            NSMutableDictionary *rDic = NSMutableDictionary.dictionary;
            [sAry addObject:rDic];
            for(auto aRange = range.begin(); aRange != range.end(); aRange++) {
                rDic[aRange->first] = aRange->second;
            }
        }
    }
    _fiAry = array;
    return array;
}

#pragma mark - Setter

- (void)setCourseAry:(NSArray<ScheduleCourse *> *)courseAry {
    _courseAry = courseAry;
    _drawEntry = {};
    _fiAry = nil;
    _drawEntry.resize(23);
    for (ScheduleCourse *course in courseAry) {
        __block NSInteger inWeek = course.inWeek; // 0..<7
        __block NSValue *inRange = [NSValue valueWithRange:course.period];
        [course.inSections enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * __unused stop) {
            NSInteger inSection = obj.longValue; // 1...
            inSection = (inSection >= 23 ? 0 : inSection); // 0..<23
            [self _entryCourse:course withSection:inSection week:inWeek range:inRange];
        }];
        [self _entryCourse:course withSection:0 week:inWeek range:inRange];
    }
}

#pragma mark - Privite

- (void)_entryCourse:(ScheduleCourse *)course withSection:(NSInteger)inSection week:(NSInteger)inWeek range:(NSValue *)inRange {
    NSAssert((inWeek >= 0 && inWeek < 7), @"越界");
    _drawEntry[inSection][inWeek][inRange] = course;
}

@end

#pragma mark - ScheduleCombineModel (XXHB)

@implementation ScheduleCombineModel (XXHB)

+ (NSString *)path {
    NSString *pathComponent = [NSString stringWithFormat:@"/schedule/"];
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:pathComponent];
}

+ (WCTDatabase *)db {
    static WCTDatabase *_db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _db = [[WCTDatabase alloc] initWithPath:self.path];
    });
    return _db;
}

- (void)replace {
    [self.class.db deleteAllObjectsFromTable:self.identifier];
    [self.class.db insertObjects:self.courseAry into:self.identifier];
}

- (void)awake {
    self.courseAry = [self.class.db getAllObjectsOfClass:ScheduleCourse.class fromTable:self.identifier].mutableCopy;
}

@end

#pragma mark - ScheduleCombineModelStatus

@implementation ScheduleCombineModelStatus

+ (instancetype)statusWithCombine:(ScheduleCombineModel *)combine {
    ScheduleCombineModelStatus *model = [[ScheduleCombineModelStatus alloc] init];
    model.combine = combine;
    model.isConnect = YES;
    return model;
}

@end

#pragma mark - ScheduleCombineModel (Status)

@implementation ScheduleCombineModel (Status)

- (ScheduleCombineModelStatus *)status {
    return [ScheduleCombineModelStatus statusWithCombine:self];
}

@end
