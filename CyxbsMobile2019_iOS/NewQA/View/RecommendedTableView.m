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

- (instancetype)init{
    if ([super init]) {
        
//        if (@available(iOS 11.0, *)) {
//            self.backgroundColor = [UIColor colorNamed:@"QAMainPageBackGroudColor"];
//        } else {
//            self.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:243.0/255.0 blue:248.0/255.0 alpha:1];
//        }
        self.backgroundColor = [UIColor redColor];
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

