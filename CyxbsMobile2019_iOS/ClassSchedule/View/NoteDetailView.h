//
//  NoteDetailView.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteDataModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol NoteDetailViewDelegate <NSObject>
//点击修改或删除按钮后调用代理方法，代理设置为ClassDetailViewShower
- (void)hideDetail;
@end

@interface NoteDetailView : UIView
@property(nonatomic,strong)NoteDataModel *dataModel;
@property(nonatomic,weak)id<NoteDetailViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
