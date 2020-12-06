//
//  QueryViewController.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 05/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#pragma mark -志愿部分新版（网络相关内容未写完，先不发版，和邮问迭代一起上线）

#import "QueryHeader.h"
#import "QueryViewController.h"
#import "QueryTableViewCell.h"
#import "QueryLoginViewController.h"
#import "AllYearsViewController.h"
#import "MineViewController.h"
#import "HeaderGifRefresh.h"
#import "VolunteerItem.h"
#import "NoLoginView.h"
//#import "LoginViewController.h"
#import "DiscoverViewController.h"
#import "VolunteerInfoView.h"
#import "MGDSliderBar.h"
#import "segmentTableViewCell.h"
#import "GestureTableView.h"
#import "ActivityView.h"
#import "YearTableViewCell.h"
#import "LogOutView.h"
#import "VolunteerUnbinding.h"

#define SLIDERHEIGHT 49

@interface QueryViewController() <UITableViewDelegate,UITableViewDataSource,segmentTableViewCellDelegate,UIPickerViewDelegate,UIPickerViewDataSource,LogOutViewDelegate>

@property (nonatomic, strong) GestureTableView *tableView;
@property (nonatomic, strong) MGDSliderBar *sliderView;
@property (nonatomic, strong) segmentTableViewCell *segmentCell;
@property (nonatomic, strong) ActivityView *activityDetailView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) LogOutView *popView;
@property (nonatomic, strong) NSArray *yearArray;
@property (strong, nonatomic) NSArray<VolunteeringEventItem *> *eventsSortedByYears;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *index;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) AllYearsViewController *vc;

@end

@implementation QueryViewController


- (instancetype)initWithVolunteerItem: (VolunteerItem *)volunteer {
    self = [self init];
    self.volunteer = volunteer;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    _tableView=[[GestureTableView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.0837, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];//group/plain都可
    _tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.layer.cornerRadius = 16;
    _tableView.sectionFooterHeight=0;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _yearArray = [self GetYearArray];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.47;
    UITapGestureRecognizer *disAppearRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disAppearClick:)];
    [self.backView addGestureRecognizer:disAppearRecognizer];
    [self setNavigationBar];
    [self buildHeadView];
    self.canScroll = YES;

    ///点击志愿活动列表的cell
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BuildActivityDetailView:) name:@"ClickedActivityCell" object:nil];

    ///segmentViewCell离开顶部
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];

    ///点击了年份选择
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YearChooseBtnClicked) name:@"YearChoose" object:nil];
}

///点击志愿活动列表的cell，TimeTableViewController传入相关信息的字典，再在popView上展示，添加两个手势，一个消失，一个空
- (void)BuildActivityDetailView:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    ActivityView *activityDetailView = [[ActivityView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    activityDetailView.activityLabel.text = dic[@"Activity"];
    activityDetailView.describeLabel.text = dic[@"describe"];
    activityDetailView.signUpTime.text = dic[@"signUpTime"];
    activityDetailView.activityTime.text = dic[@"activityTime"];
    activityDetailView.activityHour.text = dic[@"activityHour"];
    UITapGestureRecognizer *tapRecognizer= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doClick:)];
    UITapGestureRecognizer *emptyRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emptyClicked:)];
    [activityDetailView.backView addGestureRecognizer:tapRecognizer];
    [activityDetailView.popView addGestureRecognizer:emptyRecognizer];
    [self.view addSubview:activityDetailView];
    _activityDetailView = activityDetailView;
}

///志愿活动详情popView消失手势
- (void)doClick:(UITapGestureRecognizer *)sender{
    [_activityDetailView removeFromSuperview];
}

///空手势（点击志愿活动详情popView无反应）
- (void)emptyClicked:(UITapGestureRecognizer *)sender{

}

- (void)disAppearClick:(UITapGestureRecognizer *)sender{
    [_backView removeFromSuperview];
    [_pickerView removeFromSuperview];
}

///获取五年的年份数组
- (NSArray *)GetYearArray {
    NSMutableArray *yearArray = [NSMutableArray new];
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    for (int i = 3;i >= 0; i--) {
        [yearArray addObject:[NSString stringWithFormat:@"%ld",(long)(currentYear  - i)]];
    }
    [[yearArray reverseObjectEnumerator] allObjects];
    [yearArray addObject:@"全部"];
    return [yearArray copy];
}

///设置顶部NavigationBar
- (void)setNavigationBar {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"密码返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    ///bar标题
    UILabel *barTitle = [self creatLabelWithText:@"志愿查询" AndFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 21] AndTextColor:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]];
    barTitle.textAlignment = NSTextAlignmentLeft;
    barTitle.backgroundColor = [UIColor clearColor];
    barTitle.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    [self.view addSubview:barTitle];

    UIButton *logOutBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [logOutBtn setBackgroundColor:[UIColor clearColor]];
    [logOutBtn setTitle:@"切换绑定" forState:UIControlStateNormal];
    logOutBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 11];
    [logOutBtn setTintColor:[UIColor colorWithRed:21.0/255.0 green:49.0/255.0 blue:91.0/255.0 alpha:1.0]];
    [logOutBtn addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutBtn];

    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(SCREEN_HEIGHT * 0.0556);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH * 0.0453);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.024);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0229);
    }];

    [barTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(SCREEN_HEIGHT * 0.048);
        make.left.mas_equalTo(backBtn.mas_right).mas_offset(SCREEN_WIDTH * 0.0293);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0357);
    }];

    [logOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(SCREEN_HEIGHT * 0.0554);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH * 0.8187);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.12);
        make.height.mas_equalTo(SCREEN_HEIGHT * 0.0197);
    }];

}

