//
//  PickerModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/27.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PickerModel : NSObject
@property (nonatomic)NSArray<NSString*>*placeArray;
@property (nonatomic)NSArray<NSString*>*siHaiPlace;
@property (nonatomic)NSArray<NSString*>*ningJingPlace;
@property (nonatomic)NSArray<NSString*>*mingLiPlace;
@property (nonatomic)NSArray<NSString*>*xingYePlace;
@property (nonatomic)NSArray<NSString*>*zhiXingPlace;
@property (nonatomic)NSArray<NSArray<NSString*>*>*allArray;



///根据苑名字和几舍获取栋数字：例如参数1：知行苑，参数2：8舍，返回：16栋
-(NSString *)getNumberOfDormitoryWith: (NSString*)building andPlace:(NSString*)place;


@end

NS_ASSUME_NONNULL_END
