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

@interface MyTableViewCellWithProgress : UITableViewCell

@property (nonatomic,strong) UILabel *mainLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIView *progressBar;
@property (nonatomic,strong) UIView *progressBarHaveDone;
@property (nonatomic,strong) UILabel *progressNumberLabel;
@property (nonatomic,strong) GotoButton *gotoButton;
@property (nonatomic,strong) TaskData *data;


@end

NS_ASSUME_NONNULL_END
