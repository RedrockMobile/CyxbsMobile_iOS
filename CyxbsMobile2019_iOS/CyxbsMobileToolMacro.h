//
//  CyxbsMobileToolMacro.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/3/20.
//  Copyright © 2021 Redrock. All rights reserved.
//这里面放一些工具宏

#ifndef CyxbsMobileToolMacro_h
#define CyxbsMobileToolMacro_h


#pragma mark - 自定义Log
#ifdef DEBUG
    #define NSLog(format, ...) do {                                                                          \
    fprintf(stderr, "<%s : %d> | %s\n",                                           \
    [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
    __LINE__, __func__);                                                        \
    (NSLog)((format), ##__VA_ARGS__);                                           \
    fprintf(stderr, "-------\n");                                               \
    } while (0)
#else
    #define NSLog(format, ...) ;
#endif

//++++++++++++++++++Stove的自定义Log˙++++++++++++++++++++  Begain
#ifdef DEBUG
//每行的最大长度，行尾分隔符，字符串
#define CCCLog(line, separator, str) do {\
for (__strong NSString *CCLogStr__ in [str componentsSeparatedByString:@"\n"]) {\
while (CCLogStr__.length > line) {\
fprintf(stderr, "%s    %s\n",\
[[CCLogStr__ substringToIndex:line] UTF8String],\
separator);\
CCLogStr__ = [CCLogStr__ substringFromIndex:line];\
}\
while (CCLogStr__.length < line + 4) {\
CCLogStr__ = [CCLogStr__ stringByAppendingString:@"                                                  "];\
}\
fprintf(stderr,"%s%s\n",\
[[[NSString stringWithFormat:@"%@", CCLogStr__] substringToIndex:line + 4] UTF8String],\
separator);\
}\
fprintf(stderr,"\n");\
} while(0)
//CCLog(@"Hello, World!"); CCLog(@"˙77Hello, World!");
#define CCLog(format, ...) do {\
fprintf(stderr,"Stove[%s - %d˙]:\n",\
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],\
__LINE__);\
\
if ([[format substringToIndex:1] isEqual:@"˙"]) {\
int line = [format substringWithRange:NSMakeRange(1, 2)].intValue;\
if (line==0) line = 77;\
char* separator = "˙";\
NSString* str = [[NSString stringWithFormat:format, ##__VA_ARGS__] substringFromIndex:3];\
CCCLog(line, separator, str);\
}else {\
printf("%s\n\n",[[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String]);\
}\
} while (0)

#else
#define CCCLLog(line, separator, str)
#define CCLog(format, ...)
#endif
//++++++++++++++++++Stove的自定义Log˙++++++++++++++++++++  End



#pragma mark - 颜色

#define BACK_COLOR [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0]
#define MAIN_COLOR  [UIColor colorWithRed:84/255.0 green:172/255.0 blue:255/255.0 alpha:1]
#define FONT_COLOR  [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1]
//#define MAIN_COLOR  [UIColor colorWithRed:111/255.0 green:219/255.0 blue:188/255.0 alpha:1]
#define rectStartsBar [UIApplication sharedApplication].statusBarFrame.size.height
#define MAIN_SCREEN_H [UIScreen mainScreen].bounds.size.height
#define MAIN_SCREEN_W [UIScreen mainScreen].bounds.size.width
#define kBarTintColor MAIN_COLOR
#define kItemTintColor [UIColor blackColor]
#define kFont [UIFont fontWithName:@"Arial" size:14]
#define kTextColor [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1]
#define kDetailTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.7]

#define COLOR_NEED [UIColor colorWithRed:101/255.0 green:178/255.0 blue:255/255.0 alpha:1]
#define COLOR_NONEED [UIColor colorWithRed:148/255.0 green:148/255.0 blue:148/255.0 alpha:0.6]



#define kWidthGrid  (SCREEN_WIDTH/7.5)

#define RGBColor(r,g,b,a) ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a])

#define KUIColorFromRGB(rgbValue)       [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ColorArray [[NSMutableArray alloc]initWithObjects:@"254,145,103",@"120,201,252",@"111,219,188",@"191,161,233",nil]

#define kPhotoImageViewW (SCREEN_WIDTH - 2 * 10 - 4) / 3

//gege
#define BACK_GRAY_COLOR [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1]




//显示月份的view宽度；显示第几节课的竖条宽度
#define MONTH_ITEM_W (MAIN_SCREEN_W*0.088)
//显示月份、周几、日期的条内部item的间距；课表view和leftBar的距离
#define DAYBARVIEW_DISTANCE (MAIN_SCREEN_W*0.0075)
//0.00885



#pragma mark - 屏幕适配相关

//判断是否是iPhone8比例的屏幕（375 * 667）
#define IS_IPHONE8 (fabs(SCREEN_HEIGHT*0.56235945-SCREEN_WIDTH) < 40)

//判断是否是iPhoneSE 1代的比例
#define IS_IPHONESE (SCREEN_WIDTH == 320.f && SCREEN_HEIGHT == 568.f)

/* 全面屏相关 */
#define IS_IPHONEX (fabs(SCREEN_HEIGHT*0.46193812-SCREEN_WIDTH) < 30)
//#define IS_IPHONEX ((SCREEN_WIDTH == 375.f && SCREEN_HEIGHT == 812.f) || (SCREEN_WIDTH == 414.f && SCREEN_HEIGHT == 896.f)? YES : NO)

#define SAFE_AREA_BOTTOM (IS_IPHONEX ? (34.f) : (0.f))


/* 屏幕宽高 */
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

/* TabBar高度 */
#define TABBARHEIGHT (IS_IPHONEX ? (49.f + SAFE_AREA_BOTTOM) : (49.f))

/* 状态栏高度 */
#define STATUSBARHEIGHT [MGDStatusBarHeight getStatusBarHight]

//状态栏高度
#define getStatusBarHeight_Double ^(void){\
    double statusBarH;\
    if (@available(iOS 13.0, *)) {\
        statusBarH = [[UIApplication sharedApplication].windows objectAtIndex:0].windowScene.statusBarManager.statusBarFrame.size.height;\
    } else {\
        statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;\
    }\
    return statusBarH;\
}()



/* NavigationBar高度 */
#define NVGBARHEIGHT (44.f)

/* 顶部总高度 */
#define TOTAL_TOP_HEIGHT (STATUSBARHEIGHT + NVGBARHEIGHT)

#define kSegmentViewTitleHeight (SCREEN_HEIGHT * 50 / 667)

#define SCREEN_WINDOW_HEIGHT (SCREEN_HEIGHT-(STATUS_HEIGHT+44))
#define STATUS_HEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height//状态栏高度


//如果是414-896尺寸的话大概就是1.2325907  ，(宽/375/2 + 0.5)*(高/667/2 + 0.5)
//375*667状态的字号、宽高乘上这个比例，大概可以适配其他尺寸的比例
#define fontSizeScaleRate_SE ((SCREEN_WIDTH/750.0 + 0.5)*(SCREEN_HEIGHT/1334.0+ 0.5 ))


//1.1717
//高度放缩比，(高/667/2 + 0.5)
#define HScaleRate_SE (SCREEN_HEIGHT/1334.0+0.5)
//宽度放缩比，(宽/375)
#define WScaleRate_SE (SCREEN_WIDTH/375.0)

//学期开始时间
#define DateStart @"2021-03-01"
#define DateFormat @"yyyy-MM-dd"


//第一周从1开始，不是从0开始
#define getNowWeek_NSString ^(void) {\
    NSString *nowWeek = [[NSUserDefaults standardUserDefaults] stringForKey:nowWeekKey_NSString];\
    if (nowWeek==nil||nowWeek.intValue > 25) {\
        return @"0";\
    }\
    return nowWeek;\
}()

