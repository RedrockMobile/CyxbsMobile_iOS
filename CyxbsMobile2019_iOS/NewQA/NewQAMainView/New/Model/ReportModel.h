//
//  ReportModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2020/12/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^Netblock)(id info);//1

@interface ReportModel : NSObject

@property (nonatomic, copy) Netblock Block;//2

- (void)ReportWithPostID:(NSNumber *)postID WithModel:(NSNumber *)model AndContent:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
