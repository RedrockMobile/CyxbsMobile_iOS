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
/// 热搜或者知识库的按钮行数。根据这个去动态设置知识库页面高度
@property (nonatomic, assign) int btnLine;
@end

@implementation SZHHotSearchView

#pragma mark- life cycle
- (instancetype)initWithString:(NSString *)string{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000001" alpha:1]];
        
        //一些初始化
        self.btnLine = 1;
        
        //根据传入的字符串初始化界面
        if ([string isEqualToString:@"热门搜索"]) {
            self.hotSearch_KnowledgeLabel.text = @"热门搜索";
        }else{
            self.hotSearch_KnowledgeLabel.text = @"邮问知识库";
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
        [button.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button).offset(MAIN_SCREEN_W * 0.03467);
            make.right.equalTo(button).offset(-MAIN_SCREEN_W * 0.03467);
        }];
        
        //判断创建的是哪一个页面，决定按钮触碰后会执行什么方法
        if ([self.hotSearch_KnowledgeLabel.text isEqualToString:@"热门搜索"]) {
            [button addTarget:self.delegate action:@selector(touchHotSearchBtnsThroughBtn:) forControlEvents:UIControlEventTouchUpInside];
        }else if ([self.hotSearch_KnowledgeLabel.text isEqualToString:@"邮问知识库"]){
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

    CGFloat splite = MAIN_SCREEN_W * 0.02;    //button之间的间距
    CGFloat lineSplite = MAIN_SCREEN_H * 0.02; //每行之间的间距

    //button位置临界值判断变量
    CGFloat positionX = originX;
    CGFloat positionY = originY;
    //最大的x值
    CGFloat maxX = MAIN_SCREEN_W;
    
    //循环设置Btn们的frame
    for (int i = 1; i < self.buttonAry.count; i++) {
        //获取button的字符串的宽度
        CGFloat titleWidth = [self.buttonAry[i].titleLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, MAIN_SCREEN_H * 0.0382) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:PingFangSCMedium size:13]} context:nil].size.width;
        
        //button宽度 = 标题的长度 + 距离两边宽度 + 边框宽度（这里改为-2）
        CGFloat buttonWidth = titleWidth + MAIN_SCREEN_W * 0.07 + 2 ;
        CGFloat buttonX = CGRectGetMaxX(self.buttonAry[i-1].frame) + splite;//button最左边的frame
        positionX = buttonX + buttonWidth ;

        //如果下一个button的x值值超越了边界，则跳行
        if (positionX > maxX) {
            self.btnLine = self.btnLine + 1; //按钮行数增加
            positionX = originX;
            buttonX = originX;
            self.buttonAry[i].frame = CGRectMake(originX, positionY, buttonWidth, MAIN_SCREEN_H * 0.0382);
            positionY = positionY + MAIN_SCREEN_H * 0.0254 + lineSplite;
        }
        self.buttonAry[i].frame = CGRectMake(buttonX, positionY, buttonWidth, MAIN_SCREEN_H * 0.0382);
    }
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
}


- (void)hideKnowledgeBtns{
    for (UIButton *btn in self.buttonAry) {
        [btn removeFromSuperview];
    }
}

//获取这个View的高都
- (CGFloat)ViewHeight{
    CGFloat viewHeight = 0;
    //获取标题的高度
    NSDictionary *attr = @{NSFontAttributeName : [UIFont fontWithName:PingFangSCBold size:18]};
    CGFloat titleHeight = [self.hotSearch_KnowledgeLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil].size.height;
    //按钮的高度
    CGFloat btnsHeight = self.btnLine * MAIN_SCREEN_H * 0.0382;
    //按钮的行距高总和
    CGFloat btnMarginHeight = (self.btnLine - 1) * MAIN_SCREEN_H * 0.02;
    
    // 标题高度 + 按钮行间距和 + 按钮本身高度 + 第一行按钮距离标题的高度 + 容错距离
    viewHeight = titleHeight + btnMarginHeight + btnsHeight + MAIN_SCREEN_H * 0.0254 + 10;
    
    return viewHeight;
}
#pragma mark- getter
- (UILabel *)hotSearch_KnowledgeLabel{
    if (_hotSearch_KnowledgeLabel == nil) {
        _hotSearch_KnowledgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _hotSearch_KnowledgeLabel.font = [UIFont fontWithName:PingFangSCBold size:18];
        if (@available(iOS 11.0, *)) {
            _hotSearch_KnowledgeLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
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