//返回开学日期的NSDate
#define getDateStart_NSDate ^(void) {\
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];\
    [formatter setDateFormat:DateFormat];\
    return [formatter dateFromString:getDateStart_NSString];\
}()

//返回开学日期的NSString
#define getDateStart_NSString ^(void) {\
    NSString *dateStr = [[NSUserDefaults standardUserDefaults] stringForKey:DateStartKey_NSString];\
    if (dateStr==nil) {\
        return @"1970-01-01";\
    }\
    return dateStr;\
}()

//获取今日是否已签到
#define isTodayCheckedIn_BOOL ^(void) {\
    NSString *str = [UserItem defaultItem].week_info;\
    NSInteger day = [NSDate date].weekday;\
    if (day==1) {\
        day = 6;\
    }else {\
        day -= 2;\
    }\
    day = 6-day;\
    NSString *is = [str substringWithRange:NSMakeRange(day, 1)];\
    return is.boolValue;\
}()
//OC自带的CGRect转NSString不好使，所以自己写了这个，只保留两位小数的版本
#define RectToString(r) ^(CGRect rect){\
    return [NSString stringWithFormat:@"%.2f,%.2f,  %.2f,%.2f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];\
}(r)

#pragma mark - 字体
//苹方-简 极细体
#define PingFangSCUltralight    @"PingFangSC-Ultralight"
//苹方-简 纤细体
#define PingFangSCThin @"PingFangSC-Thin"
//苹方-简 细体
#define PingFangSCLight @"PingFangSC-Light"
//苹方-简 常规体
#define PingFangSCRegular @"PingFangSC-Regular"
//苹方-简 中黑体
#define PingFangSCMedium @"PingFangSC-Medium"
//苹方-简 中粗体
#define PingFangSCSemibold @"PingFangSC-Semibold"
/*
 下面这个for，可以打印出现有的所有字体
for(NSString *fontFamilyName in [UIFont familyNames]){
        NSLog(@"family:'%@'",fontFamilyName);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontFamilyName]){
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
}
*/

#define PingFangSCBold @"PingFangSC-Semibold"


// Bahnschrift字体
#define BahnschriftBold @"Bahnschrift_Bold"

// 周数
#define weekCnt 25



#define HEADERHEIGHT (STATUSBARHEIGHT+NVGBARHEIGHT)
#define MWIDTH ((SCREEN_WIDTH)/(DAY*2+1)) //monthLabel的宽度
#define MHEIGHT (1.6*MWIDTH) //monthLabel的高度
#define DAY 7
#define LESSON 12
#define WEEK 20
#define LONGLESSON (LESSON/2)
#define LESSONBTNSIDE (((SCREEN_WIDTH)-(MWIDTH))/DAY)
#define SEGMENT 2
#define autoSizeScaleX SCREEN_WIDTH/375.0
#define autoSizeScaleY SCREEN_HEIGHT/667.0
#define font(R) (R)*([UIScreen mainScreen].bounds.size.width)/375.0
#define SCREEN_RATE (667/[UIScreen mainScreen].bounds.size.height)
#define ZOOM(x) x / SCREEN_RATE


#endif /* CyxbsMobileToolMacro_h */
