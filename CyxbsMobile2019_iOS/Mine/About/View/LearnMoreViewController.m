//
//  LearnMoreViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//关于我们页面 - 服务协议/隐私条款

#import "LearnMoreViewController.h"
#define GetaboutUsMsg @"https://cyxbsmobile.redrock.team/wxapi/magipoke-text/text/get"
@interface LearnMoreViewController () <UITextViewDelegate>
@property(nonatomic,strong)UILabel *subTitleLabel;
@property(nonatomic,strong)UITextView *mainBodyTextView;
@end

@implementation LearnMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self ff];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithType:(LMVCType)type{
    self = [super init];
    if (self) {
        
        //父类是TopBarBasicViewController，调用父类的vcTitleStr的set方法，自动完成顶部的bar的设置
        if(type==LMVCTypePrivacyClause){
            self.VCTitleStr = @"隐私政策";
        }else{
            self.VCTitleStr = @"掌上重邮软件许可及服务协议";
        }
        [self addSubTitleLabel];
    }
    
    return self;
}

- (void)addSubTitleLabel {
    UILabel *label = [[UILabel alloc] init];
    self.subTitleLabel = label;
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0.0427*SCREEN_WIDTH);
        make.top.equalTo(self.topBarView.mas_bottom).offset(0.0667*SCREEN_WIDTH);
    }];
    
    label.text = @"【首部及导言】";
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    label.font = [UIFont fontWithName:PingFangSCBold size:15];
    
    [self addMainBodyTextView];
}

- (void)addMainBodyTextView {
    UITextView *view = [[UITextView alloc] init];
    [self.view addSubview: view];
    self.mainBodyTextView = view;
    
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(10);
    }];
    
    
    view.text = @"zxcvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuiozx ,rtyuio, tyuio, vbghjbnmh.\ncvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuio ,rtyuio, tyuio, vbghjbnmh.\nzxcvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuiozx ,rtyuio, tyuio, vbghjbnmh.\ncvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuio ,rtyuio, tyuio, vbghjbnmh.\nzxcvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuiozx ,rtyuio, tyuio, vbghjbnmh.\ncvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuio ,rtyuio, tyuio, vbghjbnmh.\nzxcvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuiozx ,rtyuio, tyuio, vbghjbnmh.\ncvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuio ,rtyuio, tyuio, vbghjbnmh.\nzxcvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuiozx ,rtyuio, tyuio, vbghjbnmh.\ncvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuio ,rtyuio, tyuio, vbghjbnmh.\nzxcvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuiozx ,rtyuio, tyuio, vbghjbnmh.\ncvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuio ,rtyuio, tyuio, vbghjbnmh.\nzxcvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuiozx ,rtyuio, tyuio, vbghjbnmh.\ncvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuio ,rtyuio, tyuio, vbghjbnmh.\nzxcvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuiozx ,rtyuio, tyuio, vbghjbnmh.\ncvbnmasdfgh ,rtyuio, tyuio, vbghjbnmh.\njkwertyuioz ,rtyuio, tyuio, vbghjbnmh.\nxcvbnmasdfghjkw ,rtyuio, tyuio, vbghjbnmh.\nertyuiozxc ,rtyuio, tyuio, vbghjbnmh.\nvbnmasdfghjkwe ,rtyuio, tyuio, vbghjbnmh.\nrtyuio ,rtyuio, tyuio, vbghjbnmh.\n";
    
    
    
    if (@available(iOS 11.0, *)) {
        view.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        view.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    view.backgroundColor = self.view.backgroundColor;
    
    [view setFont:[UIFont fontWithName:PingFangSCMedium size:13]];
    
    view.delegate = self;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

- (void)ff{
    [[HttpClient defaultClient] requestWithPath:GetaboutUsMsg method:HttpRequestGet parameters:@{@"name":@""} prepareExecute:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        CCLog(@"%@",responseObject[@"data"]);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        CCLog(@"%@",error);
    }];
}
@end



