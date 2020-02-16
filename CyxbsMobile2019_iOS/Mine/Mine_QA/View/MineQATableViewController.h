//
//  MineQATableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineQAController;
@interface MineQATableViewController : UITableViewController

@property (nonatomic, weak) MineQAController *superController;
@property (nonatomic, copy) NSString *subTittle;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *itemsArray;

- (instancetype)initWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle;

@end

NS_ASSUME_NONNULL_END
