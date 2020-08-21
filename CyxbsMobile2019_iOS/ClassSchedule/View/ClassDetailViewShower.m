//
//  ClassDetailViewShower.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassDetailViewShower.h"
#import "ClassDetailView.h"
#import "NoteDetailView.h"
//#define Shower_scrollView_H DETAILVIEW_H-30

@interface ClassDetailViewShower()
@property(nonatomic,strong)UIView *backViewOfScrollView;
@property(nonatomic,strong)UIScrollView *scrollView;
@end
@implementation ClassDetailViewShower

- (instancetype)init{
    self = [super init];
    if(self){
        [self addBackViewOfScrollView];
        [self addScrollView];
        
        UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetail)];
        [self addGestureRecognizer:TGR];
    }
    return self;
}
- (void)showDetail{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    int i,j,count;
    count=(int)self.courseDataDictArray.count;
    for (i=0; i<count; i++) {
        NSDictionary *dataDict = self.courseDataDictArray[i];
        ClassDetailView *detailView = [[ClassDetailView alloc] init];
        //已经重写了ClassDetailView的setDataDict方法，对dataDict赋值，自动完成对内部label文字的设置
        detailView.dataDict = dataDict;
        [detailView setFrame:CGRectMake(i*MAIN_SCREEN_W, 0, MAIN_SCREEN_W, DETAILVIEW_H)];
        [self.scrollView addSubview:detailView];
        
    }
    
    count = (int)self.noteDataModelArray.count;
    
    for (j=0; j<count; j++) {
        
        NoteDataModel *model = self.noteDataModelArray[j];
        NoteDetailView *detailView = [[NoteDetailView alloc] init];
        [detailView setFrame:CGRectMake((i+j)*MAIN_SCREEN_W, 0, MAIN_SCREEN_W, DETAILVIEW_H)];
        //已经重写了NoteDetailView的setDataModel方法，对dataModel赋值，
        //自动完成对内部label文字的设置
        detailView.dataModel = model;
        [self.scrollView addSubview:detailView];
    }
    
    self.scrollView.contentSize = CGSizeMake((i+j)*MAIN_SCREEN_W, 0);
    [UIView animateWithDuration:0.5 animations:^{
        [self.backViewOfScrollView setFrame:CGRectMake(0, MAIN_SCREEN_H-DETAILVIEW_H+10, MAIN_SCREEN_W, DETAILVIEW_H+40)];
    }];
}

- (void)hideDetail{
    [UIView animateWithDuration:0.3 animations:^{
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

@end



