//
//  MyTableViewCell.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/9.
//

#import <UIKit/UIKit.h>
#import "GotoButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *mainLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) GotoButton *gotoButton;

@end

NS_ASSUME_NONNULL_END
