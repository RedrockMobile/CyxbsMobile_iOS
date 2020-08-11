//
//  CQUPTMapContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CQUPTMapDataItem, CQUPTMapHotPlaceItem;
@interface CQUPTMapContentView : UIView

- (instancetype)initWithFrame:(CGRect)frame andMapData:(CQUPTMapDataItem *)mapDataItem andHotPlaceItem:(CQUPTMapHotPlaceItem *)hotPlaceItem;

@end

NS_ASSUME_NONNULL_END
