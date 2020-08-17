//
//  WYCShowDetailView.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/22.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import "WYCShowDetailView.h"
#import "WYCClassDetailView.h"
#import "WYCNoteDetailView.h"
#import "ClassDetailView.h"

@interface WYCShowDetailView()<UIScrollViewDelegate>
//白色的承载scrollView的view
@property (nonatomic, strong) UIView *rootView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray *array;

@end

@implementation WYCShowDetailView

//array[i]是某节课的字典信息
- (void)initViewWithArray:(NSArray *)array{
    _index = 0;
    self.array = array;
    [self layoutIfNeeded];
    
    self.rootView = [[UIView alloc]init];
    self.rootView = [[UIView alloc]initWithFrame:CGRectMake(0, MAIN_SCREEN_H-DETAILVIEW_H, MAIN_SCREEN_W, DETAILVIEW_H)];
    if(@available(iOS 11.0, *)){
        self.rootView.backgroundColor = [UIColor colorNamed:@"white&37_39_44"];
    }else{
        self.rootView.backgroundColor = [UIColor whiteColor];
    }
    self.rootView.layer.masksToBounds = YES;
    self.rootView.layer.cornerRadius = 8;
    self.rootView.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.rootView.layer.shadowRadius = 15;
    self.rootView.layer.shadowOpacity = 1;
    [self.rootView layoutIfNeeded];
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,self.rootView.width,self.rootView.height)];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.userInteractionEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(array.count*self.rootView.width, self.rootView.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    for (int i = 0; i < array.count; i++) {
        if ([array[i] objectForKey:@"id"]) {
            WYCNoteDetailView *view = [WYCNoteDetailView initViewFromXib];
            [view initWithDic:array[i]];
            [view.editNote addTarget:self action:@selector(editNote:) forControlEvents:UIControlEventTouchUpInside];
            view.editNote.tag = i;
            [view.editNote addTarget:self action:@selector(editNote:) forControlEvents:UIControlEventTouchUpInside];
            view.deleteNote.tag = i;
            [view.deleteNote addTarget:self action:@selector(deleteNote:) forControlEvents:UIControlEventTouchUpInside];
            view.deleteNote.tag = i;
            [view setFrame:CGRectMake(i*self.rootView.width, 0,self.rootView.width,self.rootView.height)];
            [self.scrollView addSubview:view];
            view.backgroundColor = UIColor.clearColor;
        }else{
            ClassDetailView *view = [[ClassDetailView alloc] init];
            view.dataDict = array[i];
            [view setFrame:CGRectMake(i*self.rootView.width, 0,self.rootView.width,self.rootView.height)];
            [self.scrollView addSubview:view];
            view.backgroundColor = UIColor.clearColor;
        }
        
        
    }
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.rootView.height - 30, self.rootView.width, 30)];
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = array.count;
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#5599FF"];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#C4C4C4"];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.rootView addSubview:self.scrollView];
    [self.rootView addSubview:self.pageControl];
    [self addSubview:self.rootView];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"showChooseClassList" object:nil];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _index = self.scrollView.contentOffset.x/self.rootView.width;
    self.pageControl.currentPage = _index;
}

-(void)changePage:(id)sender{
    NSInteger i = _pageControl.currentPage;
    [_scrollView setContentOffset:CGPointMake(i*self.rootView.width, 0) animated:YES];
}



-(void)editNote:(UIButton *)sender{
    if ([self.chooseClassListDelegate respondsToSelector:@selector(clickEditNoteBtn:)]) {
        [self.chooseClassListDelegate clickEditNoteBtn:self.array[sender.tag]];
    }
}

-(void)deleteNote:(UIButton *)sender{
    if ([self.chooseClassListDelegate respondsToSelector:@selector(clickDeleteNoteBtn:)]) {
        [self.chooseClassListDelegate clickDeleteNoteBtn:self.array[sender.tag]];
    }
}
@end
