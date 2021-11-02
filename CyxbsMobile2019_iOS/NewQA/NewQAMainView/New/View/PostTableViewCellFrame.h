//
//  PostTableViewCellFrame.h
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/9/16.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostTableViewCellFrame : NSObject <NSCoding>

//@property (nonatomic, assign, readonly) CGRect iconImageViewFrame;
//
//@property (nonatomic, assign, readonly) CGRect nicknameLabelFrame;
//
//@property (nonatomic, assign, readonly) CGRect timeLabelFrame;
//
//@property (nonatomic, assign, readonly) CGRect funcBtnFrame;
//
//@property (nonatomic, assign, readonly) CGRect detailLabelFrame;
//
//@property (nonatomic, assign, readonly) CGRect collectViewFrame;
//
//@property (nonatomic, assign, readonly) CGRect groupLabelFrame;
//
//@property (nonatomic, assign, readonly) CGRect starBtnFrame;
//
//@property (nonatomic, assign, readonly) CGRect commendBtnFrame;
//
//@property (nonatomic, assign, readonly) CGRect shareBtnFrame;
//
//@property (nonatomic, assign, readonly) CGRect IdentifyBackViewFrame;
//
//@property (nonatomic, assign, readonly) CGFloat cellHeight;

@property (nonatomic, strong) PostItem *item;

@property (nonatomic, strong) NSValue* iconImageViewFrameValue;

@property (nonatomic, strong) NSValue* nicknameLabelFrameValue;

@property (nonatomic, strong) NSValue* timeLabelFrameValue;

@property (nonatomic, strong) NSValue* funcBtnFrameValue;

@property (nonatomic, strong) NSValue* detailLabelFrameValue;

@property (nonatomic, strong) NSValue* collectViewFrameValue;

@property (nonatomic, strong) NSValue* groupLabelFrameValue;

@property (nonatomic, strong) NSValue* starBtnFrameValue;

@property (nonatomic, strong) NSValue* commendBtnFrameValue;

@property (nonatomic, strong) NSValue* shareBtnFrameValue;

@property (nonatomic, strong) NSValue* IdentifyBackViewFrameValue;

@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
