//
//  HistoryCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 小艾同学 on 2022/8/1.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "HistoryCell.h"
#import "DLTimeSelectedButton.h"

@interface HistoryCell()

@property (nonatomic, strong) DLTimeSelectedButton *historyBtn;

@end

@implementation HistoryCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.historyBtn];
        
    }
    return self;
}

- (DLTimeSelectedButton *)historyBtn {
    if (_historyBtn == nil) {
        _historyBtn = [[DLTimeSelectedButton alloc] init];
    }
    return _historyBtn;
}

@end
