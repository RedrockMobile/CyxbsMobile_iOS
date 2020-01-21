//
//  QADetailViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailViewController.h"

@interface QADetailViewController ()
@property(strong,nonatomic)UIScrollView *scrollView;
@end

@implementation QADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view).mas_offset(0);
    }];
    [self setNavigationBar:@"期末考试高数应该如何复习"];
    
    // Do any additional setup after loading the view.
}
     
-(void)setNavigationBar:(NSString *)title{
    //设置标题
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    [label setFrame:CGRectMake(0, 0, SCREEN_WIDTH, NVGBARHEIGHT)];
    label.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 23], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label.alpha = 1.0;
    self.navigationItem.titleView = label;
    
    //设置返回按钮样子
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#122D55"];
    
}
-(void)setScrollView{
    //添加问题详情信息界面
    UIView *view = [[UIView alloc]init];
    
}
-(void)setViewWithDic:(NSDictionary *)dic{
    
}
@end
