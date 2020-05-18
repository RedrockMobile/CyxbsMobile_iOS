//
//  QueryViewController.h
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 05/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "volunteerItem.h"

@interface QueryViewController : BaseViewController

//@property (nonatomic, strong)VolunteeringEventItem *;
@property (nonatomic, strong)VolunteerItem *volunteer;
- (instancetype)initWithVolunteerItem: (VolunteerItem *)volunteer;

@end 
