//
//  TopBarScrollView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/31.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "TopBarScrollView.h"
#import "DateModle.h"
@interface TopBarScrollView()<UIScrollViewDelegate>
/**选择去某一周的条*/
@property (nonatomic,strong)UIScrollView *weekChooseBar;
/**显示本周是哪一周的条*/
@property (nonatomic,strong)UIView *nowWeekBar;
/**日期等数据的来源*/
@property (nonatomic,strong)DateModle *dateModel;
/**储存@“整学期”，@“十六周”等字符串的数组*/
@property (nonatomic,strong)NSArray <NSString*> *weekTextArray;
/**左箭头按钮*/
@property (nonatomic,strong)UIButton *leftArrowBtn;
/**在本周时的左箭头按钮*/
@property (nonatomic,strong)UIButton *nowWeekLeftArrowBtn;
/**右箭头按钮*/
@property (nonatomic,strong)UIButton *rightArrowBtn;
/**选择周的bar里面的按钮*/
@property (nonatomic,strong)NSMutableArray <UIButton*> *weekChooseBtnArray;
/**显示当前课表是第几周课表的label，@“十九周”、@“一周”、@“整学期”*/
@property (nonatomic,strong)UILabel *weekLabel;
/**当课表是本周的课表时，显示@"（本周）"的label*/
@property (nonatomic,strong)UILabel *nowWeekLabel;
/**回到本周的那个按钮*/
@property (nonatomic,strong)UIButton *backCurrentWeekBtn;
@end

@implementation TopBarScrollView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.frame = frame;
        [self setContentSize:(CGSizeMake(2*MAIN_SCREEN_W, 0))];
        self.scrollEnabled = NO;
        
        //初始化weekTextArray
        self.weekTextArray = @[@"整学期",@"一周",@"二周",@"三周",@"四周",@"五周",@"六周",@"七周",@"八周",@"九周",@"十周",@"十一周",@"十二周",@"十三周",@"十四周",@"十五周",@"十六周",@"十七周",@"十八周",@"十九周",@"二十周",@"二十一周",@"二十二周",@"二十三周",@"二十四周",@"二十五周"];
        /**
        self.weekTextArray = @[@"整学期",@"第一周",@"第二周",@"第三周",@"第四周",@"第五周",@"第六周",@"第七周",@"第八周",@"第九周",@"第十周",@"十一周",@"十二周",@"十三周",@"十四周",@"十五周",@"十六周",@"十七周",@"十八周",@"十九周",@"二十周",@"二十一周",@"二十二周",@"二十三周",@"二十四周",@"二十五周"];
        */
        
        //初始化weekChooseBtnArray
        self.weekChooseBtnArray = [NSMutableArray arrayWithCapacity:self.weekTextArray.count];
        
        //对correctIndex进行kvo，改变correctIndex就可以自动进行一系列操作
        [self addObserver:self forKeyPath:@"correctIndex" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:@"TopBarScrollView.correctIndex"];

        //添加周选择条和左箭头按钮，周选择条在self的左侧
        [self addWeekChooseBarAndLeftArrowBtn];
        
        //添加当前周信息的条（回到本周按钮就在这个条上面）,条在self的右侧
        [self addNowWeekBar];
    }
    
    return self;
}
- (DateModle *)dateModel{
    if(_dateModel==nil){
        _dateModel = [DateModle initWithStartDate:DateStart];
    }
    return _dateModel;
}
//添加周选择条和左箭头按钮，周选择条在self的左侧
- (void)addWeekChooseBarAndLeftArrowBtn{
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    self.leftArrowBtn = btn;
    [btn addTarget:self action:@selector(leftArrowBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"<" forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"左箭头"] forState:UIControlStateNormal];
//    [btn setImage:[UIImage imageNamed:@"左箭头"] forState:UIControlStateNormal];
//    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
//    btn.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.1];
    if(@available(iOS 11.0, *)){
        [btn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1] forState:UIControlStateNormal];
    }
    btn.titleLabel.font =  [UIFont fontWithName:@".PingFang SC" size: 15];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(MAIN_SCREEN_W);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
//        make.centerY.equalTo(self);
        make.width.mas_equalTo(20);
//        make.height.mas_equalTo(20);
    }];
    
    
    UIScrollView *weekChooseBar = [[UIScrollView alloc] init];
    [self addSubview:weekChooseBar];
    self.weekChooseBar = weekChooseBar;
    [weekChooseBar setContentSize:(CGSizeMake(1731, 0))];
    
    weekChooseBar.showsHorizontalScrollIndicator = NO;
    
    //添加周选择条里面全部的的某周的按钮
    [self addWeekChooseBtns];
    
//    NSLog(@"%@",[self.weekChooseBtnArray lastObject]);
    
    //添加约束
    [weekChooseBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.right.equalTo(btn.mas_left);
    }];
}

