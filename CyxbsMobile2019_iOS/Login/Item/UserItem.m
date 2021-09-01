//
//  UserItem.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/23.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "UserItem.h"

@implementation UserItem
@synthesize stuNum = _stuNum;

MJExtensionCodingImplementation

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
    /*
     "photo_thumbnail_src"
     stunum
     */
}

- (NSString *)stuNum {
    if (_stuNum == nil || [_stuNum isEqualToString:@""]) {
        _stuNum = [UserDefaultTool getStuNum];
    }
    return _stuNum;
}

- (void)getUserInfo {
    [[HttpClient defaultClient] requestWithPath:getPersonData method:HttpRequestPost parameters:nil prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [UserItem mj_objectWithKeyValues:responseObject[@"data"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserItemGetUserInfo" object:@(YES)];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        CCLog(@"fai,%@",error);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserItemGetUserInfo" object:@(NO)];
    }];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
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
@end
