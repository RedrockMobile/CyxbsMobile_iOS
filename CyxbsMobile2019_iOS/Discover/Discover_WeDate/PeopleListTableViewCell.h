//
//  PeopleListTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/30.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassmatesList.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, PeopleListTableViewCellRightBtnType) {
    PeopleListTableViewCellRightBtnTypeAdd,
    PeopleListTableViewCellRightBtnTypeDelete
};
@protocol PeopleListTableViewCellDelegateAdd <NSObject>
- (void)PeopleListTableViewCellAddBtnClickInfoDict:(NSDictionary*)infoDict;
@end
@protocol PeopleListTableViewCellDelegateDelete <NSObject>
- (void)PeopleListTableViewCellDeleteBtnClickInfoDict:(NSDictionary*)infoDict;
@end

@interface PeopleListTableViewCell : UITableViewCell
//@{@"name":@"张树洞",@"stuNum":@"201928738"}
- (instancetype)initWithInfoDict:(NSDictionary*)infoDict andRightBtnType:(PeopleListTableViewCellRightBtnType)type;

@property (nonatomic,weak)id<PeopleListTableViewCellDelegateAdd>delegateAdd;
@property (nonatomic,weak)id<PeopleListTableViewCellDelegateDelete>delegateDelete;
@end

NS_ASSUME_NONNULL_END
