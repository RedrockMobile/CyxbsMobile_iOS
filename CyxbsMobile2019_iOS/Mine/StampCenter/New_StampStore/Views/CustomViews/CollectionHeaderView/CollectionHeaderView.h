//
//  CollectionTableView.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionHeaderView : UIView

@property (nonatomic,strong) UILabel *mainLabel;
@property (nonatomic,strong) UILabel *detailLabel;

- (void)setup;

@end

NS_ASSUME_NONNULL_END
