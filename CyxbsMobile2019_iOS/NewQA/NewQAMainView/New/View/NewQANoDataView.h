//
//  NewQANoDataView.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/10/14.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewQANoDataView : UIView

@property (nonatomic, strong) UIImageView *nodataImageView;

@property (nonatomic, strong) UILabel *nodataLabel;

- (instancetype)initWithNodataImage:(UIImage *)image AndText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
