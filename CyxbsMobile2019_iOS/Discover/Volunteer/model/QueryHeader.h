//
//  QueryHeader.h
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 08/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Button_Origin_Tag 78

@interface QueryHeader : UIScrollView

@property (nonatomic,copy) NSArray * items;
@property (nonatomic,copy) void(^itemClickAtIndex)(NSInteger index);
@property NSArray <UIViewController *> *controllers;
@property (nonatomic,copy) NSMutableArray <UIButton *> *btnArray;

-(void)setSelectAtIndex:(NSInteger)index;
-(void)buttonClick:(UIButton*)button;

@end
