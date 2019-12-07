//
//  WYCShowDetailView.h
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/22.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol WYCShowDetailDelegate <NSObject>
@required
- (void)clickEditNoteBtn:(NSDictionary *)dic;
- (void)clickDeleteNoteBtn:(NSDictionary *)dic;
@end

@interface WYCShowDetailView : UIView
@property (nonatomic, weak) id<WYCShowDetailDelegate> chooseClassListDelegate;

@property (nonatomic, copy) NSString *classNum;
@property (nonatomic, strong) NSDictionary *remind;
- (void)initViewWithArray:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
