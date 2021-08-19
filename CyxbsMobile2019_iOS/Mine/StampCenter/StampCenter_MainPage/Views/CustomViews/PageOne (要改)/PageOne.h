//
//  PageOne.h
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//

#import <UIKit/UIKit.h>
#import "CollectionHeaderView.h"
#import "MyCollectionViewCell.h"
#import "SecondHeaderView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageOne : UIView

@property (nonatomic,strong) UICollectionView *collection;
@property (nonatomic,strong) CollectionHeaderView *collectionHeaderView;

@end

NS_ASSUME_NONNULL_END
