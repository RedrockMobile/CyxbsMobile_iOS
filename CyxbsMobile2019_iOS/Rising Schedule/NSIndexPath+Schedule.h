//
//  NSIndexPath+Schedule.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/21.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_HEADER_AUDIT_BEGIN(nullability, sendability)

// This category provides convenience methods to make it easier to use an NSIndexPath to represent a location, week and section, for use with UICollectionView For Schedule
@interface NSIndexPath (Schedule)

+ (instancetype)indexPathForLocation:(NSInteger)location inWeek:(NSInteger)week inSection:(NSInteger)section;

// Returns the index at position 0.
@property (nonatomic, readonly) NSInteger section;

// Returns the index at position 1.
@property (nonatomic, readonly) NSInteger week;

// Returns the index at position 2.
@property (nonatomic, readonly) NSInteger location;

@end

NS_HEADER_AUDIT_END(nullability, sendability)

#import <UIKit/UICollectionView.h>

@protocol ScheduleCollectionViewDataSource <NSObject>

@required

- (NSInteger)collectionView:(UICollectionView *)collectionView locationForWeek:(NSInteger)week inSection:(NSInteger)section;

@optional

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOrWeekInSection:(NSInteger)section;


@end