///解除绑定的点击事件
- (void)logOut {
    LogOutView *popView = [[LogOutView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    popView.delegate = self;
    [self.view addSubview:popView];
    _popView = popView;
}

///设置列表头视图（志愿的志愿时长和次数的infoView）
- (void)buildHeadView {
    [self.view addSubview:self.tableView];
    VolunteerInfoView *headView = [[VolunteerInfoView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.1108)];
    headView.totalText.text = self.volunteer.hour;
    headView.frequencyText.text = self.volunteer.count;
    _tableView.tableHeaderView = headView;

}
///返回点击事件
- (void)backButtonClicked {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

///配置可滑动的属性
- (void)changeScrollStatus{
    self.canScroll = YES;
    self.segmentCell.objectCanScroll = NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==0) {//第一cell

        }else{//第二cell

        }
    }
}


#pragma mark ——————————UIScrollViewDelegate——————————
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {

        CGFloat bottomCellOffset = [self.tableView rectForSection:1].origin.y;
        bottomCellOffset = floorf(bottomCellOffset);

        if (scrollView.contentOffset.y >= bottomCellOffset) {
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            if (self.canScroll) {
                self.canScroll = NO;
                self.segmentCell.objectCanScroll = YES;
            }
        }else{
            //子视图没到顶部
            if (!self.canScroll) {
                scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
            }
        }
    }
}


#pragma mark ——————————segmentTableViewCellDelegate——————————
- (void)segmentScrollViewDidScroll:(UIScrollView *)scrollView{
    self.tableView.scrollEnabled = NO;
}

- (void)segmentScrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x/SCREEN_WIDTH;
    [UIView animateWithDuration:0.02 animations:^{
        [self.sliderView selectedBarItemAtIndex:page];
    }];
    self.tableView.scrollEnabled = YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark -GestureTableView delegate And datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {

    }
    segmentTableViewCell *contain = [tableView dequeueReusableCellWithIdentifier:@"container"];
    contain.layer.cornerRadius = 16;
    contain.backgroundColor = [UIColor whiteColor];
    contain=[[segmentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"container" WithVolunteerItem:self.volunteer Andindex:self.index];
    contain.VC = self;
    self.segmentCell = contain;
    contain.delegate = self;
    return contain;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 138;
    }
    return SCREEN_WINDOW_HEIGHT-SLIDERHEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return SLIDERHEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return self.sliderView;
    }
    return nil;
}

- (MGDSliderBar *)sliderView{
    if (!_sliderView) {
        NSArray *itemArr=@[@"志愿时长",@"志愿活动"];
        _sliderView = [[MGDSliderBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SLIDERHEIGHT)];
        _sliderView.itemWidth=SCREEN_WIDTH/itemArr.count;
        _sliderView.itemsTitle = itemArr;
        [_sliderView sliderBarItemSelectedCallBack:^(NSInteger idx) {
            [UIView animateWithDuration:0.2 animations:^{
                self.segmentCell.isSelectIndex = YES;
                [self.segmentCell.scrollView setContentOffset:CGPointMake(idx*SCREEN_WIDTH, 0) animated:YES];
            }];
        }];
    }
    return _sliderView;
}

///创建提示文字
- (UILabel *)creatLabelWithText:(NSString *)text AndFont:(UIFont *)font AndTextColor:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = font;
    lab.text = text;
    lab.textColor = color;
    return lab;
}

///年份选择cell的年份选择按钮的点击事件
- (void)YearChooseBtnClicked{
    [self.view addSubview:_backView];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.6576, SCREEN_WIDTH, SCREEN_WIDTH * 278/375)];
    pickerView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:245.0/255.0 blue:253.0/255.0 alpha:1];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
    _pickerView = pickerView;
}

#pragma mark -UIPickViewDelegate and datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _yearArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@",_yearArray[row]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 140;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        //adjustsFontSizeToFitWidth property to YES
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextColor:[UIColor blackColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:25]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

///将选择的年份通过通知中心传回去
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDictionary *dic = @{@"year":_yearArray[row]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YearClicked" object:nil userInfo:dic];
    self.index = _yearArray[row];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self->_backView removeFromSuperview];
        [self->_pickerView removeFromSuperview];
    });
}

#pragma mark -LogOutViewDelegate
- (void)ClickedSureBtn {
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"volunteer_information"];
    [self->_popView removeFromSuperview];
    VolunteerUnbinding *unbindingModel = [[VolunteerUnbinding alloc] init];
    [unbindingModel VolunteerUnbinding];
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"controller点击了此方法");
}

- (void)ClickedCancelBtn {
    [UIView animateWithDuration:0.2 animations:^{
        [self->_popView removeFromSuperview];
    }];
}


@end
