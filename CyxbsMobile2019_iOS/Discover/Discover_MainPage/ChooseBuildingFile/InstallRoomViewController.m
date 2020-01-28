//
//  InstallRoomViewController.m
//  Query
//
//  Created by hzl on 2017/3/8.
//  Copyright © 2017年 c. All rights reserved.
//

#import "InstallRoomViewController.h"
#import "InstallBuildTableViewCell.h"

#define font(R) (R)*([UIScreen mainScreen].bounds.size.width)/375.0


CG_INLINE CGRect
CHANGE_CGRectMake(CGFloat x, CGFloat y,CGFloat width,CGFloat height){

    CGRect rect;
    rect.origin.x = x * autoSizeScaleX;
    rect.origin.y = y * autoSizeScaleY;
    rect.size.width = width * autoSizeScaleY;
    rect.size.height = height * autoSizeScaleY;
    return rect;
}

@interface InstallRoomViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *buildLabel;

@property (nonatomic, strong) UITextField *roomTextField;

@property (nonatomic, strong) UIView *infoBigView;

@property (nonatomic, strong) UIView *unachieveBigView;

@property (nonatomic, strong) UIView *bigView;

@property (nonatomic, strong) UIButton *achieveBtn;
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)UIImageView *buildView;
@property(nonatomic,strong)UIImageView *roomView;
@property (nonatomic, assign) NSInteger building;//几栋：例如15栋

@end

@implementation InstallRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置寝室";
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    [self addTitleView];

    [self addBuildIcon];
    [self addRoomIcon];
    [self addbuildLabel];
    [self addRoomTextField];
    [self addachieveBtn];
}

- (void)hideKeyBoard{
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
}
//播放gif
- (void)addTitleView{

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"electricity_header_setting" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;
    [_webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.opaque = NO;
    [self.view addSubview:_webView];
    

}


- (void)addbuildLabel{

    _buildLabel = [[UILabel alloc]init];
//    _buildLabel = [[UILabel alloc] initWithFrame:CHANGE_CGRectMake(82, 425, 250, 20)];
    _buildLabel.font = [UIFont systemFontOfSize:font(16)];
    _buildLabel.text = @"请选择楼栋数";
    _buildLabel.textAlignment = NSTextAlignmentLeft;
    _buildLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    _buildLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBuildTableView)];
    [_buildLabel addGestureRecognizer:tapGesture];
    UILabel *lineLabel = [[UILabel alloc] init];
//    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CHANGE_CGRectMake(82, 447.5, 250, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.7];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"angleImage.png"]];
    arrowView.contentMode = UIViewContentModeScaleToFill;
//    arrowView.frame = CHANGE_CGRectMake(311.5, 430, 15, 10);
    
    [self.view addSubview:arrowView];
    [self.view addSubview:lineLabel];
    [self.view addSubview:_buildLabel];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lineLabel.mas_top).offset(-5);
        make.width.equalTo(@15);
        make.height.equalTo(@10);
        make.right.equalTo(_buildLabel);
    }];
//    _buildLabel.backgroundColor = [UIColor redColor];
    [_buildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@270);//200
        make.centerY.equalTo(_buildView);
        make.left.equalTo(_buildView.mas_right).offset(25);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_buildLabel);
        make.height.equalTo(@1);
        make.top.equalTo(_buildLabel.mas_bottom);
        make.left.equalTo(_buildLabel);
    }];
}

- (void)addRoomTextField{
    
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"寝室号(三位数)" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1]}];
    [placeholder addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font(16)]} range:NSMakeRange(0, placeholder.length)];
    
    _roomTextField = [[UITextField alloc] initWithFrame:CHANGE_CGRectMake(82, 475, 250, 20)];
    _roomTextField.textAlignment = NSTextAlignmentLeft;
    _roomTextField.font = [UIFont systemFontOfSize:font(16)];
    _roomTextField.attributedPlaceholder = placeholder;
    _roomTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _roomTextField.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
    _roomTextField.delegate = self;
    UILabel *lineLabel = [[UILabel alloc] init];
//    UILabel *lineLabel = [[UILabel alloc] initWithFrame:CHANGE_CGRectMake(82, 497.5, 250, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.7];
    
    [self.view addSubview:lineLabel];
    [self.view addSubview:_roomTextField];
    [_roomTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_buildLabel);
        make.height.equalTo(_buildLabel);
        make.centerX.equalTo(_buildLabel);
        make.centerY.equalTo(_roomView);
    }];
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(_roomTextField);
        make.height.equalTo(@1);
        make.top.equalTo(_roomTextField.mas_bottom);
        make.left.equalTo(_roomTextField);
        
    }];
}

