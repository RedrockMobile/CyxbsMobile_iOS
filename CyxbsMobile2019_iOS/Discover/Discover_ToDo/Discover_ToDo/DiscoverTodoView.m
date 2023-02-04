//
//  DiscoverTodoView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/8/6.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "DiscoverTodoView.h"
#import "DiscoverTodoTableViewCell.h"
#import "TodoSyncTool.h"
#import "TodoConflictStateView.h"

@interface DiscoverTodoView ()<
    UITableViewDelegate,
    UITableViewDataSource
>

/// 显示“邮子清单”四个字的label
@property (nonatomic, strong)UILabel* titleLabel;

/// 加号按钮，点击后添加事项
@property (nonatomic, strong)UIButton* addBtn;

/// 显示3个未完成的todo的TableView
@property (nonatomic, strong)UITableView* todoListTableView;

/// 没有任何todo时显示“还没有待做事项哦～块去添加吧！”的提示文字
@property (nonatomic, strong)UILabel* nothingLabel;

@property (nonatomic, strong)NSArray<TodoDataModel*>* dataModelArr;

@property (nonatomic, assign)CGFloat viewHeight;

@property(nonatomic, strong)TodoConflictStateView *conflictTipView;
@end

@implementation DiscoverTodoView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataModelArr = @[];
        
//        if (@available(iOS 11.0, *)) {
//            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F8F9FC" alpha:1] darkColor:[UIColor colorWithHexString:@"#1D1D1D" alpha:1]];
//        } else {
//            self.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
//        }
        
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F7" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        
        self.layer.cornerRadius = 20;
        
        [self addMaskView];
        [self addTitleLabel];
        [self addAddBtn];
        self.nothingLabel.alpha = 1;
        [self addTodoListTableView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldDrawImg:) name:@"DiscoverTodoTableViewCellCheckMarkBtnClicked" object:nil];
    }
    return self;
}

- (void)shouldDrawImg:(NSNotification*)noti {
    DiscoverTodoTableViewCell* cell = noti.object;
    [self.delegate todoView:self didAlterWithModel:cell.dataModel];
    [self reloadData];
}

- (void)reloadData {
    self.dataModelArr = [self.dataSource dataModelToShowForDiscoverTodoView:self];
    [self.todoListTableView reloadData];
    int nothingLabelAlpha;
    if (self.dataModelArr.count==0) {
        self.viewHeight = 0.37*SCREEN_WIDTH;
        nothingLabelAlpha = 1;
    }else {
        nothingLabelAlpha = 0;
        self.viewHeight = 0.155*SCREEN_WIDTH;
        for (TodoDataModel *model in self.dataModelArr) {
            if ([model.timeStr isEqualToString:@""]||model.todoState==TodoDataModelStateOverdue) {
                self.viewHeight += 0.115*SCREEN_WIDTH;
            }else {
                self.viewHeight += 0.155*SCREEN_WIDTH;
            }
        }
    }
    
    [UIView animateWithDuration:1 animations:^{
        self.nothingLabel.alpha = nothingLabelAlpha;
        self.todoListTableView.alpha = 1-nothingLabelAlpha;
    }];
    
    [self setNeedsLayout];
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)showConflictWithServerTime:(NSInteger)serverTime localTime:(NSInteger)localTime {
    if (self.conflictTipView==nil) {
        [self addConflictTipViewWithServerTime:serverTime localTime:localTime];
    }
    
    if (self.conflictTipView.alpha!=1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.conflictTipView.alpha = 1;
        }];
    }
    
    self.viewHeight = 0.5786666667*SCREEN_WIDTH;
    [self setNeedsLayout];
    
    [UIView animateWithDuration:0.5 animations:^{
        [self layoutIfNeeded];
    }];
}

- (void)localBtnClicked {
    [self.delegate localBtnClickedTodoView:self];
}

- (void)cloudBtnClicked {
    [self.delegate cloudBtnClickedTodoView:self];
}

- (void)removeConflictView {
    if (self.conflictTipView.alpha != 0) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.conflictTipView setAlpha:0];
        }];
    }
    [self reloadData];
}

- (NSString*)getTimeStrWithTimeStamp:(NSInteger)t {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:t]];
}
//MARK: - 初始化UI的操作：
/// 添加一个View遮住底部多出来的圆角
- (void)addMaskView {
    UIView* view = [[UIView alloc] init];
    [self addSubview:view];
    
    view.backgroundColor = [self backgroundColor];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@20);
    }];
}

/// 添加显示“邮子清单”四个字的label
- (void)addTitleLabel {
    UILabel* label = [[UILabel alloc] init];
    [self addSubview:label];
    self.titleLabel = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.03733333333*SCREEN_WIDTH);
        make.top.equalTo(self).offset(0.03448275862*SCREEN_WIDTH);
    }];
    
    label.text = @"邮子清单";
    label.font = [UIFont fontWithName:PingFangSCBold size:18];
    label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
}

