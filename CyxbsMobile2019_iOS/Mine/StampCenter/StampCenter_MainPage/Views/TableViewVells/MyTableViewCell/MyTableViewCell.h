//
//  MyTableViewCell.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/9.
//

#import <UIKit/UIKit.h>
#import "GotoButton.h"
NS_ASSUME_NONNULL_BEGIN

///MyTableViewCell
@interface MyTableViewCell : UITableViewCell

///主要内容
@property (nonatomic,strong) UILabel *mainLabel;
///次要内容
@property (nonatomic,strong) UILabel *detailLabel;
///去完成按钮
@property (nonatomic,strong) GotoButton *gotoButton;

@end

NS_ASSUME_NONNULL_END
