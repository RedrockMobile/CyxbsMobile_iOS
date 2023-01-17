//
//  ScheduleCollectionViewDataSource.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/12/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#if __has_include(<UIKit/UICollectionView.h>)
#import <UIKit/UICollectionView.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

NS_SWIFT_UI_ACTOR
@protocol ScheduleCollectionViewDataSource <UICollectionViewDataSource>

@optional

/// 返回一周所拥有的装饰视图数量，默认返回0
/// - Parameters:
///   - collectionView: 视图
///   - kind: 名字
///   - section: 第几周
- (NSInteger)collectionView:(UICollectionView *)collectionView
numberOfSupplementaryOfKind:(NSString *)kind
                  inSection:(NSInteger)section;

@end

NS_HEADER_AUDIT_END(nullability, sendability)

#endif
