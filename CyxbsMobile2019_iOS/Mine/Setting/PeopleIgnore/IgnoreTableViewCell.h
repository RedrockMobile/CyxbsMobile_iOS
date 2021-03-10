//
//  IgnoreTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/12/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IgnoreDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface IgnoreTableViewCell : UITableViewCell
- (void)setDataWithDataModel:(IgnoreDataModel*)model;
@end

NS_ASSUME_NONNULL_END
