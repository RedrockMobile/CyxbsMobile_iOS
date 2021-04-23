//
//  GYYImageChooseCollectionViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 郭蕴尧 on 2021/1/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SZHPhotoImageView.h"
@class GYYImageChooseCollectionViewCell;

@protocol GYYImageChooseCollectionViewCellDelegate <NSObject>
- (void)imageDelegateAction:(GYYImageChooseCollectionViewCell *_Nullable)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface GYYImageChooseCollectionViewCell : UICollectionViewCell<SZHPhotoImageViewDelegate>
@property (nonatomic,weak) id<GYYImageChooseCollectionViewCellDelegate> delegate;

@property(nonatomic, strong) UIButton *addNewPhotoButton;
@property(nonatomic, strong) SZHPhotoImageView *photoImageView;

@end

NS_ASSUME_NONNULL_END
