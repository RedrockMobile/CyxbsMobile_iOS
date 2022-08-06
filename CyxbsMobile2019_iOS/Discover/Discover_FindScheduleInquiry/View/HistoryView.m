//
//  HistoryView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "HistoryView.h"
#import "HistoryCell.h"
#import "DLTimeSelectedButton.h"
///item间距
#define SPLIT 7
///行间距
#define LINESPLIT 10
/**最多九条历史记录*/
#define MAXLEN 9
@interface HistoryView()<DLTimeSelectedButtonDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong)UIButton *clearHistoryItemBtn;
@property (nonatomic, strong)UILabel *historyLabel;

// 历史记录
@property (nonatomic, strong) UICollectionView *historyCollectionView;
// 我的关联
@property (nonatomic, strong) UILabel *myCorrelation;
@property (nonatomic, strong) UILabel *correlationNumberLabel;
@property (nonatomic, strong) UIButton *correlationBtn;
@property (nonatomic, strong) UIImageView *correlationBackground;// 背景
@property (nonatomic, strong) UIImageView *correlationLine;// 分隔线
@property (nonatomic, strong) UIButton *clearCorrelationBtn;// 清除关联

@end

@implementation HistoryView
- (instancetype)initWithUserDefaultKey:(NSString*)key
{
    self = [super init];
    if (self) {
        self.buttonArray = [[NSMutableArray alloc] init];
        self.UserDefaultKey = key;
        
        // 添加显示“历史记录”四个字的label
        [self addHistoryLabel];
        // 添加清除历史记录的按钮
        [self addClearHistoryItemBtn];
        
        [self addHistoryBtnsFromUserDefaults];
        
        [self historyBtnAddConstraints];
        
        // 添加显示“我的关联”
        [self addMyCorrelationLabel];
        // (?/1)
        [self addCorrelationNumberLabel];
        [self addCorrelationPictures];  // 底图
        [self addClearCorrelationBtn];  // 清除按钮
        [self addSeperateLine];         // 分割线
        [self addPeoplePicture];        // 小人
        [self addCorrelationCentureLabel];// label
        [self addCorrelationName];      // name
        [self addCorrelationMajor];     // major
        [self addCorrelationNumber];    // number
        // 关联块布局
        [self correlationPosition];
    }
    return self;
}
#pragma mark - 历史记录
- (void)addHistoryBtnsFromUserDefaults{
    self.dataArray = [[NSUserDefaults.standardUserDefaults objectForKey:self.UserDefaultKey] mutableCopy];
    if(self.dataArray==nil){
        self.dataArray = [[NSMutableArray alloc] init];
        [NSUserDefaults.standardUserDefaults setObject:self.dataArray forKey:self.UserDefaultKey];
    }
    
    for (NSString *text in self.dataArray) {
        DLTimeSelectedButton *button = [[DLTimeSelectedButton alloc]init];
        
        button.delegate = self;
        
        [button setTitle:text forState:UIControlStateNormal];
        
        [button addTarget:self.btnClickedDelegate action:@selector(touchHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
        
        [self.buttonArray addObject:button];
    }
    
    
}

- (void)historyBtnAddConstraints{
    if(self.buttonArray.count==0)return;
    __block int k = 0;
    [self.buttonArray[0] mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.historyLabel.mas_bottom).offset(LINESPLIT);
            make.left.equalTo(self);
    }];
    __block float lastBtnW,lastBtnX;
    for (int i = 1; i < self.buttonArray.count; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self layoutIfNeeded];
            lastBtnW = self.buttonArray[i-1].frame.size.width;
            lastBtnX = self.buttonArray[i-1].frame.origin.x;
            if(lastBtnX + lastBtnW*2 > self.width) {
                k++;
                [self.buttonArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.historyLabel.mas_bottom).offset(k*MAIN_SCREEN_W*0.1147+LINESPLIT);
                    make.left.equalTo(self);
                }];
            }else {
                [self.buttonArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(SPLIT+lastBtnW+lastBtnX);
                    make.top.equalTo(self.historyLabel.mas_bottom).offset(k*MAIN_SCREEN_W*0.1147+LINESPLIT);
                }];
            }
            });
    }
    // 我的关联重新布局
    [self correlationPosition];
}

