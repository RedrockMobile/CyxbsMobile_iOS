//
//  SZHHotSearchView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHHotSearchView.h"
#import "SZHHotSearchButton.h"
#define SPLIT 7//item间距
#define LINESPLIT 10//行间距

@interface SZHHotSearchView()
@property (nonatomic, strong) NSArray <UIButton *>* buttonAry;
@end

@implementation SZHHotSearchView

#pragma mark- life cycle
- (instancetype)initWithString:(NSString *)string{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"SZHMainBoardColor"];
        } else {
            // Fallback on earlier versions
        }
        if ([string isEqualToString:@"热门搜索"]) {
            self.hotSearch_KnowledgeLabel.text = @"热门搜索";
        }else{
            self.hotSearch_KnowledgeLabel.text = @"重邮知识库";
        }
        [self addbutts];
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [self addSubview:self.hotSearch_KnowledgeLabel];
    //此处不需要约束宽与高，自适应
    [self.hotSearch_KnowledgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
    }];
    [self btnsAddConstraints];
}
#pragma mark- Private methods
/// 添加下面的热门搜索或者重邮知识库item
- (void)addbutts{
    if (self.buttonTextAry.count == 0) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *text in self.buttonTextAry) {
        SZHHotSearchButton *button = [[SZHHotSearchButton alloc] init];
        [button setTitle:text forState:UIControlStateNormal];   //设置btn的标题文本
        
        //判断创建的是哪一个页面，决定按钮触碰后会执行什么方法
        if ([self.hotSearch_KnowledgeLabel.text isEqualToString:@"热门搜索"]) {
            [button addTarget:self.delegate action:@selector(touchHotSearchBtnsThroughBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([self.hotSearch_KnowledgeLabel.text isEqualToString:@"重邮知识库"]){
            [button addTarget:self.delegate action:@selector(touchCQUPTKonwledgeThroughBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self addSubview:button];
        //将创建的buttons保存起来
        [array addObject:button];
    }
    self.buttonAry = array;
    
}

///为btns添加约束，让它自动换行等等
- (void)btnsAddConstraints{
    if (self.buttonAry.count == 0) return;
    __block int k = 0;
    [self.buttonAry[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(LINESPLIT);
        make.left.equalTo(self);
    }];
    __block float lastBtnW,lastBtnX;
    for (int i = 1; i < self.buttonAry.count; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self layoutIfNeeded];
            lastBtnW = self.buttonAry[i-1].frame.size.width;
            lastBtnX = self.buttonAry[i-1].frame.origin.x;
            if(lastBtnX + lastBtnW*2 > self.frame.size.width) {
                k++;
                [self.buttonAry[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(k*MAIN_SCREEN_W*0.1147+LINESPLIT);
                    make.left.equalTo(self);
                }];
            }else {
                [self.buttonAry[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(SPLIT+lastBtnW+lastBtnX);
                    make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(k*MAIN_SCREEN_W*0.1147+LINESPLIT);
                }];
            }
        });
    }
}

//更新UI
- (void)updateBtns{
    for (int i = 0; i < self.buttonAry.count; i++) {
        [self.buttonAry[i] removeFromSuperview];
    }
    [self addbutts];
    [self layoutIfNeeded];
}
#pragma mark- getter
- (UILabel *)hotSearch_KnowledgeLabel{
    if (_hotSearch_KnowledgeLabel == nil) {
        _hotSearch_KnowledgeLabel = [[UILabel alloc] init];
        _hotSearch_KnowledgeLabel.font = [UIFont fontWithName:PingFangSCMedium size:18];
        if (@available(iOS 11.0, *)) {
            _hotSearch_KnowledgeLabel.textColor = [UIColor colorNamed:@"SZHHotHistoryKnowledgeLblColor"];
        } else {
            // Fallback on earlier versions
        }
    }
    return _hotSearch_KnowledgeLabel;
}

- (NSArray *)buttonTextAry{
    if (_buttonTextAry == nil) {
//        _buttonTextAry = @[@"红岩网校",@"校庆",@"啦啦操比赛",@"话剧表演",@"奖学金",@"建模"];
    }
    return _buttonTextAry;
}


@end
