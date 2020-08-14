//
//  CQUPTMapContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQUPTMapContentViewDelegate <NSObject>

- (void)backButtonClicked;

- (void)requestStarData;

- (void)searchPlaceWithString:(NSString *_Nullable)string;

- (void)transitionViewDragged:(UIPanGestureRecognizer *_Nonnull)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@class CQUPTMapDataItem, CQUPTMapHotPlaceItem, CQUPTMapStarPlaceItem, CQUPTMapSearchItem;
@interface CQUPTMapContentView : UIView

@property (nonatomic, weak) id<CQUPTMapContentViewDelegate> delegate;

@property (nonatomic, weak) UIScrollView *mapScrollView;
@property (nonatomic, weak) UIImageView *mapView;


- (instancetype)initWithFrame:(CGRect)frame andMapData:(CQUPTMapDataItem *)mapDataItem andHotPlaceItemArray:(NSArray<CQUPTMapHotPlaceItem *> *)hotPlaceItemArray;

- (void)starPlaceListRequestSuccess:(NSArray <CQUPTMapStarPlaceItem *> *)starPlaceArray;

- (void)searchPlaceSuccess:(NSArray<CQUPTMapSearchItem *> *)placeIDArray;

@end

NS_ASSUME_NONNULL_END
