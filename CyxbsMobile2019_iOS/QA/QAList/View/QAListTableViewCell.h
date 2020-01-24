//
//  QAListTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property(weak,nonatomic)IBOutlet UILabel *content;
@property(weak,nonatomic)IBOutlet UILabel *date;
@property(weak,nonatomic)IBOutlet UILabel *answerNum;
@property(weak,nonatomic)IBOutlet UILabel *integralNum;
@property(weak,nonatomic)IBOutlet UILabel *viewNum;
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property(weak,nonatomic)IBOutlet UIImageView *answerIcon;
@property(weak,nonatomic)IBOutlet UIImageView *integralIcon;
@property(weak,nonatomic)IBOutlet UIImageView *viewIcon;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