//确定按钮
- (void)addachieveBtn{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:@"确 定" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [content addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font(21)]} range:NSMakeRange(0, content.length)];
    _achieveBtn = [[UIButton alloc] init];
//    _achieveBtn = [[UIButton alloc] initWithFrame:CHANGE_CGRectMake(43.5, 544.5, 288,46)];
    [_achieveBtn setAttributedTitle:content forState:UIControlStateNormal];
    _achieveBtn.backgroundColor = [UIColor colorWithRed:18/255.0 green:185/255.0 blue:255/255.0 alpha:1];
    
    _achieveBtn.layer.cornerRadius = 23;
    _achieveBtn.layer.masksToBounds = YES;
    
    [_achieveBtn addTarget:self action:@selector(saveData) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:_achieveBtn];
    [_achieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@46);
        make.width.equalTo(@288);
        make.centerX.equalTo(self.view);

        make.centerY.equalTo(self.view).offset(270);
    }];
}



- (void)saveData{
    if (_roomTextField.text.length!=3/*||_buildLabel.text.length!=3*/) {
        [self showInfoView];
    }else{
        NSDate *currentDate = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *compoent = [calendar components:NSCalendarUnitMonth fromDate:currentDate];
        
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = pathArray[0];
        NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:@"RoomAndBuild.plist"];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
            [data setObject:[NSString stringWithFormat:@"%@",_roomTextField.text] forKey:@"room"];
            [data setObject:[NSString stringWithFormat:@"%@",[_buildLabel.text substringWithRange:NSMakeRange(0, 2)]] forKey:@"build"];
        [data setObject:[NSString stringWithFormat:@"%@",compoent] forKey:@"month"];
            [data writeToFile:plistPath atomically:YES];
        
//MARK: - 判断信息无误之后将building和room写入缓存
        UserItem *userItem = [UserItem defaultItem];
        userItem.building = [NSString stringWithFormat:@"%ld",self.building];
        NSLog(@"building设置成功%@",userItem.building);
        userItem.room =  [NSString stringWithFormat:@"%@",_roomTextField.text];
        NSLog(@"room设置成功%@",userItem.room);
        
        
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"设置成功";
        [hud hide:YES afterDelay:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showTheSuccessHub" object:self];


        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

- (void)pushToDoneVC{
    
}
/****************************
 *        警告弹框            *
 ****************************/
- (void)showInfoView{
    _infoBigView = [[UIView alloc] init/*WithFrame:CHANGE_CGRectMake(0, 0, 375, 667)*/];
    _infoBigView.backgroundColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:0.7];
//    _infoBigView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_infoBigView];
    
    
    
    UIView *achieveView = [[UIView alloc] init/*WithFrame:CHANGE_CGRectMake(31, 174.5, 313, 319)*/];
    achieveView.layer.cornerRadius = 12;
    achieveView.layer.masksToBounds = YES;
    achieveView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"achieveImage.png"]];
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.backgroundColor = [UIColor redColor];
    [imageView setContentMode:UIViewContentModeRedraw];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
//    imageView.frame = CHANGE_CGRectMake(0, 0, 313, 187.5);
    
    UILabel *infoLabel = [[UILabel alloc] init/*WithFrame:CHANGE_CGRectMake(100.5, 213.5, 116, 20)*/];
//
    infoLabel.font = [UIFont systemFontOfSize:font(17)];
    infoLabel.textColor = [UIColor colorWithRed:119/255.0 green:119/255.0 blue:119/255.0 alpha:1];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.text = @"请将信息填写完整";
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.adjustsFontSizeToFitWidth = YES;
    infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    infoLabel.contentMode = UIViewContentModeRedraw;
    
    UIButton *achieveBtn = [[UIButton alloc] init/*WithFrame:CHANGE_CGRectMake(31, 264, 252, 41.5)*/];
    achieveBtn.backgroundColor = [UIColor colorWithRed:18/255.0 green:185/255.0 blue:255/255.0 alpha:1];
    [achieveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [achieveBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [achieveBtn addTarget:self action:@selector(removeInfoBigView) forControlEvents:UIControlEventTouchDown];
    achieveBtn.layer.cornerRadius = 5;
    achieveBtn.layer.masksToBounds = YES;
    [_infoBigView addSubview:achieveView];
    [achieveView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.view).offset(-50);
        make.top.equalTo(achieveView);
        make.width.equalTo(achieveView);
        make.height.equalTo(achieveView).multipliedBy(0.49);
    }];
    [achieveView addSubview:infoLabel];
    [achieveView addSubview:achieveBtn];
    [achieveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_infoBigView);
        make.width.equalTo(@313);
        make.height.equalTo(@400);
