//
//  PMPDynamicTableViewCell.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPDynamicTableViewCell.h"

@implementation PMPDynamicTableViewCell

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

@end
