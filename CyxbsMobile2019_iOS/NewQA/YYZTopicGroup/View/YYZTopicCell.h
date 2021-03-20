//
//  YYZTopicCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 杨远舟 on 2021/3/7.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYZTopicDetailVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYZTopicCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *topic_logo;
@property (strong, nonatomic) IBOutlet UILabel *topic_id;
@property (strong, nonatomic) IBOutlet UILabel *topic_number;
@property (strong, nonatomic) IBOutlet UILabel *topic_introduce;
@property (strong, nonatomic) IBOutlet UIButton *topic_isFollow;




@end

NS_ASSUME_NONNULL_END
