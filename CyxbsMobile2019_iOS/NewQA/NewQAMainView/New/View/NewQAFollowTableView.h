//
//  NewQAFollowTableView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewQAFollowTableView : UITableView

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *heightArray;

@property (nonatomic, strong) PostItem *item;

@end

NS_ASSUME_NONNULL_END
