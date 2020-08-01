//
//  ChoosePeopleListView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeopleListTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChoosePeopleListView : UIView
- (instancetype)initWithInfoDictArray:(NSArray*)infoDictArray;
- (void)showPeopleListView;
@property (nonatomic, weak)id<PeopleListTableViewCellDelegateAdd>delegate;
@end

NS_ASSUME_NONNULL_END
