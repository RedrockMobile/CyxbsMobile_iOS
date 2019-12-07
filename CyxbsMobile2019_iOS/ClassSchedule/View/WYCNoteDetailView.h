//
//  WYCNoteDetailView.h
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/23.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WYCNoteDetailView : UIView
+(WYCNoteDetailView *)initViewFromXib;
-(void)initWithDic:(NSDictionary *)dic;
@property (strong, nonatomic) IBOutlet UIButton *editNote;
@property (strong, nonatomic) IBOutlet UIButton *deleteNote;

@end

NS_ASSUME_NONNULL_END
