//
//  RecommendedTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "RecommendedTableView.h"
#import "PostTableViewCell.h"
#import "PostModel.h"
#import "GKPhotoBrowser.h"
#import "GKPhoto.h"
@interface RecommendedTableView()
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PostItem *item;
@end


@implementation RecommendedTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
        } else {
            
        }
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        self.rowHeight = UITableViewAutomaticDimension;
        self.estimatedRowHeight = SCREEN_HEIGHT * 0.461;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end

