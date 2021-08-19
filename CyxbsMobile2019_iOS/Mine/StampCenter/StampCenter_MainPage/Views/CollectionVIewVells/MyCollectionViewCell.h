//
//  MyCollectionViewCell.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/7.
//

#import <UIKit/UIKit.h>
#import "GoodsData.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ExchangeDelegate <NSObject>
@required
- (void)exchange;

@end
///MyCollectionViewCell
@interface MyCollectionViewCell : UICollectionViewCell

///图片
@property (nonatomic,strong) UIImageView *goodsImageView;
///介绍
@property (nonatomic,strong) UILabel *mainLbl;
///库存
@property (nonatomic,strong) UILabel *stockLbl;
///邮票icon
@property (nonatomic,strong) UIImageView *stampImageView;
///价格
@property (nonatomic,strong) UILabel *stampRequirementLbl;
///兑换按钮
@property (nonatomic,strong) UIButton *exchangeBtn;
///数据
@property (nonatomic,strong) GoodsData *data;
///整体按钮
@property (nonatomic,strong) UIButton *showBtn;
///frame
@property (nonatomic,assign) CGRect myFrame;


@end

NS_ASSUME_NONNULL_END
