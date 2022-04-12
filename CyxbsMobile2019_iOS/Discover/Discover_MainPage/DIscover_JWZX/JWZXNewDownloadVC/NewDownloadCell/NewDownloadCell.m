//
//  NewDownloadCell.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "NewDownloadCell.h"

#pragma mark - NewDownloadCell ()

@interface NewDownloadCell ()

/// 名字的Lab
@property (nonatomic, strong) UILabel *nameLab;

/// 下载的Btn
@property (nonatomic, strong) UIButton *downLoadBtn;

@end

#pragma mark - NewDownloadCell

@implementation NewDownloadCell

#pragma mark - Life cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        self.contentView.backgroundColor = UIColor.clearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.downLoadBtn];
        [self.contentView addSubview:self.nameLab];
    }
    return self;
}

#pragma mark - Method

- (void)drawWithTitle:(NSString *)title {
    self.nameLab.text = title;
}

- (NSIndexPath *)getIndexPath {
    return [[self getTableView] indexPathForCell:self];
}

- (UITableView *)getTableView {
    UIView *superView = self.superview;

    while (superView && ![superView isKindOfClass:[UITableView class]]) {
        superView = superView.superview;
    }

    if (superView) {
        return (UITableView *)superView;
    }

    return nil;
}

// MARK: SEL

- (void)NewDownloadCell_btnSelected {
    if (self.delegate) {
        [self.delegate newDownloadCell:self shouldDownLoadAtIndex:self.getIndexPath.row];
    }
}

// MARK: Rewrite

- (void)drawRect:(CGRect)rect {
    self.downLoadBtn.top = 10;
    [self.downLoadBtn stretchBottom_toPointY:self.contentView.SuperBottom offset:10];
    self.downLoadBtn.width = self.downLoadBtn.height;
    self.downLoadBtn.right = self.contentView.SuperRight - 10;
    
    self.nameLab.top = self.downLoadBtn.top;
    [self.nameLab stretchRight_toPointX:self.downLoadBtn.left offset:10];
    self.nameLab.height = self.downLoadBtn.height;
}

#pragma mark - Getter

- (UILabel *)nameLab {
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.width - 28, 28)];
        _nameLab.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
        _nameLab.backgroundColor = UIColor.clearColor;
        _nameLab.font = [UIFont fontWithName:@".PingFang SC" size:18];
    }
    return _nameLab;
}

- (UIButton *)downLoadBtn {
    if (_downLoadBtn == nil) {
        _downLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        [_downLoadBtn setImage:[UIImage imageNamed:@"fileDownload"] forState:UIControlStateNormal];
        _downLoadBtn.userInteractionEnabled = YES;
        [_downLoadBtn addTarget:self action:@selector(NewDownloadCell_btnSelected) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downLoadBtn;
}

@end
