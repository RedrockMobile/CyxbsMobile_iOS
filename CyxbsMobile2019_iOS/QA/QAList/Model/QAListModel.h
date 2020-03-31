//
//  QAListModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAListModel : NSObject
//字典存储获取的数据，key为类型，value为对应数据
@property(strong,nonatomic)NSDictionary *dataDictionary;
- (void)loadData:(NSString *)kind page:(NSInteger)page;
@end

NS_ASSUME_NONNULL_END
