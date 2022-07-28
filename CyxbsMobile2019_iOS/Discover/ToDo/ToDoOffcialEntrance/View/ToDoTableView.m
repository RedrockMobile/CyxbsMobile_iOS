//
//  ToDoTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/8/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

//Model
#import "ToDoTableView.h"
@interface ToDoTableView()
@end

@implementation ToDoTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
        //设置cell无分割线
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.estimatedRowHeight = 64;   //设置一个预估高度
    }
    return self;
}



@end
