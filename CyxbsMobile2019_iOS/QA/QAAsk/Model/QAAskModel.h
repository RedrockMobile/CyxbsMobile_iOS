//
//  QAAskModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAAskModel : NSObject
-(void)commitAsk:(NSString *)title content:(NSString *)content kind:(NSString *)kind reward:(NSNumber *)reward disappearTime:(NSString *)disappearTime;
@end

NS_ASSUME_NONNULL_END
