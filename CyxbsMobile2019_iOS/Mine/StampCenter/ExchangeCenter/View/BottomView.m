//
//  BottomView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "BottomView.h"
#import <Masonry/Masonry.h>
#import "Goods.h"
#import "Balance.h"

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame AndID:(NSString *)ID{
    if ([super initWithFrame:frame]) {
        self.goodsID = ID;
        [self setup];
    }
    return  self;
}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setup];
//    }
//    return self;
//}
///设置
- (void)setup {
    UIImageView *iconView = [[UIImageView alloc]init];
    [self addSubview:iconView];
    _iconView = iconView;
    iconView.backgroundColor = [UIColor colorNamed:@"White&Black"];
    [iconView setImage:[UIImage imageNamed:@"icon"]];
    iconView.frame = CGRectMake(20, 10, 21, 21);
    
    UILabel *balanceLabel = [[UILabel alloc]init];
    [self addSubview:balanceLabel];
    _balanceLabel = balanceLabel;
    balanceLabel.font = [UIFont systemFontOfSize:11];
    balanceLabel.textColor = [UIColor colorNamed:@"21_49_91"];
    balanceLabel.frame = CGRectMake(20, 35, 300, 20);
    [Balance getDataDictWithBalance:_goodsID Success:^(NSDictionary * _Nonnull dict) {
        self.balanceLabel.text = [@"余额：" stringByAppendingString:[NSString stringWithFormat:@"%@",dict[@"user_amount"]]];
        } failure:^{
            
        }];
    
    
    UIButton *exchangeBtn = [[UIButton alloc]init];
    [self addSubview:exchangeBtn];
    _exchangeBtn = exchangeBtn;
    [exchangeBtn setBackgroundColor:[UIColor colorNamed:@"93_93_247"]];
    exchangeBtn.layer.cornerRadius = 20;
    [exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset([UIScreen mainScreen].bounds.size.width * 247 / 375 );
            make.top.equalTo(self).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(40);
    }];
    
    _priceLabel = [[UILabel alloc]init];
    [self addSubview:_priceLabel];
    _priceLabel.textColor = [UIColor colorNamed:@"81_119_255"];
    _priceLabel.font = [UIFont systemFontOfSize:18];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(46);
            make.top.equalTo(self).offset(10);
            make.height.mas_equalTo(22);
    }];
    NSString *s = self.goodsID;
    [Goods getDataDictWithId:s Success:^(NSDictionary * _Nonnull dict) {
        int amount = [dict[@"amount"] intValue];
        if (amount <= 0) {
            self.exchangeBtn.enabled = NO;
            self.exchangeBtn.backgroundColor = [UIColor colorNamed:@"170_187_255&73_85_132"];
        }
        self->_priceLabel.text = [NSString stringWithFormat:@"%@",dict[@"price"]];
        
        } failure:^{
            
        }];
}

@end
