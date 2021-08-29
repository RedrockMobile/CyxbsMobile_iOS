//
//  PageOne.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/14.
//

#import "PageOne.h"
#import "PrefixHeader.pch"
#import "UIView+XYView.h"
#import "ZWTMacro.h"
@implementation PageOne


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,SCREEN_WIDTH , SCREEN_HEIGHT);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.024*SCREEN_WIDTH;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 1); //required
        
        _collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:layout];
        _collection.showsVerticalScrollIndicator = NO;
        _collection.showsHorizontalScrollIndicator = NO;
        _collection.backgroundColor = [UIColor colorNamed:@"#FBFCFF"];
        _collection.decelerationRate = 0;
        [_collection registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [_collection registerClass:[SecondHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        _collectionHeaderView = [[CollectionHeaderView alloc]initWithFrame:CGRectMake(0, HEADER_H, SCREEN_WIDTH, COLLECTIONHEADER_H)];
        UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_H + COLLECTIONHEADER_H)];
        v.backgroundColor = [UIColor colorNamed:@"#F2F3F8"];
        [v addSubview:_collectionHeaderView];
        [_collection addSubview:v];
        
        [self addSubview:self.collection];
    }
    return self;
}




@end
