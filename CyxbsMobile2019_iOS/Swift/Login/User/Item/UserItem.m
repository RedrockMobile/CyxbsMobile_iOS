//
//  UserItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "UserItem.h"
//开启CCLog
#define CCLogEnable 1

@implementation UserItem
@synthesize stuNum = _stuNum;

MJExtensionCodingImplementation
static dispatch_once_t onceToken;
static UserItem *item = nil;
+ (UserItem *)defaultItem {
    if (!item) {
        item = [NSKeyedUnarchiver unarchiveObjectWithFile:[UserItemTool userItemPath]];
        if (!item) {
            item = [[UserItem alloc] init];
        }
    }
    return item;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        //为登录那边的
        @"stuNum":@"Data.stu_num",
        @"gender":@"Data.gender",
        @"redid":@"Redid",
        
        //为个人信息的：
        @"headImgUrl":@"photo_src",
        @"realName":@"username"
    };
}

- (NSString *)stuNum {
    if (_stuNum == nil || [_stuNum isEqualToString:@""]) {
        _stuNum = [NSUserDefaults.standardUserDefaults stringForKey:@"stuNum"];
    }
    return _stuNum;
}

- (void)getUserInfo {
    
    [HttpTool.shareTool
     request:Mine_POST_getPersonData_API
     type:HttpToolRequestTypePost
     serializer:HttpToolRequestSerializerHTTP
     bodyParameters:nil
     progress:nil
     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable object) {
        NSLog(@"%@",object);
        [UserItem mj_objectWithKeyValues:object[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserItemGetUserInfo" object:@(YES)];
    }
     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CCLog(@"fai,%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserItemGetUserInfo" object:@(NO)];
    }];
    
//    [[HttpClient defaultClient] requestWithPath:Mine_POST_getPersonData_API method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//
//
//        NSLog(@"%@",responseObject);
//        [UserItem mj_objectWithKeyValues:responseObject[@"data"]];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserItemGetUserInfo" object:@(YES)];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        CCLog(@"fai,%@",error);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserItemGetUserInfo" object:@(NO)];
//    }];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    dispatch_once(&onceToken, ^{
        item = [super allocWithZone:zone];
    });
    return item;
}

- (void)setToken:(NSString *)token {
    _token = token;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setIat:(NSString *)iat {
    _iat = iat;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setExp:(NSString *)exp {
    _exp = exp;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setRefreshToken:(NSString *)refreshToken {
    _refreshToken = refreshToken;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setRealName:(NSString *)realName {
    _realName = realName;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setGender:(NSString *)gender {
    _gender = gender;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setBirthday:(NSString *)birthday {
    _birthday = birthday;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setRedid:(NSString *)redid {
    _redid = redid;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setStuNum:(NSString *)stuNum {
    _stuNum = stuNum;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setNickname:(NSString *)nickname {
    _nickname = nickname;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setIntroduction:(NSString *)introduction {
    _introduction = introduction;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setHeadImgUrl:(NSString *)headImgUrl {
    _headImgUrl = headImgUrl;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setPhone:(NSString *)phone {
    _phone = phone;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setQq:(NSString *)qq {
    _qq = qq;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setCheckInDay:(NSString *)checkInDay {
    _checkInDay = checkInDay;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setIntegral:(NSString *)integral {
    _integral = integral;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setRank:(NSString *)rank {
    _rank = rank;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setRank_Persent:(NSString *)rank_Persent {
    _rank_Persent = rank_Persent;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setWeek_info:(NSString *)week_info {
    _week_info = week_info;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setCanCheckIn:(BOOL)canCheckIn {
    _canCheckIn = canCheckIn;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setIsCheckedToday:(BOOL)isCheckedToday {
    _isCheckedToday = isCheckedToday;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setBuilding:(NSString *)building {
    _building = building;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setRoom:(NSString *)room {
    _room = room;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setVolunteerUserName:(NSString *)volunteerUserName {
    _volunteerUserName = volunteerUserName;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}
- (void)setVolunteerPassword:(NSString *)volunteerPassword {
    _volunteerPassword = volunteerPassword;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}


- (void)setIdsBindingSuccess:(BOOL)idsBindingSuccess {
    _idsBindingSuccess = idsBindingSuccess;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}

- (void)setFirstLogin:(BOOL)firstLogin {
    _firstLogin = firstLogin;
    [NSKeyedArchiver archiveRootObject:self toFile:[UserItemTool userItemPath]];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", self.mj_keyValues];
}


- (void)attemptDealloc{
    _token = nil;
    _iat = nil;
    _exp = nil;
    _refreshToken = nil;
    _realName = nil;
    _gender = nil;
    _college = nil;
    _redid = nil;
    _stuNum =nil;
    _nickname = nil;
    _introduction = nil;
    _headImgUrl = nil;
    _phone = nil;
    _qq = nil;
    _checkInDay = nil;
    _integral = nil;
    _rank = nil;
    _rank_Persent = nil;
    _week_info = nil;
    _canCheckIn = NULL;
    _building = nil;
    _room = nil;
    _volunteerPassword = nil;
    _volunteerUserName = nil;
    _firstLogin = nil;
    _idsBindingSuccess = NULL;
}
@end