/// 添加一个加号按钮，点击这个加号按钮后调用代理方法，来添加事项，代理是DiscoverViewController
- (void)addAddBtn {
    UIButton* btn = [[UIButton alloc] init];
    self.addBtn = btn;
    [self addSubview:btn];
    
    [btn setImage:[UIImage imageNamed:@"todoAddBtn"] forState:UIControlStateNormal];
//    NewQAHud
    CGFloat gap = 0.01*SCREEN_WIDTH;
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-0.04*SCREEN_WIDTH);
        make.centerY.equalTo(self.titleLabel);
        make.width.height.mas_equalTo(0.048*SCREEN_WIDTH + 2*gap);
    }];
    
    [btn setImageEdgeInsets:UIEdgeInsetsMake(gap, gap, gap, gap)];
    
    [btn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

/// 没有事项时，用来占位
- (UILabel*)nothingLabel {
    if (_nothingLabel==nil) {
        UILabel* label = [[UILabel alloc] init];
        [self addSubview:label];
        _nothingLabel = label;
        
//        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#5E5F64" alpha:1]];
        
//        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        label.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        label.font = [UIFont fontWithName:PingFangSCMedium size:15];
        label.text = @"还没有待做事项哦～快去添加吧！";
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).mas_offset(0.1034482759*SCREEN_HEIGHT);
            make.left.equalTo(self).mas_offset(0.1866666667*SCREEN_WIDTH);
        }];
    }
    return _nothingLabel;
}

/// 添加tableView
- (void)addTodoListTableView {
    UITableView* tableView = [[UITableView alloc] init];
    self.todoListTableView = tableView;
    [self addSubview:tableView];
    
    tableView.allowsSelection = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.scrollEnabled = NO;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.addBtn.mas_bottom).offset(0.03078817734*SCREEN_HEIGHT);
        make.bottom.equalTo(self);
    }];
    tableView.showsVerticalScrollIndicator = NO;
}

/// MARK: - tableviwe的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataModelArr.count;
    return self.dataModelArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscoverTodoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"todoListTableViewCell"];
    if (cell==nil) {
        cell = [[DiscoverTodoTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"todoListTableViewCell"];
    }
    [cell setDataModel:self.dataModelArr[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoDataModel *model = self.dataModelArr[indexPath.row];
    if ([model.timeStr isEqualToString:@""]||model.todoState==TodoDataModelStateOverdue) {
        return 0.115*SCREEN_WIDTH;
    }else {
        return 0.155*SCREEN_WIDTH;
    }
}

- (void)addConflictTipViewWithServerTime:(NSInteger)serverTime localTime:(NSInteger)localTime {
    TodoConflictStateView *view = [[TodoConflictStateView alloc] init];
    self.conflictTipView = view;
    [self addSubview:view];
    
    NSString *serverTimeStr = [self getTimeStrWithTimeStamp:serverTime];
    NSString *localTimeStr = [self getTimeStrWithTimeStamp:localTime];
    NSString *tipStr = [NSString stringWithFormat:@"掌友，你的云同步存档 %@ 和本地存档 %@ 存在冲突，请选择一个存档予以保留", serverTimeStr, localTimeStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:tipStr];


    [attStr addAttributes:@{
        NSFontAttributeName:[UIFont fontWithName:PingFangSCRegular size:15],
        NSForegroundColorAttributeName:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]]
    } range:NSMakeRange(0, attStr.length)];
    [attStr addAttributes:@{
        NSForegroundColorAttributeName:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2923D2" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]]
    } range:[tipStr rangeOfString:serverTimeStr]];
    
    [attStr addAttributes:@{
        NSForegroundColorAttributeName:[UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#2923D2" alpha:1] darkColor:[UIColor colorWithHexString:@"#2CDEFF" alpha:1]]
    } range:[tipStr rangeOfString:localTimeStr]];
    
    view.tipMsgLabel.attributedText = attStr;
    
    [view.localBtn addTarget:self action:@selector(localBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [view.cloudBtn addTarget:self action:@selector(cloudBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addBtn.mas_bottom);
        make.left.bottom.right.equalTo(self);
    }];
}

//MARK: - 点击按钮后调用：
/// 加号按钮点击后调用
- (void)addBtnClicked {
    [self.delegate addBtnClickedTodoView:self];
    [self reloadData];
}

- (void)layoutSubviews {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.viewHeight);
    }];
}

/// 折叠动画，视觉嫌他太丑，ban掉了，但是我舍不得删
- (void)flodAnimationWithCell:(UITableViewCell*)cell {
    CGRect cellFrame = [cell convertRect:cell.bounds toView:self.todoListTableView];
    CGFloat bottomImgY = cellFrame.origin.y+cellFrame.size.height;
    
    UIImageView* cellImgView = [self addImgViewOfView:self.todoListTableView clip:cellFrame];
    UIImageView* bottomImgView = [self addImgViewOfView:self.todoListTableView clip:CGRectMake(0, bottomImgY, self.todoListTableView.width, self.todoListTableView.height-bottomImgY)];
    
    cellImgView.layer.anchorPoint = CGPointMake(0.5, 0);
    cellImgView.layer.position = CGPointMake(cellImgView.layer.position.x, cellImgView.layer.position.y-cellImgView.frame.size.height/2);
    [UIView animateWithDuration:1 animations:^{
        cellImgView.transform = CGAffineTransformMakeScale(1, 0.01);
        bottomImgView.transform = CGAffineTransformMakeTranslation(0, -cellFrame.size.height);
    }completion:^(BOOL finished) {
        [self reloadData];
        [cellImgView removeFromSuperview];
        [bottomImgView removeFromSuperview];
    }];
}
- (UIImageView*)addImgViewOfView:(UIView*)view clip:(CGRect)rect {
    UIImageView* imgView = [[UIImageView alloc] initWithImage:[self getImgOfView:view clip:rect]];
    imgView.frame = rect;
    [self.todoListTableView addSubview:imgView];
    [imgView sizeToFit];
    return imgView;
}
/// 在view表示的矩形区域内，截取frame为rect的矩形区域的图片
- (UIImage*)getImgOfView:(UIView*)view clip:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, -rect.origin.x, -rect.origin.y);
    [view.layer renderInContext:ctx];
    
    UIImage* img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
