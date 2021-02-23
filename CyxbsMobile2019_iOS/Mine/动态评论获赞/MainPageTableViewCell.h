//
//  MainPageTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/2/22.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainPageTableViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *timeLabel;
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end

NS_ASSUME_NONNULL_END
