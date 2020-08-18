//
//  ClassDetailViewShower.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/18.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassDetailViewShower.h"
#import "ClassDetailView.h"
//#define Shower_scrollView_H DETAILVIEW_H-30

@interface ClassDetailViewShower()
@property(nonatomic,strong)UIView *backViewOfScrollView;
@property(nonatomic,strong)UIScrollView *scrollView;
@end
@implementation ClassDetailViewShower

- (instancetype)init{
    self = [super init];
    if(self){
        UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetail)];
        [self addGestureRecognizer:TGR];
    }
    return self;
}
- (void)showDetailWithCourseDataDict:(NSArray *)courseDataDictArray{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self.backViewOfScrollView setFrame:CGRectMake(0, MAIN_SCREEN_H, MAIN_SCREEN_W, DETAILVIEW_H)];
    [self addSubview:self.backViewOfScrollView];
    [self.scrollView setFrame:CGRectMake(0, 0, MAIN_SCREEN_W, DETAILVIEW_H)];
    
    [self.backViewOfScrollView addSubview:self.scrollView];
    
    for (int i=0;i<courseDataDictArray.count;i++) {
        NSDictionary *dataDict = courseDataDictArray[i];
        ClassDetailView *detailView = [[ClassDetailView alloc] init];
        //已经重写了self.detailView的setDataDict方法，对dataDict赋值，自动完成对内部label文字的设置
        detailView.dataDict = dataDict;
        [detailView setFrame:CGRectMake(i*MAIN_SCREEN_W, 0, MAIN_SCREEN_W, DETAILVIEW_H)];
        [self.scrollView addSubview:detailView];
    }
    
        self.scrollView.contentSize = CGSizeMake(courseDataDictArray.count*MAIN_SCREEN_W, 0);
        self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [self.backViewOfScrollView setFrame:CGRectMake(0, MAIN_SCREEN_H-DETAILVIEW_H+10, MAIN_SCREEN_W, DETAILVIEW_H+40)];
        }];
    
}

- (void)hideDetail{
    [UIView animateWithDuration:0.3 animations:^{
        [self setFrame:CGRectMake(0, DETAILVIEW_H-30, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    }completion:^(BOOL finished) {
        [self removeAllSubviews];
        [self removeFromSuperview];
        [self setFrame:CGRectMake(0, 0, MAIN_SCREEN_W, MAIN_SCREEN_H)];
    }];
    
}

- (UIScrollView *)scrollView{
    if(_scrollView==nil){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.layer.cornerRadius = 16;
        _scrollView.layer.masksToBounds = YES;
    }
    return _scrollView;
}

- (UIView *)backViewOfScrollView{
    if(_backViewOfScrollView==nil){
        UIView *view = [[UIView alloc] init];
        view.layer.shadowOffset = CGSizeMake(0,2.5);
        view.layer.shadowRadius = 15;
        view.layer.shadowOpacity = 1;
        view.layer.cornerRadius = 8;
        
        if (@available(iOS 11.0, *)) {
            view.backgroundColor = [UIColor colorNamed:@"white&37_39_44"];
        } else {
            view.backgroundColor = [UIColor whiteColor];
        }
        _backViewOfScrollView = view;
    }
    return _backViewOfScrollView;
}

@end



