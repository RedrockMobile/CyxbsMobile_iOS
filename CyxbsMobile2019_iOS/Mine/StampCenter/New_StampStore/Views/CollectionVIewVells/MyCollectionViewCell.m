//
//  MyCollectionViewCell.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/7.
//

#import "MyCollectionViewCell.h"

#define W frame.size.width
#define H frame.size.height

//167x237
@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorNamed:@"#FFFFFF"];
        self.contentView.layer.cornerRadius = 0.047*W;
        self.contentView.layer.shadowColor = [UIColor colorNamed:@"shadow"].CGColor;
        self.contentView.layer.shadowOpacity = 0.3;
        self.contentView.layer.shadowRadius = 5;
        self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
        self.contentView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds].CGPath;
        
        
        self.goodsImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, W, 0.611*H)];
        self.goodsImageView.image = [UIImage imageNamed:@"goodsImage"];
        UIBezierPath  *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.goodsImageView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(0.047*W, 0.047*W)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame =self.goodsImageView.bounds;
        maskLayer.path = maskPath.CGPath;
        self.goodsImageView.layer.mask = maskLayer;
        
        
        self.mianLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.071*W, 0.65*H, 0.85*W, 20)];
        self.mianLbl.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        self.mianLbl.textColor = [UIColor colorNamed:@"#15315B"];
        self.mianLbl.text = @"挂件";
        
        
        self.stockLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.071*W, 0.74*H, 0.928*frame.size.width, 15)];
        self.stockLbl.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        self.stockLbl.textColor = [UIColor colorNamed:@"#15315BB2"];
        self.stockLbl.text = @"库存:20";
        
        
        self.stampImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.071*W, 0.848*H, 18, 18)];
        self.stampImageView.image = [UIImage imageNamed:@"stamp"];
        
        
        self.stampRequirementLbl = [[UILabel alloc]initWithFrame:CGRectMake(0.203*W,0.856*H,130, 17)];
        self.stampRequirementLbl.font = [UIFont fontWithName:@"DIN-Medium" size:14];
        self.stampRequirementLbl.textColor = [UIColor colorNamed:@"#5177FF"];
        self.stampRequirementLbl.text = @"121";
        
        
        self.exchangeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.64*W, 0.839*H, 0.287*W, 26)];
        self.exchangeBtn.backgroundColor = [UIColor colorNamed:@"#4A44E4"];
        self.exchangeBtn.layer.cornerRadius = 13;
        [self.exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        self.exchangeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
        
        
        self.showBtn = [[UIButton alloc]initWithFrame:self.goodsImageView.frame];
        self.showBtn.backgroundColor = [UIColor clearColor];

        
        [self.contentView addSubview:self.exchangeBtn];
        [self.contentView addSubview:self.stampRequirementLbl];
        [self.contentView addSubview:self.stampImageView];
        [self.contentView addSubview:self.stockLbl];
        [self.contentView addSubview:self.mianLbl];
        [self.contentView addSubview:self.goodsImageView];
        [self.contentView addSubview:self.showBtn];
    }
    return self;
}

- (void)setData:(GoodsData *)data{
    self.mianLbl.text = data.title;
    self.stampRequirementLbl.text = [NSString stringWithFormat:@"%d",data.price];
    self.stockLbl.text = [NSString stringWithFormat:@"库存: %d",data.amount];
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:data.url]];
    self.exchangeBtn.tag = data.id;
    self.showBtn.tag = data.id;
}
@end
