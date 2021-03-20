//
//  CyxbsMobilePathAndKey.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/20.
//  Copyright © 2021 Redrock. All rights reserved.
//这里面放一些文件路径的宏 以及缓存的key的宏

#ifndef CyxbsMobilePathAndKey_h
#define CyxbsMobilePathAndKey_h

//课表、备忘数据文件的文件夹
#define remAndLesDataDirectoryPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/rem&les"]

//未解析的课表数据文件路径
#define rowDataArrPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/rem&les/rowLessonDataArr"]

//已解析的课表数据文件路径,假设取出的数组是orderlySchedulArray，那么：
//orderlySchedulArray[i][j][k]代表（第i周）的（星期j+1）的（第k+1节大课）
//ijk的范围：i[0, 25], j[0, 6], k[0, 5]
#define parsedDataArrPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/rem&les/parsedLessonDataArr"]


//备忘数据文件夹路径
#define remDataDirectory [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/remDataDirectory"]

//备忘数据文件路径
#define remDataArrPath [remDataDirectory stringByAppendingPathComponent:[UserItem defaultItem].stuNum]

//#define remDataArrPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/rem&les/remindDataArr"]

//可以通过NSUserDefaults取出当前周数，类型是NSString
#define nowWeekKey_NSString @"nowWeekKey_NSString"
//个人页的获赞数的缓存的key
#define MinePraiseCntStrKey @"MinePraiseCntStrKey"
//个人页的动态数的缓存的key
#define MineDynamicCntStrKey @"MineDynamicCntStrKey"
//个人页的评论数的缓存的key
#define MineCommentCntStrKey @"MineCommentCntStrKey"


//可以用userDefault取出开学日期，格式是@"yyyy-MM-dd"
#define DateStartKey_NSString @"DateStartKey_NSString"

#endif /* CyxbsMobilePathAndKey_h */
