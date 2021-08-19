//
//  TopBar.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//

#import "StampCenterTopBar.h"
#import "PrefixHeader.pch"
#import "UIView+XYView.h"
#import "ZWTMacro.h"
@implementation StampCenterTopBar

- (void)setNumber:(NSNumber *)number{
    _number = number;
    self.smallcountLbl.text = [NSString stringWithFormat:@"%@",number];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 47+STATUSBARHEIGHT);
        self.backgroundColor = [UIColor colorNamed:@"#F2F3F8"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",TOKEN] forHTTPHeaderField:@"authorization"];
        [manager GET:MAIN_PAGE_API parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            self.number = responseObject[@"data"][@"user_amount"];
        } failure:nil];
        
        _stampCenterLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.13*SCREEN_WIDTH, 9+STATUSBARHEIGHT, 88, 31)];
        _stampCenterLbl.textColor = [UIColor colorNamed:@"#15315B"];
        _stampCenterLbl.text =  @"邮票中心";
        _stampCenterLbl.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:22];
        _backButton = [[UIButton alloc]initWithFrame:CGRectMake(0.07*SCREEN_WIDTH, 16.5+STATUSBARHEIGHT, 7, 16)];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:normal];
        [_backButton addTarget:self.delegate action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        _stampCountView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH+1, _stampCenterLbl.y+2, 80, 27)];
        _stampCountView.backgroundColor = [UIColor colorNamed:@"#2B333F66"];
        _stampCountView.layer.cornerRadius = 14;
        UIImageView *barstamp = [[UIImageView alloc]initWithFrame:CGRectMake(11.7, 2.3, 21.1, 21.1)];
        barstamp.image = [UIImage imageNamed:@"barstamp"];
        _smallcountLbl = [[UILabel alloc]initWithFrame:CGRectMake(37.5, 2.3, 30.5, 22)];
        _smallcountLbl.font = [UIFont fontWithName:@"DIN-Medium" size:18.7];
        _smallcountLbl.textColor = [UIColor whiteColor];
        _smallcountLbl.text = @"123";
        [_stampCountView addSubview:barstamp];
        [_stampCountView addSubview:_smallcountLbl];
        
        [self addSubview:_stampCountView];
        [self addSubview:_backButton];
        [self addSubview:_stampCenterLbl];
    }
    return self;
}

@end
