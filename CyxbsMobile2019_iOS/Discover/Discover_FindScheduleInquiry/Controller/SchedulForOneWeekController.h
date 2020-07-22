//
//  SchedulForOneWeekController.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PeopleType) {
    /**代表传入的是学生相关*/
    PeopleTypeStudent,
    /**代表传入的是老师相关*/
    PeopleTypeTeacher
};
@interface SchedulForOneWeekController : UIViewController

/**num：学号/工号。type：枚举类型，被查者身份。返回值代表是否加载成功*/
- (BOOL)loadSchedulWithNum:(NSString *)num ForPeopleType:(PeopleType)type;

/**array：一周的7天的课表数据*/
- (void)loadSchedulWithSchedulArray:(NSMutableArray*)array;

/**返回7天的课表(因为服务器崩了，所以这个方法的返回值用来获得一个7天的课表数据)*/
- (NSMutableArray*)keBiao7;
@end

NS_ASSUME_NONNULL_END
//这个工具的使用步骤说明：
//1.创建
//SchedulForOneWeekController *schedul = [[SchedulForOneWeekController alloc]init];

//2.加载课表
//加载方式1（返回值为NO代表加载失败）:
//参数num为学号/工号；参数type是一个枚举，用来得知传入的是工号还是学号
//[schedul loadSchedulWithNum:(NSString *)num ForPeopleType:(PeopleType)type];

//加载方式2:
//参数array为一周的7天的课表数据
//[schedul loadSchedulWithSchedulArray:(NSMutableArray*)array];

//3.呈现控制器schedul的view
//导航控制器push 或者 UIViewController的present
