//
//  PostTableViewCellFrame.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCellFrame : NSObject

@property (nonatomic, assign, readonly) CGRect iconImageViewFrame;

@property (nonatomic, assign, readonly) CGRect nicknameLabelFrame;

@property (nonatomic, assign, readonly) CGRect timeLabelFrame;

@property (nonatomic, assign, readonly) CGRect funcBtnFrame;

@property (nonatomic, assign, readonly) CGRect detailLabelFrame;

@property (nonatomic, assign, readonly) CGRect collectViewFrame;

@property (nonatomic, assign, readonly) CGRect groupLabelFrame;

@property (nonatomic, assign, readonly) CGRect starBtnFrame;

@property (nonatomic, assign, readonly) CGRect commendBtnFrame;

@property (nonatomic, assign, readonly) CGRect shareBtnFrame;

@property (nonatomic, assign, readonly) CGRect IdentifyBackViewFrame;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) PostItem *item;

@end

NS_ASSUME_NONNULL_END