- (void)addHistoryBtnWithString:(NSString*)string reLayout:(BOOL)is{
    if([string isEqualToString:[self.dataArray firstObject]]){return;}
    
    DLTimeSelectedButton *btn = [[DLTimeSelectedButton alloc]init];
    [btn setTitle:string forState:UIControlStateNormal];
    [btn addTarget:self.btnClickedDelegate action:@selector(touchHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
    btn.delegate = self;
    
    for (int i=0; i<self.buttonArray.count; i++) {
        if([self.buttonArray[i].titleLabel.text isEqualToString:string]){
            [self.buttonArray removeObject:self.buttonArray[i]];
            [self.dataArray removeObject:string];
            break;
        }
    }
    [self.buttonArray insertObject:btn atIndex:0];
    [self.dataArray insertObject:string atIndex:0];
    
    if(self.buttonArray.count>MAXLEN){
        UIButton *lastBtn = [self.buttonArray lastObject];
        [lastBtn removeFromSuperview];
        [self.dataArray removeLastObject];
        [self.buttonArray removeLastObject];
    }
    
    btn.frame = CGRectMake(-100, 0, 0, 0);
    [self addSubview:btn];
    
    if(is==YES){
        [self historyBtnAddConstraints];
    }
    //储存搜索记录
    [self write:string intoDataArrayWithUserDefaultKey:self.UserDefaultKey];
    self.clearHistoryItemBtn.enabled = YES;
}

- (void)deleteButtonWithBtn:(UIButton *)btn{
    [self.buttonArray removeObject:btn];
    [self.dataArray removeObject:btn.titleLabel.text];
    [self remove:btn.titleLabel.text fromDataArrayWithUserDefaultKey:self.UserDefaultKey];
    [btn removeFromSuperview];
    [self historyBtnAddConstraints];
    if(self.buttonArray.count==0){
        self.clearHistoryItemBtn.enabled = NO;
    }
    [self correlationPosition];
}
// 添加显示“历史记录”四个字的label
- (void)addHistoryLabel {
    UILabel *label = [[UILabel alloc]init];
    self.historyLabel = label;
    label.text = @"历史记录";
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    label.font = [UIFont fontWithName:PingFangSCBold size:15];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
    }];
}

// 添加清除历史记录的按钮
- (void)addClearHistoryItemBtn{
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    self.clearHistoryItemBtn = btn;
    [btn setBackgroundImage:[UIImage imageNamed:@"草稿箱垃圾桶"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearHistoryItemBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    // 拿到存放历史记录的缓存数组
    NSArray *array = [NSUserDefaults.standardUserDefaults objectForKey:self.UserDefaultKey];
    // 如果没有历史记录，那就让按钮失效
    if(array.count==0)btn.enabled = NO;
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.historyLabel);
        make.centerX.equalTo(self).offset(0.4307*MAIN_SCREEN_W);
        make.width.height.mas_equalTo(0.0533*MAIN_SCREEN_W);
        make.height.mas_equalTo(0.05931*MAIN_SCREEN_W);
    }];
}

// 把str写入key对应的那个缓存数组，再把数组放回去（在原有缓存里加上str），实现记录搜索记录的方法
- (void)write:(NSString*)str intoDataArrayWithUserDefaultKey:(NSString*)key{
    
    // 写入缓存
    // 这里取出的是一个数组，内部是部分搜索历史记录，从缓存取出来后要mutableCopy一下，不然会崩
    NSMutableArray *array = [[NSUserDefaults.standardUserDefaults objectForKey:key] mutableCopy];
    
    // 现在array不可能是nil
    
    // 判断是否和以前的搜索内容一样，如果一样就移除旧的历史记录
    for (NSString *historyStr in array) {
        if ([historyStr isEqualToString:str]) {
            [array removeObject:str];
            break;
        }
    }
    
    // 加到数组的第一个，这样可以把最新的历史记录显示在最上面
    [array insertObject:str atIndex:0];

    // 限制最多缓存MAXLEN个历史记录
    if(array.count>MAXLEN){
        [array removeLastObject];
    }
    
    // 加上重新放回去
    [NSUserDefaults.standardUserDefaults setObject:array forKey:key];
}

- (void)remove:(NSString*)str fromDataArrayWithUserDefaultKey:(NSString*)key{
    
    
    NSMutableArray *array = [[NSUserDefaults.standardUserDefaults objectForKey:key] mutableCopy];
    
    [array removeObject:str];
    [NSUserDefaults.standardUserDefaults setObject:array forKey:key];
}