// 添加周选择条里面全部的的某周的按钮
- (void)addWeekChooseBtns{
    UIButton *firstBtn = [self getWeekChooseBtnWithTag:0];
    [self.weekChooseBar addSubview:firstBtn];
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekChooseBar).offset(0.0427*MAIN_SCREEN_W);
    }];
    UIButton *lastBtn = firstBtn;
    float distance = MAIN_SCREEN_W*0.064;
    for (int i=1; i<self.weekTextArray.count; i++) {
        UIButton *btn = [self getWeekChooseBtnWithTag:i];
        [self.weekChooseBar addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastBtn.mas_right).offset(distance);
            make.centerY.equalTo(self.weekChooseBar);
        }];
        lastBtn = btn;
    }
}
//创建一个周选择条里面的按钮，设置按钮tag为tag，按钮的标题是self.weekTextArray[tag]
//并且把btn加入self.weekChooseBtnArray
- (UIButton*)getWeekChooseBtnWithTag:(int)tag{
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:self.weekTextArray[tag] forState:UIControlStateNormal];
    btn.tag = tag;
    self.weekChooseBtnArray[tag] = btn;
    if(@available(iOS 11.0, *)){
        [btn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
    }else{
        [btn setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1] forState:UIControlStateNormal];
    }
    btn.titleLabel.font =  [UIFont fontWithName:PingFangSCRegular size: 15];
    btn.alpha = 0.81;
    [btn addTarget:self action:@selector(weekChooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}



//添加当前周信息的条（回到本周按钮就在这个条上面）,条在self的右侧
- (void)addNowWeekBar{
    UIView *nowWeekBar = [[UIScrollView alloc] init];
    self.nowWeekBar = nowWeekBar;
    [self addSubview:nowWeekBar];
    
    //添加显示本周、第七周的那个label
    [self addWeekLabel];
    [self addNowWeekLabelAndNowWeekLeftArrowBtn];
    [self addRightArrowBtn];
    [self addBackCurrentWeekBtn];
    
    //添加约束
    [nowWeekBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftArrowBtn.mas_right);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(MAIN_SCREEN_W);
    }];
    
}
//显示本周、第七周的那个label
- (void)addWeekLabel{
    //    nowWeekBar.backgroundColor = UIColor.redColor;
    //显示本周、第七周的那个label
    UILabel *weekLabel = [[UILabel alloc] init];
    [self.nowWeekBar addSubview: weekLabel];
    self.weekLabel = weekLabel;
    
    weekLabel.text = @"整学期";
//    weekLabel.font = [UIFont fontWithName:@".PingFang SC" size: 15];
    if (@available(iOS 11.0, *)) {
        weekLabel.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        weekLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    weekLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nowWeekBar).offset(MAIN_SCREEN_W*0.0427);
    }];
}


//添加当课表是本周的课表时，显示@"（本周）"的label及其旁边的右箭头按钮
- (void)addNowWeekLabelAndNowWeekLeftArrowBtn{
    UILabel *nowWeekLabel = [[UILabel alloc] init];
    [self.nowWeekBar addSubview: nowWeekLabel];
    self.nowWeekLabel = nowWeekLabel;
    
    nowWeekLabel.text = @"（本周）";
    nowWeekLabel.font = [UIFont fontWithName:@".PingFang SC" size: 15];
    if (@available(iOS 11.0, *)) {
        nowWeekLabel.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        nowWeekLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    nowWeekLabel.frame = CGRectMake(MAIN_SCREEN_W*0.2627, 0.009*MAIN_SCREEN_H, 0.12*MAIN_SCREEN_W, 0.0259*MAIN_SCREEN_H);
    
    [nowWeekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weekLabel.mas_right);
        make.bottom.equalTo(self.weekLabel);
    }];
    
}

