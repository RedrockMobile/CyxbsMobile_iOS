//
//  FinderToolViewItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2019/11/15.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 此类接受一个图片的名字，一个标题，和一个detai，并经他们按照一定的位置制作称为一个button
@interface FinderToolViewItem : UIButton
@property (nonatomic, copy)NSString *iconViewName;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
- (instancetype)initWithIconView: (NSString*)iconViewName Title: (NSString*)title Detail: (NSString*)detail;
@end

NS_ASSUME_NONNULL_END
