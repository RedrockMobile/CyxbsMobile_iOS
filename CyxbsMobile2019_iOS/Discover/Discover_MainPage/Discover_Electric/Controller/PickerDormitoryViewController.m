//
//  PickerDormitoryViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 潘申冰 on 2023/4/12.
//  Copyright © 2023 Redrock. All rights reserved.
//

#import "PickerDormitoryModel.h"
#import "PickerDormitoryViewController.h"

@interface PickerDormitoryViewController ()<
    UIPickerViewDelegate,
    UIPickerViewDataSource
    >

/// 绑定宿舍页面的contentView，他是一个button，用来保证点击空白处可以取消设置宿舍
@property (nonatomic, weak) UIButton *bindingDormitoryContentView;
/// 用来绑定宿舍的View
@property (nonatomic, weak) UIView *bindingView;
/// 选择宿舍时候的宿舍号label
@property (nonatomic, weak) UILabel *buildingNumberLabel;
/// 填写房间号的框框
@property (nonatomic, weak) UITextField *roomTextField;
/// PickerDormitory
@property (nonatomic, strong) PickerDormitoryModel *pickerDormitoryModel;
@property (nonatomic) NSInteger selectedArrays;
@end

@implementation PickerDormitoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0];
    [self bindingBuildingAndRoom];
}

#pragma mark - end
- (void)cancelLearnAbout {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//绑定宿舍房间号
- (void)bindingBuildingAndRoom {
//    [self getPickerViewData];
    //添加灰色背景板
    UIButton *contentView = [[UIButton alloc] initWithFrame:self.view.frame];
    self.bindingDormitoryContentView = contentView;
    [self.view addSubview:contentView];
    contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    contentView.alpha = 0;

    [UIView animateWithDuration:0.3 animations:^{
        contentView.alpha = 1;
        self.tabBarController.tabBar.userInteractionEnabled = NO;
    }];
    [contentView addTarget:self action:@selector(cancelLearnAbout) forControlEvents:UIControlEventTouchUpInside];

    UIView *bindingView = [[UIView alloc]init];
    bindingView.layer.cornerRadius = 8;

    if (@available(iOS 11.0, *)) {
        bindingView.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
    } else {
        bindingView.backgroundColor = UIColor.whiteColor;
    }

    [contentView addSubview:bindingView];
    self.bindingView = bindingView;
    [bindingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@339);
    }];
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    [bindingView addSubview:pickerView];
    [pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bindingView).offset(97);
        make.left.right.equalTo(bindingView);
        make.height.equalTo(@152);
    }];
    pickerView.delegate = self;
    pickerView.dataSource = self;

    UILabel *roomNumberLabel = [[UILabel alloc] init];
    roomNumberLabel.font = [UIFont fontWithName:PingFangSCBold size:24];
    roomNumberLabel.text = @"宿舍号：";

    if (@available(iOS 11.0, *)) {
        roomNumberLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#5E5F64" alpha:1]];
    } else {
    }

    [bindingView addSubview:roomNumberLabel];
    [roomNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bindingView).offset(14);
        make.top.equalTo(bindingView).offset(23);
    }];
    UITextField *textField = [[UITextField alloc] init];
    [bindingView addSubview:textField];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.returnKeyType = UIReturnKeyDone;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomNumberLabel).offset(85);
        make.centerY.equalTo(roomNumberLabel);
        make.width.equalTo(@170);
    }];
    textField.placeholder = @"例如\"403\"";

    if ([UserItem defaultItem].room) {
        textField.text = [UserItem defaultItem].room;
    }

    textField.inputAccessoryView = [self addToolbar];
    textField.font = roomNumberLabel.font;
    self.roomTextField = textField;

    if (@available(iOS 11.0, *)) {
        textField.textColor = roomNumberLabel.textColor;
    } else {
        // Fallback on earlier versions
    }

    UILabel *buildingNumberLabel = [[UILabel alloc] init];
    buildingNumberLabel.text = @"01栋";

    if (@available(iOS 11.0, *)) {
        buildingNumberLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:0.59] darkColor:[UIColor colorWithHexString:@"#EFEFF1" alpha:0.59]];
    } else {
        // Fallback on earlier versions
    }

    buildingNumberLabel.font = [UIFont fontWithName:PingFangSCRegular size:15];
    self.buildingNumberLabel = buildingNumberLabel;
    NSString *building = [UserItem defaultItem].building;

    if (building) {//如果用户曾经选择过，那么就显示曾见选择的那个
        self.buildingNumberLabel.text = [NSString stringWithFormat:@"%@栋", building];
        NSArray<NSNumber *> *chooseIndex = [self.pickerDormitoryModel getBuildingNameIndexAndBuildingNumberIndexByNumberOfDormitory:building];
        [pickerView selectRow:chooseIndex.lastObject.intValue inComponent:1 animated:NO];
        [pickerView selectRow:chooseIndex.firstObject.intValue inComponent:0 animated:NO];
    }

    [bindingView addSubview:buildingNumberLabel];
    [buildingNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roomNumberLabel);
        make.top.equalTo(roomNumberLabel.mas_bottom).offset(3);
    }];

    UIButton *button = [[UIButton alloc] init];
    [bindingView addSubview:button];
    button.backgroundColor = [UIColor colorWithHexString:@"#4841E2"];
    [button setTitle:@"确定" forState:normal];
    button.layer.cornerRadius = 20;
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bindingView);
        make.bottom.equalTo(bindingView).offset(-29);
        make.width.equalTo(@120);
        make.height.equalTo(@40);
    }];
    [button addTarget:self action:@selector(bindingDormitory) forControlEvents:UIControlEventTouchUpInside];
}

