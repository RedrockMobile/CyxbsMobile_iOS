//
//  PageTwo.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//

#import "PageTwo.h"
#import "ZWTMacro.h"
@implementation PageTwo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _tableHeaderView = [[TableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 86-8)];
        _table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _table.showsVerticalScrollIndicator = NO;
        _table.showsHorizontalScrollIndicator = NO;
        /*
         Table默认会有一个状态栏边界offset,刘海屏44,非刘海屏20
         */
        _table.contentInset = UIEdgeInsetsMake(HEADER_H, 0, 0, 0);
        _table.backgroundColor = [UIColor colorNamed:@"#F2F3F8"];
        _table.tableHeaderView = _tableHeaderView;
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        [self addSubview:self.table];
    }
    return self;
}



@end
