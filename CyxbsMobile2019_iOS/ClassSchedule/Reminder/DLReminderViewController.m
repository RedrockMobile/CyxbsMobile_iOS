//
//  DLReminderViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 丁磊 on 2020/4/9.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "DLReminderViewController.h"
#import "DLReminderView.h"
#import "DLReminderSetDetailVC.h"
#import "DLHistodyButton.h"
#import "RemindNotification.h"
#import <Masonry.h>
#import <YYKit.h>
#define kRateX [UIScreen mainScreen].bounds.size.width/375   //以iPhoneX为基准
#define kRateY [UIScreen mainScreen].bounds.size.height/812  //以iPhoneX为基准
@interface DLReminderViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) NSString *inputString; //
@property (nonatomic, strong) NSMutableArray *buttonTitleArray;  //
@property (nonatomic, strong) NSUserDefaults *user;
@property (nonatomic, assign) NSInteger deleteIndex;
@property (nonatomic, copy)NSDictionary *remind;
//需要删除buttonTitleArray的endIndex
@property (nonatomic, strong) DLReminderView *reminderView;
@property (nonatomic, assign) BOOL isEditing;
@end

@implementation DLReminderViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reminderVCPoped" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (instancetype)initWithRemindDic:(NSDictionary *)remind{
    self = [self init];
    if (self) {
        self.remind = remind;
        self.isEditing = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [NSUserDefaults standardUserDefaults];
    if (![self.user objectForKey:@"buttonTitleArray"]) {
        self.buttonTitleArray = [@[@"自习", @"值班", @"会议"] mutableCopy];
    }else{
        self.buttonTitleArray = [self.user objectForKey:@"buttonTitleArray"];
    }
    [self.view addSubview: self.reminderView];
    [self loadHistoryButtons];
    // Do any additional setup after loading the view.
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text) {
        self.inputString = textField.text;
        [self.buttonTitleArray addObject: textField.text];
    }else{
        NSLog(@"未输入");
    }
}

- (void)didClickNextButton:(UIButton *)button{
    if (self.deleteIndex >= 3) {
        NSRange r = {3,self.deleteIndex-2};
        [self.buttonTitleArray subarrayWithRange: r];
        
    }
    [self.user setObject:[self.buttonTitleArray copy] forKey:@"buttonTitleArray"];
    [self.user synchronize];
    if (self.inputString) {
        DLReminderSetDetailVC *vc = [[DLReminderSetDetailVC alloc] init];
        vc.noticeString = self.inputString;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        NSLog(@"未输入");
    }
}

- (void)didClickHistoryButton:(DLHistodyButton *)button{
    self.inputString = self.buttonTitleArray[button.tag];
    
    NSLog(@"%@",self.inputString);
    
    self.reminderView.textFiled.text = self.buttonTitleArray[button.tag];
}
- (void)back{
    [self.user setObject:[self.buttonTitleArray copy] forKey:@"buttonTitleArray"];
    [self.user synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadHistoryButtons{
    CGFloat hasOccupiedWidth = 190 * kRateX;
    NSInteger j = 0;
    NSInteger count = self.buttonTitleArray.count;
    for (NSInteger i = 0; i < 3; i++) {
        DLHistodyButton *button = [[DLHistodyButton alloc] init];
        [button setTitle:self.buttonTitleArray[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(didClickHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reminderView.textFiled.mas_bottom).mas_offset(18 * kRateY);
            make.left.equalTo(self.view.mas_left).mas_offset(20*kRateX+60*kRateX*i);
            make.width.mas_equalTo(50*kRateX);
            make.height.mas_equalTo(30*kRateX);
        }];
    }
    for (NSInteger i = 0; count-i > 3; i++) {
        CGSize size = [self.buttonTitleArray[i] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@".PingFang SC-Regular" size:12*kRateX]}];
        if (hasOccupiedWidth + size.width >= SCREEN_WIDTH - 40*kRateX && j < 2) {
            j++;
            hasOccupiedWidth = 20*kRateX;
        }
        if (j >= 2){
            self.deleteIndex = count - i - 1;
            break;
        }
        DLHistodyButton *button = [[DLHistodyButton alloc] init];
        [button setTitle:self.buttonTitleArray[count-i-1] forState:UIControlStateNormal];
        button.tag = count-i-1;
        [button addTarget:self action:@selector(didClickHistoryButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview: button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.reminderView.textFiled.mas_bottom).mas_offset(18*kRateY + j*40*kRateY);
            make.left.equalTo(self.view.mas_left).mas_offset(hasOccupiedWidth + 60*kRateX);
            make.width.mas_equalTo(size.width + 30*kRateX);
            make.height.mas_equalTo(30*kRateX);
        }];
        hasOccupiedWidth += size.width + 40*kRateX;
    }
}
- (DLReminderView *)reminderView{
    if (!_reminderView) {
        _reminderView = [[DLReminderView alloc] init];
        _reminderView.frame = self.view.frame;
        _reminderView.titleLab.text = @"为你的行程添加 一个标题";
        _reminderView.textFiled.delegate = self;
        [_reminderView.nextBtn addTarget:self action:@selector(didClickNextButton:) forControlEvents:UIControlEventTouchUpInside];
        [_reminderView.backBtn addTarget: self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reminderView;
}


@end
