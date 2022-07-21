//
//  PMPIdentityTableViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDCardTableViewCell.h"
#import "IDDataManager.h"
#import "UIViewController+CanScroll.h"

NS_ASSUME_NONNULL_BEGIN

@interface PMPIdentityTableViewController : UITableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
                        redid:(NSString *)redid;

@end

NS_ASSUME_NONNULL_END
