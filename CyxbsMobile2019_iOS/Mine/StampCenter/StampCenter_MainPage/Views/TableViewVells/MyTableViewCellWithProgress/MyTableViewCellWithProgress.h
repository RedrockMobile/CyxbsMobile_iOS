//
//  MyTableViewCellWithProgress.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/9.
//

#import <UIKit/UIKit.h>
#import "GotoButton.h"
#import "TaskData.h"
NS_ASSUME_NONNULL_BEGIN

///带有进度条的Cell
@interface MyTableViewCellWithProgress : UITableViewCell

///主要内容
@property (nonatomic,strong) UILabel *mainLabel;
///次要内容
@property (nonatomic,strong) UILabel *detailLabel;
///进度条
@property (nonatomic,strong) UIView *progressBar;
///已完成的部分
@property (nonatomic,strong) UIView *progressBarHaveDone;
///已完成的比例
@property (nonatomic,strong) UILabel *progressNumberLabel;
///去完成按钮
@property (nonatomic,strong) GotoButton *gotoButton;
///数据
@property (nonatomic,strong) TaskData *data;
///Row
@property (nonatomic,assign) NSInteger row;


@end

NS_ASSUME_NONNULL_END
