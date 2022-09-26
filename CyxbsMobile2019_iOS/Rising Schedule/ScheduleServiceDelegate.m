//
//  ScheduleServiceDelegate.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/9/10.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleServiceDelegate.h"

#import "ScheduleInteractorRequest.h"

#import "ScheduleInteractorWCDB.h"

#pragma mark - ScheduleServiceDelegate ()

@interface ScheduleServiceDelegate ()

/// <#description#>
@property (nonatomic) CGPoint contentPointWhenPanNeeded;

@end

@implementation ScheduleServiceDelegate

- (instancetype)init {
    self = [super init];
    if (self) {
        _model = [[ScheduleModel alloc] init];
    }
    return self;
}

- (void)requestAndReloadData {
    ScheduleRequestDictionary *dic = self.parameterIfNeeded;
    if (!dic) {  // 默认情况
        dic = @{
            ScheduleModelRequestStudent : @[UserItemTool.defaultItem.stuNum]
        };
    }
    
    // 由识别码请求课表数据    
    // 请求到的combineModel 不是最终可以一节节课取出来的model，是一个课程（里面包含了课程的所有周数）
    [ScheduleInteractorRequest
     request:dic
     success:^(ScheduleCombineModel * _Nonnull combineModel) {
        [self.model combineModel:combineModel];
        [self.collectionView reloadData];

        [self scrollToSection:self.model.nowWeek];

        // MARK: 本地缓存
        // 1.绑定combineModel
        ScheduleInteractorWCDB *dataBase = [[ScheduleInteractorWCDB alloc] initWithBindModel:combineModel];
        // 2.创建表格，在此期间，把combineModel的identifier作为表的表名
        [dataBase creatTable];
        // 3.把请求到的combineModel数据存到数据库中
        [dataBase saveSystemData];
        
        // MARK: 读取本地缓存
        ScheduleInteractorWCDB *db = [ScheduleInteractorWCDB getScheduleDataBaseFromSno:@"2021215154" Type:ScheduleCombineSystem];
        // 得到课表数据
        NSArray *array = [NSArray array];
        array = db.bindModel.courseAry;
        NSLog(@"🪲%lu", array.count);
    }
     failure:^(NSError * _Nonnull error) {

    }];
    
}

- (void)_pan:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self.collectionView];
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
            if (indexPath) {
                return;
            }
            
            
        } break;
            
        case UIGestureRecognizerStateChanged: {
            
        } break;
            
        default: {
            
        }
    }
}

#pragma mark - Method

- (void)scrollToSection:(NSUInteger)page {
    [self.collectionView setContentOffset:CGPointMake(page * self.collectionView.width, 0) animated:YES];
}

#pragma mark - Setter

- (void)setCollectionView:(UICollectionView *)view {
    _collectionView = view;
    
    view.delegate = self;
    [view.panGestureRecognizer addTarget:self action:@selector(_pan:)];
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

@end
