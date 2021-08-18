//
//  TODODetailViewController.h
//  ZY
//
//  Created by 欧紫浩 on 2021/8/11.
//

#import <UIKit/UIKit.h>
@class TODOModel;
NS_ASSUME_NONNULL_BEGIN

//定义block类型
typedef void (^PassValueBlock) (NSString * passedthing,NSInteger passedtime);

@interface TODODetailViewController : UIViewController

@property(nonatomic, copy) PassValueBlock passValueBlock;

///顺传代办事项名用
@property (nonatomic,strong) TODOModel *model;
///顺传时间过来
@property (nonatomic,assign) NSInteger detailtimecontent;



@end

NS_ASSUME_NONNULL_END
