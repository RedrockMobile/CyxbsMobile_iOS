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

@interface MyCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *goodsImageView;
@property (nonatomic,strong) UILabel *mianLbl;
@property (nonatomic,strong) UILabel *stockLbl;
@property (nonatomic,strong) UIImageView *stampImageView;
@property (nonatomic,strong) UILabel *stampRequirementLbl;
@property (nonatomic,strong) UIButton *exchangeBtn;
@property (nonatomic,strong) GoodsData *data;
@property (nonatomic,strong) UIButton *showBtn;


@end

NS_ASSUME_NONNULL_END
