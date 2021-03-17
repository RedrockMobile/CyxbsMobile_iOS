//
//  SZHHotSearchView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/1/26.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "SZHHotSearchView.h"
#import "SZHHotSearchButton.h"

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
        
        //添加到屏幕上面
        [self addSubview:self.hotSearch_KnowledgeLabel];
        //此处不需要约束宽与高，自适应
        [self.hotSearch_KnowledgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self);
        }];
        
        //添加按钮
        [self addbutts];
    }
    return self;
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
    [self btnsAddConstraints];
}

///为btns添加约束，让它自动换行等等
- (void)btnsAddConstraints{
    if (self.buttonAry.count == 0){
        return;
    }
    [self.buttonAry[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(MAIN_SCREEN_H * 0.0254);
        make.left.equalTo(self);
        make.height.mas_equalTo(MAIN_SCREEN_H * 0.0382);
    }];
    //立即得到masonry约束后的button的Frame，不用等到下一个runloop周期
    [self layoutIfNeeded];
    //初始的X、Y值
    CGFloat originX = self.buttonAry[0].frame.origin.x;
    CGFloat originY = self.buttonAry[0].frame.origin.y;

    CGFloat splite = MAIN_SCREEN_W * 0.0334;    //button之间的间距
    CGFloat lineSplite = MAIN_SCREEN_H * 0.02; //每行之间的间距

    //button位置临界值判断变量
    CGFloat positionX = originX;
    CGFloat positionY = originY;

    CGFloat maxX = MAIN_SCREEN_W;   //最大的x值
    CGFloat maxY = MAIN_SCREEN_H * 0.1874;  //最大的Y值

    for (int i = 1; i < self.buttonAry.count; i++) {
        //获取button的字符串的宽度
        CGFloat titleWidth = [self.buttonAry[i].titleLabel.text boundingRectWithSize:CGSizeMake(1000, MAIN_SCREEN_H * 0.0382) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PingFangSCMedium size:13]} context:nil].size.width;
        //button宽度 = 字符串长度 + 两边的间隔
        CGFloat buttonWidth = titleWidth + MAIN_SCREEN_W * 0.0666;
        CGFloat buttonX = CGRectGetMaxX(self.buttonAry[i-1].frame) + splite;
        positionX = buttonX + buttonWidth;

        //如果下一个button的x值值超越了边界，则跳行
        if (positionX > maxX) {
            positionX = originX;
            buttonX = originX;
            positionY = positionY + MAIN_SCREEN_H * 0.0254 + lineSplite;
        }

        //如果重邮知识库的buttton数量过多，超过长度，则不再显示后面的
        if (positionY - originY > maxY - CGRectGetMaxY(self.hotSearch_KnowledgeLabel.frame)) {
            break;
        }
        self.buttonAry[i].frame = CGRectMake(buttonX, positionY, buttonWidth, MAIN_SCREEN_H * 0.0382);
    }
    
//    __block int k = 0;

//    __block float lastBtnW,lastBtnX;
//    for (int i = 1; i < self.buttonAry.count; i++) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self layoutIfNeeded];
//            lastBtnW = self.buttonAry[i-1].frame.size.width;
//            lastBtnX = self.buttonAry[i-1].frame.origin.x;
//            if(lastBtnX + lastBtnW*2 > self.frame.size.width) {
//                k++;
//                [self.buttonAry[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(k*MAIN_SCREEN_W*0.1147 + LINESPLIT);
//                    make.left.equalTo(self);
//                }];
//            }else {
//                [self.buttonAry[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(self).offset(SPLIT+lastBtnW+lastBtnX);
//                    make.top.equalTo(self.hotSearch_KnowledgeLabel.mas_bottom).offset(k*MAIN_SCREEN_W*0.1147 + LINESPLIT);
//                }];
//            }
//        });
//    }
}

//更新UI
- (void)updateBtns{
    if (self.buttonTextAry.count == 0) {
        return;
    }
    for (int i = 0; i < self.buttonAry.count; i++) {
        [self.buttonAry[i] removeFromSuperview];
    }
    [self addbutts];
//    [self layoutIfNeeded];
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
    }
    return _buttonTextAry;
}


@end
