//
//  ChooseStudentListViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/1/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClassmatesList.h"
#import "SchedulForOneWeekController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChooseStudentListViewController : UIViewController

- (instancetype)initWithClassmatesList:(ClassmatesList *)classmatesList;

@property (nonatomic,assign)PeopleType peopleType;
@end

NS_ASSUME_NONNULL_END
