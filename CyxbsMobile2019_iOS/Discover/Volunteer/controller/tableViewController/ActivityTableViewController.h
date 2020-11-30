//
//  ActivityTableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/11/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityTableViewController : UITableViewController

@property (nonatomic, assign) BOOL vcCanScroll;
@property (nonatomic, strong) UIViewController *VC;
@property (nonatomic, strong) NSMutableArray *itemsArray;

@end

NS_ASSUME_NONNULL_END
