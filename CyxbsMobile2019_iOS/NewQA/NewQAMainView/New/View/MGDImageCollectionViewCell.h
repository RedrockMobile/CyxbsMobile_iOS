//
//  MGDImageCollectionViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/2/8.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGDImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSArray *imagesArray;

@end

NS_ASSUME_NONNULL_END
