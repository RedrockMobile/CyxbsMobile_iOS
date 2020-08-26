//
//  ClassDetailViewShower.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/18.
//  Copyright © 2020 Redrock. All rights reserved.
//完成显示备忘弹窗、某课详情弹窗操作的类

#import "ClassDetailViewShower.h"
#import "ClassDetailView.h"
#import "NoteDetailView.h"
//#define Shower_scrollView_H DETAILVIEW_H-30

@interface ClassDetailViewShower()<NoteDetailViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)UIView *backViewOfScrollView;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *PC;
@end
@implementation ClassDetailViewShower

- (instancetype)init{
    self = [super init];
    if(self){
        [self addBackViewOfScrollView];
        [self addScrollView];
        [self addPC];
        UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetail)];
        [self addGestureRecognizer:TGR];
    }
    return self;
}
- (void)showDetail{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    int i,j,count;
    count = (int)self.courseDataDictArray.count;
    self.PC.numberOfPages = 0;
    self.PC.numberOfPages+=count;
    
    for (i=0; i<count; i++) {
        NSDictionary *dataDict = self.courseDataDictArray[i];
        ClassDetailView *detailView = [[ClassDetailView alloc] init];
        //已经重写了ClassDetailView的setDataDict方法，对dataDict赋值，自动完成对内部label文字的设置
        detailView.dataDict = dataDict;
        [detailView setFrame:CGRectMake(i*MAIN_SCREEN_W, 0, MAIN_SCREEN_W, DETAILVIEW_H)];
        [self.scrollView addSubview:detailView];
        
    }
    
    count = (int)self.noteDataModelArray.count;
    self.PC.numberOfPages+=count;
    for (j=0; j<count; j++) {
        
        NoteDataModel *model = self.noteDataModelArray[j];
        NoteDetailView *detailView = [[NoteDetailView alloc] init];
        detailView.delegate = self;
        [detailView setFrame:CGRectMake((i+j)*MAIN_SCREEN_W, 0, MAIN_SCREEN_W, DETAILVIEW_H)];
        //已经重写了NoteDetailView的setDataModel方法，对dataModel赋值，
        //自动完成对内部label文字的设置
        detailView.dataModel = model;
        [self.scrollView addSubview:detailView];
    }
    
    self.scrollView.contentSize = CGSizeMake((i+j)*MAIN_SCREEN_W, 0);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.backViewOfScrollView setFrame:CGRectMake(0, MAIN_SCREEN_H-DETAILVIEW_H+10, MAIN_SCREEN_W, DETAILVIEW_H+40)];
    } completion:nil];
}

- (void)hideDetail{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.backViewOfScrollView setFrame:CGRectMake(0, MAIN_SCREEN_H, MAIN_SCREEN_W, DETAILVIEW_H)];
    }completion:^(BOOL finished) {
        [self.scrollView removeAllSubviews];
        [self removeFromSuperview];
    }];
    
}

- (void)addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    [self.backViewOfScrollView addSubview:scrollView];
    
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.layer.cornerRadius = 16;
    scrollView.layer.masksToBounds = YES;
    [self.scrollView setFrame:CGRectMake(0, 0, MAIN_SCREEN_W, DETAILVIEW_H)];
}

- (void)addBackViewOfScrollView{
    UIView *view = [[UIView alloc] init];
    self.backViewOfScrollView = view;
    [self addSubview:view];
    
    view.layer.shadowOffset = CGSizeMake(0,2.5);
    view.layer.shadowRadius = 15;
    view.layer.shadowOpacity = 1;
    view.layer.cornerRadius = 8;
    [view setFrame:CGRectMake(0, MAIN_SCREEN_H, MAIN_SCREEN_W, DETAILVIEW_H)];
    //加一个空手势，避免点击弹窗后弹窗移走
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender){ }]];
    
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = [UIColor colorNamed:@"white&37_39_44"];
    } else {
        view.backgroundColor = [UIColor whiteColor];
    }
}

- (void)addPC{
    UIPageControl *PC = [[UIPageControl alloc] init];
    self.PC = PC;
    [self.backViewOfScrollView addSubview:PC];
    PC.currentPage = 0;
    PC.numberOfPages = self.courseDataDictArray.count+self.noteDataModelArray.count;
    PC.hidesForSinglePage = YES;
//    PC.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#5599FF"];
    
    if (@available(iOS 11.0, *)) {
        PC.currentPageIndicatorTintColor = [UIColor colorNamed:@"184_82_255&black"];
    } else {
        PC.currentPageIndicatorTintColor = [UIColor colorWithRed:184/255.0 green:82/255.0 blue:255/255.0 alpha:1];
    }
    PC.pageIndicatorTintColor = [UIColor colorWithHexString:@"#969696"];
    PC.hidden = NO;
    
    [PC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backViewOfScrollView);
        make.top.equalTo(self.backViewOfScrollView).offset(DETAILVIEW_H*0.82);
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.PC.currentPage = (NSInteger)self.scrollView.contentOffset.x/MAIN_SCREEN_W;
}
@end



