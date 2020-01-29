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
@property(strong,nonatomic)NSString *answerId;
-(void)commitAnswer:(NSNumber *)questionId content:(NSString *)content imageArray:(NSArray *)imageArray;
-(void)uploadPhoto:(NSArray *)photoArray;

@end

NS_ASSUME_NONNULL_END
