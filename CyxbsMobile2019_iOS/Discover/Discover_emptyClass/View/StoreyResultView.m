//
//  StoreyResultView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/14.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "StoreyResultView.h"
#define TEXTCOLOR [UIColor colorWithRed:18/255.0 green:45/255.0 blue:85/255.0 alpha:1]
@interface StoreyResultView()
@property (nonatomic)NSMutableArray<UILabel *>*labelArray;
@end
@implementation StoreyResultView
- (instancetype)initWithStoreyString:(NSString *)storeyString {
    if(self = [super init]){
        UILabel *storeyLabel = [[UILabel alloc]init];
        self.storeyLabel = storeyLabel;
        self.storeyLabel.text = storeyString;
    }
    return self;
}
- (void)addTitleView {
    [self addSubview:self.storeyLabel];
    self.storeyLabel.font = [UIFont fontWithName:PingFangSCBold size:15];

    self.storeyLabel.textColor = TEXTCOLOR;
    [self.storeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(17);
        make.top.equalTo(self).offset(0);
    }];
}
- (void)addDetailView {
    NSMutableArray <UILabel *> *labelArray = [NSMutableArray array];
    self.labelArray = labelArray;

    for(int i = 0 ; i < self.StoreyArray.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        label.text = self.StoreyArray[i];
        label.textColor = TEXTCOLOR;
        label.font = [UIFont fontWithName:PingFangSCRegular size:13];
        [labelArray addObject:label];
        [self addSubview:label];
        if(i%6 == 0) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.storeyLabel.mas_right).offset(14);
                make.top.equalTo(self.storeyLabel).offset(i/6 * 25);
            }];
        }else {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.labelArray[i-1].mas_left).offset(50);
                make.top.equalTo(self.labelArray[i-1]);
            }];
        }
    }
}


- (void)refreshUI {
    [self addTitleView];
    [self addDetailView];
}
- (void)clearUI {
    [self.storeyLabel removeFromSuperview];
    for (UILabel *label in self.labelArray) {
        [label removeFromSuperview];
    }
}
@end