- (void)cancelSettingDormitory {
    [self.bindingDormitoryContentView removeFromSuperview];
}

- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];

    toolbar.tintColor = [UIColor blueColor];
//    toolbar.backgroundColor = [UIColor sy_grayColor];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}

- (void)textFieldDone {
    [self.view endEditing:YES];
}

- (void)bindingDormitory {
    UserItem *item = [UserItem defaultItem];

    if (self.buildingNumberLabel.text != nil) {
//        NSString *building = [NSString stringWithFormat:@"%d",self.buildingNumberLabel.text.intValue];//这里隐式的去掉了“栋”字
        NSString *building = [self.buildingNumberLabel.text stringByReplacingOccurrencesOfString:@"栋" withString:@""];
        item.building = building;
    }

    NSLog(@"*%@*", self.roomTextField.text);

    if (self.roomTextField.text != nil && ![self.roomTextField.text isEqual:@""]) {
        item.room = self.roomTextField.text;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.bindingView animated:YES];
        [hud setMode:(MBProgressHUDModeText)];
        hud.labelText = @"请输入宿舍号～";
        [hud hide:YES afterDelay:1];
        return;
    }

//    self.tabBarController.tabBar.hidden=NO;
//    [self.bindingDormitoryContentView removeAllSubviews];
//    [self.bindingDormitoryContentView removeFromSuperview];
    [self reloadElectricViewIfNeeded];
    [self cancelLearnAbout];
}

//- (void)getPickerViewData {
//    PickerDormitoryModel *pickerModel = [[PickerDormitoryModel alloc] init];
//
//    self.pickerDormitoryModel = pickerModel;
//}

- (PickerDormitoryModel *)pickerDormitoryModel {
    if (!_pickerDormitoryModel) {
        _pickerDormitoryModel = [[PickerDormitoryModel alloc] init];
    }
    return _pickerDormitoryModel;
}

- (void)reloadElectricViewIfNeeded {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"electricFeeRoomChange" object:nil];
}

//MARK: - pickerView代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2; // 返回2表明该控件只包含2列
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component  {
    if (component == 0) {
        return self.pickerDormitoryModel.allArray.count;
    } else {
        return [self.pickerDormitoryModel.allArray objectAtIndex:self.selectedArrays].count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return self.pickerDormitoryModel.placeArray[row];
    } else {
//        self.placeArray = @[@"宁静苑",@"明理苑",@"知行苑",@"兴业苑",@"四海苑"];
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSArray *arr = [self.pickerDormitoryModel.allArray objectAtIndex:selectedRow];

        if (row < arr.count) {
            return [arr objectAtIndex:row];
        } else {
            return [arr objectAtIndex:0];
        }
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        //如果滑动的是第 0 列, 刷新第 1 列
        //在执行完这句代码之后, 会重新计算第 1 列的行数, 重新加载第 1 列的标题内容
        [pickerView reloadComponent:1];//重新加载指定列的数据
        self.selectedArrays = row;
        [pickerView selectRow:0 inComponent:1 animated:YES];
        //
        //重新加载数据
        [pickerView reloadAllComponents];
    } else {
        //如果滑动的是右侧列，刷新上方label

//           [PickerDormitoryModel getNumberOfDormitoryWith:self.pickerModel.placeArray[row] andPlace:self.pickerModel.allArray[row][row]];
    }

    NSInteger row0 = [pickerView selectedRowInComponent:0];
    NSInteger row1 = [pickerView selectedRowInComponent:1];
    self.buildingNumberLabel.text = [self.pickerDormitoryModel getNumberOfDormitoryWith:self.pickerDormitoryModel.placeArray[row0] andPlace:self.pickerDormitoryModel.allArray[row0][row1]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (component == 0) {
        return 100;
    } else {
        return 100;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    if (component == 0) {
        return 45;
    } else {
        return 45;
    }
}

@end
