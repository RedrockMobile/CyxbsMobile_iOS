//
//  SchedulForOneWeekController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "SchedulForOneWeekController.h"
#import "WYCClassBookView.h"

@interface SchedulForOneWeekController ()
@property (nonatomic,copy)NSDictionary *urlDict;
@end

@implementation SchedulForOneWeekController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化url字典
    self.urlDict = @{
        @"stuUrl":@"https://cyxbsmobile.redrock.team/api/kebiao",
        @"teaUrl":@"https://cyxbsmobile.redrock.team/wxapi/magipoke-teaKb/api/teaKb"
    };
    
}

/**num：学号/工号。type：枚举类型，被查者身份。返回值代表是否加载成功*/
- (BOOL)loadSchedulWithNum:(NSString *)num ForPeopleType:(PeopleType)type{
    NSDictionary *parameters = @{@"stu_num":num};
    NSString *url;
    
    //根据参数type来确定是查老师还是查学生
    if(type==PeopleTypeStudent){
        url = self.urlDict[@"stuUrl"];
    }else{
        url = self.urlDict[@"teaUrl"];
    }
    
    //这边利用了指针来知道是否请求成功（不确定这样做是否可行）
    BOOL isSuccess;
    BOOL *Pis = &isSuccess;
    [[HttpClient defaultClient] requestWithPath:url method:HttpRequestPost parameters:parameters prepareExecute:nil progress:^(NSProgress *progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray *lessonArray = [responseObject objectForKey:@"data"];
        [self loadSchedulWithSchedulArray:[lessonArray mutableCopy]];
        *Pis = YES;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"加载失败";
        [hud hide:YES afterDelay:1];
        *Pis = NO;
    }];
    
    return *Pis;
}

/**array：一周的7天的课表数据*/
- (void)loadSchedulWithSchedulArray:(NSMutableArray*)array{
    WYCClassBookView *view = [[WYCClassBookView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    
    [view initView:YES];
    [view addBar:[self riQi7] isFirst:YES];
    [view addBtn:array];
    for (UIView* v in view.scrollView.subviews) {
        [v setValue:@"NO" forKeyPath:@"userInteractionEnabled"];
    }
    [self.view addSubview:view];
}

/**返回7天的课表(因为服务器崩了，所以这个方法的返回值用来获得一个7天的课表数据)*/
- (NSMutableArray*)keBiao7{
    return [@[
            //周一
            @[
                @[
                    @{
                        @"classroom" : @3102,
                        @"course" : @"高等数学（下）",
                        @"hash_day" : @0,
                        @"hash_lesson" : @0,
                        @"period" : @2,
                    }
                ],
                @[
                    @{
                        @"classroom" : @4204,
                        @"course" : @"大学英语",
                        @"hash_day" : @0,
                        @"hash_lesson" : @1,
                        @"period" : @2,
                    }
                ],
                @[],
                @[
                    @{
                        @"classroom" : @3505,
                        @"course" :@"古诗词鉴赏",
                        @"hash_day" : @0,
                        @"hash_lesson" : @3,
                        @"period" : @2,
                    }
                ],
                @[],
                @[]
        ],
            //周二
            @[
                @[
                    @{
                        @"classroom" : @2217,
                        @"course" : @"大学物理",
                        @"hash_day" : @1,
                        @"hash_lesson" : @0,
                        @"period" : @2,
                    }
                ],
                @[],
                @[
                    @{
                        @"classroom" : @3301,
                        @"course" : @"离散数学",
                        @"hash_day" : @1,
                        @"hash_lesson" : @2,
                        @"period" : @2,
                    }
        ],
                @[],
                @[
                    @{
                        @"classroom" : @4206,
                        @"course" :@"思政实践",
                        @"hash_day" : @1,
                        @"hash_lesson" : @4,
                        @"period" : @2,
                    }
                ],
                @[]
            ],
            //周三
            @[
                    @[
                        @{
                            @"classroom" : @4204,
                            @"course" : @"大学英语",
                            @"hash_day" : @2,
                            @"hash_lesson" : @0,
                            @"period" : @2,
                        }
                    ],
                    @[
                        @{
                            @"classroom" : @3211,
                            @"course" : @"形势与政策",
                            @"hash_day" : @2,
                            @"hash_lesson" : @1,
                            @"period" : @2,
                        }
                    ],
                    @[],
                    @[
                        @{
                            @"classroom" : @5200,
                            @"course" :@"高等数学",
                            @"hash_day" : @2,
                            @"hash_lesson" : @3,
                            @"period" : @2,
                        }
                    ],
                    @[],
                    @[]
            ],
            //周四
            @[
                    @[
                        @{
                            @"classroom" : @3301,
                            @"course" : @"离散数学",
                            @"hash_day" : @3,
                            @"hash_lesson" : @0,
                            @"period" : @2,
                        }
                    ],
                    @[
                        @{
                            @"classroom" : @4205,
                            @"course" : @"C语言",
                            @"hash_day" : @3,
                            @"hash_lesson" : @1,
                            @"period" : @2,
                        }
                    ],
                    @[
                        @{
                            @"classroom" : @3505,
                            @"course" :@"大学体育",
                            @"hash_day" : @3,
                            @"hash_lesson" : @2,
                            @"period" : @2,
                        }
                    ],
                    @[],
                    @[
                        @{
                            @"classroom" : @3505,
                            @"course" :@"中国近代史纲要",
                            @"hash_day" : @3,
                            @"hash_lesson" : @4,
                            @"period" : @3,
                        }
                    ],
                    @[],
            ],
            //周五
            @[
                @[
                    @{
                        @"classroom" : @2217,
                        @"course" : @"高等数学",
                        @"hash_day" : @4,
                        @"hash_lesson" : @1,
                        @"period" : @2,
                    }
            ],
                @[],
                @[
                    @{
                        @"classroom" : @3301,
                        @"course" : @"大学物理",
                        @"hash_day" : @4,
                        @"hash_lesson" : @2,
                        @"period" : @2
                    }
        ],
                @[],
                @[],
                @[]
                ],
            //周六
            @[
                @[],
                @[],
                @[],
                @[],
                @[],
                @[],
            ],
            //周日
            @[
                @[],
                @[],
                @[],
                @[],
                @[],
                @[],
            ],
    ]mutableCopy];
}

/**返回7天的日期(服务器崩了，所以这个方法的返回值用来代替服务器返回的数据)*/
- (NSArray*)riQi7{
    return @[
        @{@"day":@"11",@"month":@"2"},
        @{@"day":@"12",@"month":@"2"},
        @{@"day":@"13",@"month":@"2"},
        @{@"day":@"14",@"month":@"2"},
        @{@"day":@"15",@"month":@"2"},
        @{@"day":@"16",@"month":@"2"},
        @{@"day":@"17",@"month":@"2"},
    ];
}

@end