// 点击清除历史记录按钮后调用
- (void)clearHistoryItemBtnClicked{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"删除搜索记录" message:@"是否确定删除记录" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    
    UIAlertAction *deleteAC = [UIAlertAction actionWithTitle:@"删除" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
        
        //1.从缓存去除记录
        [NSUserDefaults.standardUserDefaults setObject:[@[] mutableCopy] forKey:self.UserDefaultKey];
        
        //2.去除控件上的记录
        [self removeHistoryBtn];
        
        //3.让按钮取消失效
        self.clearHistoryItemBtn.enabled = NO;
        
        //4.我的关联重新布局
        [self correlationPosition];
    }];
    
    [ac addAction:deleteAC];
    [ac addAction:cancelAC];
    
    [self.viewController presentViewController:ac animated:YES completion:nil];
}

// 清空历史记录
- (void)removeHistoryBtn{
    for (int i=0; i<self.buttonArray.count; i++) {
        [self.buttonArray[i] removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    [self.dataArray removeAllObjects];
}

#pragma mark - 历史记录collectionview

- (UICollectionView *)historyCollectionView {
    if (!_historyCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = LINESPLIT;  // item间距
        layout.minimumInteritemSpacing = SPLIT; // 行间距
        _historyCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, self.size.height) collectionViewLayout:layout];
        _historyCollectionView.backgroundColor = [UIColor systemGrayColor];
        _historyCollectionView.delegate = self;
        _historyCollectionView.dataSource = self;
        [_historyCollectionView registerClass:[HistoryCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _historyCollectionView;
}

#pragma mark - 历史记录Delegate
// section组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

// item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 9;
    return self.buttonArray.count;
}

#pragma mark - 我的关联
// 显示"我的关联"Label
- (void)addMyCorrelationLabel {
    UILabel *label = [[UILabel alloc] init];
    self.myCorrelation = label;
    label.text = @"我的关联";
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    label.font = [UIFont fontWithName:PingFangSCBold size:15];
    
    [self addSubview:label];
}

// label（0/1）
- (void)addCorrelationNumberLabel {
    UILabel *label = [[UILabel alloc] init];
    self.correlationNumberLabel = label;
    NSString *number = [NSString new];
    // 1.如果有一位关联，nsuserDefault数为1，显示1/1
    if ([NSUserDefaults.standardUserDefaults boolForKey:ClassSchedule_correlationClass_BOOL]) {
        number = @"1";
    }
    // 2.如果没有关联，nsuserDefault为0，显示0/0
    else {
        number = @"0";
    }
    label.text = [NSString stringWithFormat:@"（%@/1）",number];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#142C52" alpha:0.4] darkColor:[UIColor colorWithHexString:@"#F0F0F0" alpha:0.55]];
    } else {
        label.textColor = [UIColor colorWithHexString:@"#142C52" alpha:0.4];
    }
    label.font = [UIFont fontWithName:PingFangSC size:11];
    
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myCorrelation.mas_right).mas_offset(2);
        make.centerY.equalTo(self.myCorrelation);
    }];
    
}

// 分隔线
- (void)addSeperateLine {
    UIImageView *imgLine = [[UIImageView alloc] init];
    self.correlationLine = imgLine;
    imgLine.image = [UIImage imageNamed:@"Rectangle 69"];
        // 加载视图
    [self addSubview:imgLine];
    [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.correlationBackground.mas_left).mas_offset(58);
        make.centerY.equalTo(self.correlationBackground);
        make.width.mas_equalTo(1);
    }];
}

//没有关联同学Label
- (void)addCorrelationCentureLabel {
    UILabel *label = [[UILabel alloc] init];
    self.noLabel = label;
    label.text = @"\t还没有关联同学哦\n搜索同学添加关联关系吧！";
    label.numberOfLines = 0;
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#142C52" alpha:0.4] darkColor:[UIColor colorWithHexString:@"#F0F0F0" alpha:0.55]];
    } else {
        label.textColor = [UIColor colorWithHexString:@"#142C52" alpha:0.4];
    }
    label.font = [UIFont fontWithName:PingFangSC size:12];
    
    // 如果无关联，则加载
    if (![NSUserDefaults.standardUserDefaults boolForKey:ClassSchedule_correlationClass_BOOL]) {
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.correlationLine).mas_offset(70);
            make.centerY.equalTo(self.correlationLine);
        }];
    }
}

// 人
- (void)addPeoplePicture {
    UIImageView *imgPeople = [[UIImageView alloc] init];
    self.correlationPeople = imgPeople;
    if (![NSUserDefaults.standardUserDefaults boolForKey:ClassSchedule_correlationClass_BOOL]) {
        imgPeople.image = [UIImage imageNamed:@"addPeopleClass"];
    }
    else {
        imgPeople.image = [UIImage imageNamed:@"addPeopleClass_selected"];
    }
    [self addSubview:imgPeople];
    [imgPeople mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.correlationBackground).mas_offset(18);
        make.top.equalTo(self.correlationBackground).mas_offset(31);
        make.right.equalTo(self.correlationLine).mas_offset(-17);
        make.bottom.equalTo(self.correlationBackground).mas_offset(-31);
    }];
}

