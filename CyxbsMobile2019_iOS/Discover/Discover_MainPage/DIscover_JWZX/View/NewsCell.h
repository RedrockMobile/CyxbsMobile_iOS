//
//  NewsCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 教务新闻页面tableView的cell，日期显示采用默认的textLabel, 主题显示采用默认的detailLabel,然后自定义了有附件的lebel
@interface NewsCell : UITableViewCell
@property (nonatomic, weak)UILabel *haveFileLabel;//有附件
@end

NS_ASSUME_NONNULL_END
