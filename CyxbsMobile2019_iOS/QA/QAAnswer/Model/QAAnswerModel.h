//
//  QAAnswerModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAAnswerModel : NSObject
-(void)commitAnswer:(NSNumber *)questionId content:(NSString *)content;
@end

NS_ASSUME_NONNULL_END