// 背景图片
- (void)addCorrelationPictures {
    UIImageView *imgView = [[UIImageView alloc] init];
    self.correlationBackground = imgView;
    imgView.image = [UIImage imageNamed:@"Rectangle 12"];
        // 加载视图
    [self addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myCorrelation.mas_bottom).mas_offset(9);
        make.left.equalTo(self.myCorrelation);
    }];
}

// 添加清除关联按钮
- (void)addClearCorrelationBtn {
    UIButton *btn = [[UIButton alloc] init];
    self.clearCorrelationBtn = btn;
    [btn setBackgroundImage:[UIImage imageNamed:@"clearCorrelation"] forState:UIControlStateNormal];
    // 1.如果没有关联同学，不显示
    if (![NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationClass_BOOL]) {
        NSLog(@"没有关联同学");
    }
    // 2.如果有关联同学
    else {
        // 2.1 加入视图
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.correlationBackground.mas_top).mas_offset(-11);
            make.right.equalTo(self.correlationBackground);
        }];
        // 2.2 点击按钮清除
        [btn addTarget:self action:@selector(clearCorrelationPeople) forControlEvents:UIControlEventTouchUpInside];
    }
}

// 名字
- (void)addCorrelationName {
    if ([NSUserDefaults.standardUserDefaults boolForKey:ClassSchedule_correlationClass_BOOL]) {
        UILabel *label = [[UILabel alloc] init];
        self.correlationName = label;
        label.text = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationName_String];
        
        if (@available(iOS 11.0, *)) {
            label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C54" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F0" alpha:1]];
        } else {
            label.textColor = [UIColor colorWithHexString:@"#112C54" alpha:1];
        }
        label.font = [UIFont fontWithName:PingFangSCBold size:13];
        
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.correlationLine).mas_offset(18);
            make.top.equalTo(self.correlationBackground.mas_top).mas_offset(14);
        }];
    }
}

// 专业
- (void)addCorrelationMajor {
    if ([NSUserDefaults.standardUserDefaults boolForKey:ClassSchedule_correlationClass_BOOL]) {
        UILabel *label = [[UILabel alloc] init];
        self.correlationMajor = label;
        label.text = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationMajor_String];
        if (@available(iOS 11.0, *)) {
            label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#112C54" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F0" alpha:1]];
        } else {
            label.textColor = [UIColor colorWithHexString:@"#112C54" alpha:1];
        }
        label.font = [UIFont fontWithName:PingFangSC size:12];
        
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.correlationName);
            make.top.equalTo(self.correlationName.mas_bottom).mas_offset(4);
        }];
    }
}

// 学号
- (void)addCorrelationNumber {
    if ([NSUserDefaults.standardUserDefaults boolForKey:ClassSchedule_correlationClass_BOOL]) {
        UILabel *label = [[UILabel alloc] init];
        self.correlationNumber = label;
        label.text = [NSUserDefaults.standardUserDefaults objectForKey:ClassSchedule_correlationStuNum_String];
        if (@available(iOS 11.0, *)) {
            label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F0" alpha:0.7]];
        } else {
            label.textColor = [UIColor colorWithHexString:@"#2A4E84" alpha:1];
        }
        label.font = [UIFont fontWithName:PingFangSC size:10];
        
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.correlationName);
            make.top.equalTo(self.correlationMajor.mas_bottom).mas_offset(4);
        }];
    }
}

// 我的关联布局，要动态变化
- (void)correlationPosition {
    if (self.dataArray.count == 0) {
        [self.myCorrelation mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).mas_offset(31);
        }];
    }
    else{
        UIButton *lastBtn = [self.buttonArray lastObject];
        [self.myCorrelation mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(lastBtn.mas_bottom).mas_offset(31);
        }];
    }
    
}

// 清除
- (void)clearCorrelationPeople {
    [NSUserDefaults.standardUserDefaults setBool:NO forKey:ClassSchedule_correlationClass_BOOL];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:ClassSchedule_correlationName_String];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:ClassSchedule_correlationMajor_String];
    [NSUserDefaults.standardUserDefaults removeObjectForKey:ClassSchedule_correlationStuNum_String];
}


@end
