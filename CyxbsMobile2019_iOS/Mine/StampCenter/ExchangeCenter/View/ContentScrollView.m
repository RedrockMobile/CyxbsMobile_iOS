//
//  ContentScrollView.m
//  CyxbsMobile2019_iOS
//
//  Created by p_tyou on 2021/8/13.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "ContentScrollView.h"
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import "Goods.h"

#define picScrollViewWidth 360 * [UIScreen mainScreen].bounds.size.width / 390

@implementation ContentScrollView

///重写initWithFrame
- (instancetype)initWithFrame:(CGRect)frame AndID:(NSString *)ID{
    if ([super initWithFrame:frame]) {
        self.goodsID = ID;
        [self addPicView];
        [self addAmountLabel];
    }
    return  self;
}
///商品图片滚动
- (void)addPicView {
    UIScrollView *picScrollView = [[UIScrollView alloc]init];
    [self addSubview:picScrollView];
    _picScrollView = picScrollView;
    [picScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(16);
        make.width.mas_equalTo(picScrollViewWidth);
        make.height.mas_equalTo(178);
    }];
    picScrollView.layer.cornerRadius = 10;
    [picScrollView setContentSize:CGSizeMake(picScrollViewWidth * 3, 178)];
    picScrollView.pagingEnabled = YES;
    [picScrollView setShowsHorizontalScrollIndicator:NO];
//    [picScrollView setContentOffset:CGPointMake(picScrollViewWidth, 0) animated:NO];
    
    _color1 = @[[UIColor blueColor], [UIColor yellowColor], [UIColor redColor]];
    CGFloat imgW = picScrollViewWidth;
    CGFloat imgH = 178;
    CGFloat imgY = 0;
    NSString *s = self.goodsID;
    [Goods getDataDictWithId:s Success:^(NSDictionary * _Nonnull dict) {
//        CGFloat imgX = imgW;
//        self->_leftimgView =[[UIImageView alloc] init];
//        [self.picScrollView addSubview:self->_leftimgView];
//        self->_leftimgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
//        self->_leftimgView.backgroundColor = self->_urls[0];
//
//        imgX= imgW * 2;
//        self->_centerimgView =[[UIImageView alloc] init];
//        [self.picScrollView addSubview:self->_centerimgView];
//        self->_centerimgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
//        self->_centerimgView.backgroundColor = self->_urls[1];
//
//        imgX= imgW * 3;
//        self->_rightimgView =[[UIImageView alloc] init];
//        [self.picScrollView addSubview:self->_rightimgView];
//        self->_rightimgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
//        self->_rightimgView.backgroundColor = self->_urls[2];
        
        
        for (int i = 0; i < 3; i++) {
                UIImageView *imgeView =[[UIImageView alloc] init];
                [self.picScrollView addSubview:imgeView];
                CGFloat imgX = i*imgW;
                imgeView.frame = CGRectMake(imgX, imgY, imgW, imgH);

                imgeView.backgroundColor = self->_color1[i];

                self->_urls = dict[@"urls"];
                NSLog(@"%@", self->_urls);
                NSString *imgurl = self->_urls[0];
                NSURL *url = [NSURL URLWithString: imgurl];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:imageData];
                imgeView.image = image;
            }
        } failure:^{
    }];
    //添加分页控制器
    [self addPageController];
    NSLog(@"%@", _urls);
}


///分页控制器
- (void)addPageController {
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    [self addSubview:pageControl];
    _pageControl = pageControl;
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self.picScrollView.mas_bottom);
            make.width.mas_equalTo(125);
            make.height.mas_equalTo(30);
    }];
    pageControl.pageIndicatorTintColor =[UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    
}
///商品名字
- (void)addnameLabel {
    UILabel *nameLabel = [[UILabel alloc]init];
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picScrollView);
        make.top.equalTo(self.picScrollView.mas_bottomMargin).mas_offset(28);
        make.width.mas_equalTo(250);
    }];
    nameLabel.textColor = [UIColor colorNamed:@"21_49_91"];
    nameLabel.font = [UIFont systemFontOfSize:20];
}
///库存
- (void)addAmountLabel {
    UILabel *amountLabel = [[UILabel alloc]init];
    [self addSubview:amountLabel];
    _amountLabel = amountLabel;
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.picScrollView.mas_right);
            make.top.equalTo(self.picScrollView.mas_bottomMargin).mas_offset(28);
            make.width.mas_equalTo(100);
    }];
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.textColor = [UIColor colorNamed:@"21_49_91"];
    amountLabel.alpha = 0.8;
    amountLabel.font = [UIFont systemFontOfSize:13];
}
///商品说明
- (void)addtextLabel {
    UILabel *textLabel = [[UILabel alloc]init];
    [self addSubview:textLabel];
    _textLabel = textLabel;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.nameLabel);
            make.top.equalTo(self.nameLabel.mas_bottom).mas_offset(16);
            make.width.mas_equalTo(344);
    }];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor colorNamed:@"21_49_91"];
    textLabel.alpha = 0.8;
    textLabel.font = [UIFont systemFontOfSize:16];
}
///有效期
- (void)addlastdayLabel {
    _lastdayLabel = [[UILabel alloc]init];
    [self addSubview:_lastdayLabel];
    [_lastdayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLabel);
            make.top.equalTo(self.textLabel.mas_bottom).offset(8);
            make.width.mas_equalTo(300);
    }];
    _lastdayLabel.textColor = [UIColor colorNamed:@"21_49_91"];
    _lastdayLabel.alpha = 0.8;
    _lastdayLabel.font = [UIFont systemFontOfSize:13];
}
///说明
- (void)addtipsLabel {
    UILabel *tipsLabel = [[UILabel alloc]init];
    [self addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.textLabel);
            make.top.equalTo(self.lastdayLabel.mas_bottom).offset(36);
            make.width.mas_equalTo(100);
    }];
    tipsLabel.textColor = [UIColor colorNamed:@"21_49_91"];;
    tipsLabel.font = [UIFont systemFontOfSize:14];
    tipsLabel.text = @"权益说明:";
    
    _tipsContentLabel = [[UILabel alloc]init];
    _tipsContentLabel.numberOfLines = 0;
    _tipsContentLabel.textColor = [UIColor colorNamed:@"21_49_91"];
    _tipsContentLabel.alpha = 0.4;
    _tipsContentLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_tipsContentLabel];
    [_tipsContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(tipsLabel);
            make.top.equalTo(tipsLabel.mas_bottom).offset(12);
//            make.right.equalTo(self.mas_right).offset(-16);
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width * 345 / 375);
    }];
    
}

#pragma mark - getter
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        [self addnameLabel];
    }
    return _nameLabel;
}
- (UILabel *)textLabel {
    if (_textLabel == nil) {
        [self addtextLabel];
    }
    return _textLabel;
}
- (UILabel *)lastdayLabel {
    if (_lastdayLabel == nil) {
        [self addlastdayLabel];
    }
    return _lastdayLabel;
}
- (UILabel *)tipsContentLabel {
    if (_tipsContentLabel == nil) {
        [self addtipsLabel];
    }
    return _tipsContentLabel;
}
@end
