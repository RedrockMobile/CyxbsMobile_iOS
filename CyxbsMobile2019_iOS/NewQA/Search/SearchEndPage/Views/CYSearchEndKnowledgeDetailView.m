//
//  CYSearchEndKnowledgeDetailView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/3/18.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "CYSearchEndKnowledgeDetailView.h"


@interface CYSearchEndKnowledgeDetailView()
/// 知识库标题的label
@property (nonatomic, strong) UILabel *titleLbl;
/// 展示内容的textView‘
@property (nonatomic, strong) UITextView *contentTextView;

/// 展示来源的label
@property (nonatomic, strong) UILabel *sourceLabl;

///删除动态知识库View的按钮
@property(nonatomic, strong) UIButton *clearBtn;

@end
@implementation CYSearchEndKnowledgeDetailView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorNamed:@"TableViewBackColor"];
//        self.backgroundColor = [UIColor whiteColor];
        
        //titleLbl
        [self addSubview:self.titleLbl];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(MAIN_SCREEN_W * 0.048);
            make.top.equalTo(self).offset(MAIN_SCREEN_H * 0.0367);
        }];
        
        //ContentTextView
        [self addSubview:self.contentTextView];
        [self.contentTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLbl);
//            make.top.equalTo(self.titleLbl.mas_bottom).offset(MAIN_SCREEN_H * 0.0202);
            make.top.equalTo(self.titleLbl.mas_bottom).offset(17);
            make.right.equalTo(self).offset(- MAIN_SCREEN_W * 0.0427);
            make.bottom.equalTo(self).offset(- MAIN_SCREEN_H * 0.0375);
        }];
        
        [self addSubview:self.clearBtn];
        [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentTextView);
            make.bottom.equalTo(self.titleLbl);
            make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W * 0.04, MAIN_SCREEN_W * 0.04));
        }];
    }
    return self;
}

#pragma mark- event response
- (void)clearSelf{
    [self.delegate deleteKnowledgeDetaileview:self];
}
#pragma mark- getter
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.font = [UIFont fontWithName:PingFangSCBold size:16];
        titleLbl.textColor = [UIColor colorNamed:@"RGB17_44_87&&240_240_242"];
        titleLbl.backgroundColor = [UIColor clearColor];
        //设置字体以及颜色
        _titleLbl = titleLbl;
    }
    return _titleLbl;
}

- (UITextView *)contentTextView{
    if (!_contentTextView) {
        UITextView *contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        contentTextView.textColor = [UIColor colorNamed:@"RGB85_108_137&&181_181_181"];
        contentTextView.font = [UIFont fontWithName:PingFangSCMedium size:13];
        contentTextView.backgroundColor = [UIColor clearColor];
        contentTextView.scrollEnabled = YES;
        contentTextView.userInteractionEnabled = YES;
        contentTextView.editable = NO;
        _contentTextView = contentTextView;
        
    }
    return _contentTextView;
}

- (UIButton *)clearBtn{
    if (!_clearBtn) {
        _clearBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_clearBtn setImage:[UIImage imageNamed:@"白色叉叉"] forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

#pragma mark- setter
- (void)setModel:(CYSearchEndKnowledgeDetailModel *)model{
    _model = model;
    self.titleLbl.text = model.titleStr;
    self.contentTextView.text = model.contentStr;
}
@end
