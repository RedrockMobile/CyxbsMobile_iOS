//
//  NewDetailViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/2/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewDetailViewController : UIViewController

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithNewsID:(NSString *)newsID
                          date:(NSString *)time
                         title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