//        make.centerY.equalTo(self.view);

    }];
    [achieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(achieveView).offset(-50);
        make.width.equalTo(achieveView).multipliedBy(0.6);
        make.centerX.equalTo(achieveView);
        make.height.equalTo(@41.5);
    }];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(achieveView);
        make.centerY.equalTo(achieveBtn).offset(-85);
        make.height.equalTo(@40);
        make.width.equalTo(@146);
    }];

    [_infoBigView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);
    }];
}

- (void)removeInfoBigView{
    _infoBigView.hidden = YES;
    _infoBigView = nil;
}


- (void)addBuildIcon{
    _buildView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buildIcon.png"]];
//    buildView.frame = CHANGE_CGRectMake(43.5, 425, 18, 19);
    _buildView.contentMode = UIViewContentModeScaleToFill;

        [self.view addSubview:_buildView];
    [_buildView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.equalTo(@18);
        make.height.equalTo(@19);
        make.centerX.equalTo(self.view).offset(-148);
        make.centerY.equalTo(self.view).offset(115);
    }];


}

- (void)addRoomIcon{
    _roomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"roomIcon.png"]];
//    roomView.frame = CHANGE_CGRectMake(43.5, 476, 18, 19);
    [self.view addSubview:_roomView];

    [_roomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.equalTo(_buildView);
        make.width.equalTo(_buildView);
        make.height.equalTo(_buildView);
        make.centerY.equalTo(_buildView).offset(60);
        make.centerX.equalTo(_buildView);
    }];
}

// MARK: - tableView 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 39;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InstallBuildTableViewCell *cell = [InstallBuildTableViewCell tableView:tableView cellForRowAtIndexPath:indexPath];
    _buildLabel.text = cell.buildLabel.text;
    
    self.building = indexPath.row + 1;
    
    [self removeView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InstallBuildTableViewCell *cell = [InstallBuildTableViewCell tableView:tableView cellForRowAtIndexPath:indexPath];
    NSArray*buildArr = @[@"（知行苑1舍）",
                         @"（知行苑2舍）",
                         @"（知行苑3舍）",
                         @"（知行苑4舍）",
                         @"（知行苑5舍）",
                         @"（知行苑6舍）",
                         @"",
                         @"（宁静苑1舍）",
                         @"（宁静苑2舍）",
                         @"（宁静苑3舍）",
                         @"（宁静苑4舍）",
                         @"（宁静苑5舍）",
                         @"",
                         @"",
                         @"（知行苑7舍）",
                         @"（知行苑8舍）",
                         @"（兴业苑1舍）",
                         @"（兴业苑2舍）",
                         @"（兴业苑3舍）",
                         @"（兴业苑4舍）",
                         @"（兴业苑5舍）",
                         @"（兴业苑6舍）",
//                         @"（兴业苑7舍）",
                         @"（兴业苑7、8舍）",
                         @"（明理苑1舍）",
                         @"（明理苑2舍）",
                         @"（明理苑3舍）",
                         @"（明理苑4舍）",
                         @"（明理苑5舍）",
                         @"（明理苑6舍）",
                         @"（明理苑7舍）",
                         @"（明理苑8舍）",
                         @"（宁静苑6舍）",
                         @"（宁静苑7舍）",
                         @"（宁静苑8舍）",
                         @"（宁静苑9舍）",
                         @" (四海苑1舍)",
                         @" (四海苑2舍)",
                         @"",
                         @"（明理苑9舍）"];
    [cell.buildLabel setWidth:300];
    if (indexPath.row + 1 < 10) {
        cell.buildLabel.text = [NSString stringWithFormat:@"0%ld栋%@",(long)indexPath.row+1,buildArr[indexPath.row]];
    }else{
        cell.buildLabel.text = [NSString stringWithFormat:@"%ld栋%@",(long)indexPath.row+1,buildArr[indexPath.row]];
    }

     return cell;
}

- (void)showBuildTableView{
    _tableView = [[UITableView alloc] initWithFrame:CHANGE_CGRectMake(0,359.5 , 375, 307.5) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
        _bigView = [[UIView alloc] initWithFrame:CHANGE_CGRectMake(0, 0, 375, 667)];
        _bigView.backgroundColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:0.1];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView)];
    tapGesture.delegate = self;
    [_bigView addGestureRecognizer:tapGesture];
    
    
    [_bigView addSubview:_tableView];
    [self.view addSubview:_bigView];
}

- (void)removeView{
    _bigView.hidden = YES;
    _bigView = nil;
    _tableView = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    if ([touch.view isKindOfClass:[UITableView class]]){
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
