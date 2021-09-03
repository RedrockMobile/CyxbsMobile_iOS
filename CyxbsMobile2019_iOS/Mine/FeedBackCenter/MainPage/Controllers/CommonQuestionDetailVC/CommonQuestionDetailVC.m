//
//  CommonQuestionDetailVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "CommonQuestionDetailVC.h"
#import "CommonQuestionData.h"
@interface CommonQuestionDetailVC ()

@end

@implementation CommonQuestionDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupBar];
    [self.view addSubview:self.testLbl];
    
}
#pragma mark - setter
- (void)setCommonQuestionAry:(NSArray *)CommonQuestionAry{
    _CommonQuestionAry = CommonQuestionAry;
    CommonQuestionData *data = _CommonQuestionAry[self.row];
    self.VCTitleStr = data.title;
    self.testLbl.text = data.content;
}

#pragma mark - getter
- (UILabel *)testLbl{
    if (!_testLbl) {
        _testLbl = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 300, 100)];
    }
    return _testLbl;
}
#pragma mark - 私有方法
- (void)setupBar{
    self.view.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.VCTitleStr = @"";
    self.topBarView.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.splitLineColor = [UIColor systemGray5Color];
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:21];
}

- (instancetype)initWithIndexPathRow:(NSInteger)row{
    if (self = [super init]) {
        self.row = row;
    }
    return self;
}

- (void)setupData{
    [CommonQuestionData CommonQuestionDataWithSuccess:^(NSArray * _Nonnull array) {
        self.CommonQuestionAry = array;
        } error:^{
            
        }];
}
@end
