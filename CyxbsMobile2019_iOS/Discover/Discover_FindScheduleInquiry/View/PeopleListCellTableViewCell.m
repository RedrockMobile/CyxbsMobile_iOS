//
//  PeopleListCellTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "PeopleListCellTableViewCell.h"
@interface PeopleListCellTableViewCell()
// 当前索引
@property (nonatomic, strong) NSIndexPath *cellIndex;
@end

@implementation PeopleListCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.addBtn];
        [self.imageView setImage:[UIImage imageNamed:@"defaultStudentImage"]];
        if(@available(iOS 11.0,*)){
            self.textLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        }else{
            self.textLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        }
        self.textLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
        if(@available(iOS 11.0, *)){
            self.detailTextLabel.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        }else{
            self.detailTextLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
        }
        self.detailTextLabel.font = [UIFont fontWithName:PingFangSCRegular size:13];
        [self addStuNumLabel];
        [self setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    }
    return self;
}
-(void) addStuNumLabel {
    UILabel *label = [[UILabel alloc]init];
    [self.contentView addSubview:label];
    self.stuNumLabel = label;
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    if(@available(iOS 11.0, *)){
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2A4E84" alpha:1] darkColor:[UIColor colorWithHexString:@"#DFDFE3" alpha:1]];
    }else{
        label.textColor = [UIColor colorWithRed:42/255.0 green:78/255.0 blue:132/255.0 alpha:1];
    }
}
- (void)layoutSubviews {
    self.imageView.frame = CGRectMake(19, 18, 48, 48);
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.top.equalTo(self).offset(17);
    }];
    [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel);
        make.top.equalTo(self.textLabel.mas_bottom).offset(7);
    }];
    [self.stuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel);
        make.right.equalTo(self).offset(-15);
    }];
    // 添加btn
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stuNumLabel.mas_right);
        make.top.equalTo(self.stuNumLabel.mas_bottom).mas_offset(12);
        make.bottom.equalTo(self.detailTextLabel.mas_bottom);
        make.width.mas_equalTo(16);
        make.height.mas_equalTo(16);
    }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

// 添加课表的btn
- (UIButton *)addBtn {
    if (_addBtn == nil) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:[UIImage imageNamed:@"addPeopleClass"] forState:UIControlStateNormal];
        // 点击按钮
        //1. 判断是否关联
            //1.1 未关联点击方法：添加关联
        [_addBtn addTarget:self action:@selector(didClickedAddPeopleFromIndex) forControlEvents:UIControlEventTouchUpInside];
            //1.2 已关联再点击：取消关联
        
    }
    return _addBtn;
}

// 添加关联
- (void)didClickedAddPeopleFromIndex {
    // 判断关联人数
    //1. if当前无关联：
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"BOOL"]) {
        //1.1 添加关联,执行代理
    [self.delegate addPeopleClass:self.cellIndex];
        //1.2 弹出提示框@"关联成功！"
        
        //1.3 加入userDefault
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"BOOL"];
    [NSUserDefaults.standardUserDefaults synchronize];
    }
    //2. if当前有关联：
    if([NSUserDefaults.standardUserDefaults boolForKey:@"BOOL"]){
        //2.1 弹出提示：是否替换
        
            //2.1.1 取消
            //2.1.2 确定：
    }
}

@end
