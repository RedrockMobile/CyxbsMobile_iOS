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
@property(strong,nonatomic)NSMutableArray *dataArray;
-(void)getData;
@end

NS_ASSUME_NONNULL_END