//添加右箭头按钮
- (void)addRightArrowBtn{
    UIButton *btn = [[UIButton alloc] init];
    [self.nowWeekBar addSubview:btn];
    self.rightArrowBtn = btn;
//    UserDefaultTool
    [btn addTarget:self action:@selector(rightArrowBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@">" forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
    if (@available(iOS 11.0, *)) {
        [btn setTitleColor:[UIColor colorNamed:@"color21_49_91&#F0F0F2"] forState:UIControlStateNormal];
    } else {
        [btn setTitleColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1] forState:UIControlStateNormal];
    }
    btn.titleLabel.font =  [UIFont fontWithName:@".PingFang SC" size: 15];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nowWeekLabel.mas_right);
        make.bottom.equalTo(self.weekLabel).offset(6);
        make.width.mas_equalTo(20);
    }];
}
//添加回到本周按钮
- (void)addBackCurrentWeekBtn{
    UIButton *backBtn = [[UIButton alloc] init];
    [self.nowWeekBar addSubview:backBtn];
    self.backCurrentWeekBtn = backBtn;
    
    [backBtn setTitle:@"回到本周" forState:(UIControlStateNormal)];
    [backBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    if (@available(iOS 11.0, *)) {
        [backBtn setBackgroundColor:[UIColor colorNamed:@"enquiryBtnColor"]];
    } else {
        [backBtn setBackgroundColor:[UIColor colorWithRed:69/255.0 green:62/255.0 blue:217/255.0 alpha:1]];
    }
    backBtn.titleLabel.font = [UIFont fontWithName:@".PingFang SC" size: 13];
    backBtn.layer.cornerRadius = MAIN_SCREEN_H*0.0197;
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nowWeekBar).offset(MAIN_SCREEN_W*0.728);
//        make.bottom.equalTo(self.nowWeekBar);
        make.centerY.equalTo(self.nowWeekBar);
        make.width.mas_equalTo(0.2293*MAIN_SCREEN_W);
        make.height.mas_equalTo(0.0394*MAIN_SCREEN_H);
    }];
    

    [backBtn addTarget:self action:@selector(backCurrentWeekBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}
//MARK:-点击某按钮后调用的方法：
- (void)backCurrentWeekBtnClicked{
    if(self.dateModel.nowWeek.intValue>25){
        self.correctIndex = [NSNumber numberWithInt:0];
    }else{
        self.correctIndex = self.dateModel.nowWeek;
    }
    [self.weekChooseDelegate gotoWeekAtIndex:self.correctIndex];
}

- (void)leftArrowBtnClicked{
    [UIView animateWithDuration:0.5 animations:^{
        [self setContentOffset:(CGPointMake(MAIN_SCREEN_W, 0))];
    }];
}

- (void)rightArrowBtnClicked{
    [UIView animateWithDuration:0.5 animations:^{
        [self setContentOffset:(CGPointMake(0, 0))];
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == @"TopBarScrollView.correctIndex") {
        
        if([change[@"new"]isEqual:change[@"old"]]){
            return;
        }
        //更改旧按钮的的字体
        NSNumber *oldIndex = change[@"old"];
        UIButton *oldBtn = self.weekChooseBtnArray[oldIndex.intValue];
        oldBtn.titleLabel.font =  [UIFont fontWithName:PingFangSCRegular size: 15];
        oldBtn.alpha = 0.81;
        
        //要先改旧按钮，因为如果是第一调用，那么change[@"old"]
        //就是nil，导致oldBtn==newBtn，先改新按钮会导致新按钮的修改被旧按钮的修改覆盖
        
        //更改新按钮的的字体
        NSNumber *newIndex = change[@"new"];
        UIButton *newBtn = self.weekChooseBtnArray[newIndex.intValue];
        newBtn.titleLabel.font = [UIFont fontWithName:PingFangSCBold size: 18];
        newBtn.alpha = 1;
        
        //动画时长
        float duration = abs(newIndex.intValue-oldIndex.intValue)*0.3;
        
        //weekChooseBar的contentOffset的x会用contentOffsetX赋值
        float contentOffsetX = newBtn.center.x-0.5*MAIN_SCREEN_W;
        if(duration>0.6)duration=0.6;
        
        if(contentOffsetX < 0) contentOffsetX = 0;
        
        if(contentOffsetX > self.weekChooseBar.contentSize.width-self.weekChooseBar.frame.size.width){
            contentOffsetX = self.weekChooseBar.contentSize.width-self.weekChooseBar.frame.size.width;
        }
        
        [UIView animateWithDuration:duration animations:^{
            [self.weekChooseBar setContentOffset:CGPointMake(contentOffsetX, 0)];
        }];
        
        self.weekLabel.text = newBtn.titleLabel.text;
        if(newIndex.intValue==self.dateModel.nowWeek.intValue){
            self.nowWeekLabel.text = @"（本周）";
        }else{
            self.nowWeekLabel.text = @"";
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
- (void)dealloc{
    [self removeObserver:self forKeyPath:@"correctIndex"];
}

//周选择条的按钮点击后调用，tag=0代表是点击了整学期按钮，tag=2代表是第二周
//用tag给correctIndex赋值
- (void)weekChooseBtnClick:(UIButton*)btn{
    //改变correctIndex，随后KVO会根据correctIndex的改变完成一系列相关操作
    self.correctIndex = [NSNumber numberWithLong:btn.tag];
    //调用代理方法，告诉代理点击了哪一周的按钮，0代表整学期，17代表第十七周
    [self.weekChooseDelegate gotoWeekAtIndex:self.correctIndex];
}
//解决第一次加载课表时TopBar显示的不是nowWeekBar
- (void)layoutSubviews{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.contentOffset = CGPointMake(MAIN_SCREEN_W, 0);
    });
    UIView *lastBtn = [self.weekChooseBtnArray lastObject];
    [self.weekChooseBar setContentSize:CGSizeMake(lastBtn.frame.origin.x+lastBtn.frame.size.width, 0)];
}
@end
