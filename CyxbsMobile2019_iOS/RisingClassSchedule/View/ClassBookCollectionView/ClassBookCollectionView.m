//
//  ClassBookCollectionView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/6/13.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ClassBookCollectionView.h"

#pragma mark - ClassBookCollectionView ()

@interface ClassBookCollectionView ()

@end

#pragma mark - ClassBookCollectionView

@implementation ClassBookCollectionView

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.directionalLockEnabled = YES;
        self.pagingEnabled = YES;
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesture:)];
        [self addGestureRecognizer:longGesture];
    }
    return self;
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.classBook_delegate classBook:self didTapEmptyItemAtWeekIndexPath:[NSIndexPath indexPathWithIndex:1] ofRangeIndexPath:[NSIndexPath indexPathWithIndex:1]];
}

#pragma mark - Method

// MARK: SEL

- (void)longGesture:(UILongPressGestureRecognizer *)longGesture {
    //判断手势状态
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan: {
            //判断手势落点位置是否在路径上
            NSIndexPath *indexPath = [self indexPathForItemAtPoint:[longGesture locationInView:self]];
            if (indexPath == nil) {
                break;
            }
            //在路径上则开始移动该路径上的cell
            [self beginInteractiveMovementForItemAtIndexPath:indexPath];
        } break;
            
        case UIGestureRecognizerStateChanged: {
            //移动过程当中随时更新cell位置
            [self updateInteractiveMovementTargetPosition:[longGesture locationInView:self]];
        }  break;
            
        case UIGestureRecognizerStateEnded: {
            //移动结束后关闭cell移动
            [self endInteractiveMovement];
        }  break;
            
        default: {
            [self cancelInteractiveMovement];
        } break;
    }
}

@end
