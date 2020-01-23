//
//  QADetailModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QADetailModel : NSObject
@property(strong,nonatomic)NSDictionary *dataDic;
-(void)getDataWithId:(NSNumber *)questionId;

@end

NS_ASSUME_NONNULL_END
