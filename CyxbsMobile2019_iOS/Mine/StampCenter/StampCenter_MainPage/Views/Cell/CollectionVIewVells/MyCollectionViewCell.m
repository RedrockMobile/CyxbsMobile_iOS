//
//  MyCollectionViewCell.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/7.
//

#import "MyCollectionViewCell.h"
#import "UIView+XYView.h"
#define W self.myFrame.size.width
#define H self.myFrame.size.height

//167x237
@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        self.myFrame = frame;
        self.contentView.backgroundColor = [UIColor colorNamed:@"#FFFFFF"];
        self.contentView.layer.cornerRadius = 0.047*W;
        self.contentView.layer.shadowColor = [UIColor colorNamed:@"shadow"].CGColor;
        self.contentView.layer.shadowOpacity = 0.3;
        self.contentView.layer.shadowRadius = 5;
        self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
        self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;

        [self.contentView addSubview:self.goodsImageView];
        [self.contentView addSubview:self.exchangeBtn];
        [self.contentView addSubview:self.stampRequirementLbl];
        [self.contentView addSubview:self.stampImageView];
        [self.contentView addSubview:self.stockLbl];
        [self.contentView addSubview:self.mainLbl];
        [self.contentView addSubview:self.showBtn];
    }
    return self;
}


#pragma mark - setter
- (void)setData:(GoodsData *)data{
    self.mainLbl.text = data.title;
    self.stampRequirementLbl.text = [NSString stringWithFormat:@"%d",data.price];
    self.stockLbl.text = [NSString stringWithFormat:@"库存: %d",data.amount];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:data.url]];
    if (data.amount < 1) {
        self.exchangeBtn.backgroundColor = [UIColor colorNamed:@"cannotbuy"];
    }
    else{
        self.exchangeBtn.backgroundColor = [UIColor colorNamed:@"#4A44E4"];
    }
    self.exchangeBtn.tag = data.id;
    self.showBtn.tag = data.id;
}

#pragma mark -getter
- (UIImageView *)goodsImageView{
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W, 0.611*H)];
        _goodsImageView.image = [UIImage imageNamed:@"goodsImage"];
        UIBezierPath  *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.goodsImageView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(0.047*W, 0.047*W)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame =_goodsImageView.bounds;
        maskLayer.path = maskPath.CGPath;
       _goodsImageView.layer.mask = maskLayer;
    }
    return _goodsImageView;
}

- (UILabel *)mainLbl{
    if (!_mainLbl) {
        _mainLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.071*W, 0.65*H, 0.85*W, 20)];
        _mainLbl.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        _mainLbl.textColor = [UIColor colorNamed:@"#15315B"];
        _mainLbl.text = @"挂件";
    }
    return _mainLbl;
}

- (UILabel *)stockLbl{
    if (!_stockLbl) {
        _stockLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.071*W, 0.74*H, 0.928*W, 15)];
        _stockLbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
       _stockLbl.textColor = [UIColor colorNamed:@"#15315BB2"];
        _stockLbl.text = @"库存:0";
    }
    return _stockLbl;
}

- (UIImageView *)stampImageView{
    if (!_stampImageView) {
        _stampImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.071*W, 0.848*H, 18, 18)];
        _stampImageView.image = [UIImage imageNamed:@"stamp"];
    }
    return _stampImageView;
}

- (UILabel *)stampRequirementLbl{
    if (!_stampRequirementLbl) {
        _stampRequirementLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.203*W,0.856*H,130, 17)];
        _stampRequirementLbl.font = [UIFont fontWithName:@"DIN-Medium" size:14];
        _stampRequirementLbl.textColor = [UIColor colorNamed:@"#5177FF"];
        _stampRequirementLbl.text = @"0";
    }
    return _stampRequirementLbl;
}

- (UIButton *)exchangeBtn{
    if (!_exchangeBtn) {
       _exchangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.64*W, 0.839*H, 0.287*W, 26)];
        _exchangeBtn.backgroundColor = [UIColor colorNamed:@"#4A44E4"];
        _exchangeBtn.layer.cornerRadius = 13;
        [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        _exchangeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    }
    return _exchangeBtn;
}
- (UIButton *)showBtn{
    if (!_showBtn) {
        _showBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.goodsImageView.x, self.goodsImageView.y, self.goodsImageView.width, H)];
        self.showBtn.backgroundColor = [UIColor clearColor];
    }
    return _showBtn;
}


@end
