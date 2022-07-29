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
            self.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F1F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
            self.separatorColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#E2E8EE" alpha:1] darkColor:[UIColor colorWithHexString:@"#343434" alpha:1]];
        } else {
            self.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
        }
        self.rowHeight = UITableViewAutomaticDimension;
        self.estimatedRowHeight = SCREEN_HEIGHT * 0.461;
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            if (@available(iOS 13.0, *)) {
                self.automaticallyAdjustsScrollIndicatorInsets = NO;
            } else {
                // Fallback on earlier versions
            }
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end

