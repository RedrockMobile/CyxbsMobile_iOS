//
//  MineQATableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineQATableViewController : UITableViewController

@property (nonatomic, copy) NSString *subTittle;

- (instancetype)initWithTitle:(NSString *)title andSubTitle:(NSString *)subTitle;

@end

NS_ASSUME_NONNULL_END
