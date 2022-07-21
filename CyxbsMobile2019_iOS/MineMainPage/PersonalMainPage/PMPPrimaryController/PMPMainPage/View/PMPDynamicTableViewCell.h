//
//  PMPDynamicTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PostTableViewCell.h"

#import "PMPPostItem.h"

NS_ASSUME_NONNULL_BEGIN

/// 这是主页邮问的 cell 子类. 
@interface PMPDynamicTableViewCell : PostTableViewCell

+ (NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
