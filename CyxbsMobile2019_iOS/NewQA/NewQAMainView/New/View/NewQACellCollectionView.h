//
//  NewQACellCollectionView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostItem.h"

#define Pading SCREEN_WIDTH*0.0427
#define Margin 7
#define item_num 3

NS_ASSUME_NONNULL_BEGIN

@interface NewQACellCollectionView : UICollectionView

@property (nonatomic, strong) PostItem *item;

@end

NS_ASSUME_NONNULL_END
