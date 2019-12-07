//
//  DetailPageController.m
//  Demo
//
//  Created by 李展 on 2016/11/23.
//  Copyright © 2016年 zhanlee. All rights reserved.
//

#import "DetailPageController.h"
#import "DetailLessonController.h"
@interface DetailPageController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, copy) NSArray *lessons;

@end

@implementation DetailPageController

- (instancetype)initWithLessonMatters:(NSArray *)lessons{
    self = [self init];
    if (self) {
        self.lessons = lessons;
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*self.lessons.count, self.scrollView.frame.size.height);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUInteger numberPages = self.lessons.count;
    NSMutableArray *controllers = [[NSMutableArray alloc]init];
    for (NSUInteger i = 0; i < numberPages; i++) {
        [controllers addObject:[NSNull null]];
    };
    [self.view layoutIfNeeded];
    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.scrollView setNeedsLayout];
    [self.scrollView layoutIfNeeded];
    self.scrollView.frame = CGRectMake(0, STATUSBARHEIGHT+NVGBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-(STATUSBARHEIGHT+NVGBARHEIGHT));
    self.viewControllers = controllers;
    self.scrollView.bounces = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollsToTop = YES;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.decelerationRate =1;
    
    
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:65/255.f green:163/255.f blue:255/255.f alpha:1]];
    
//    [self loadScrollViewWithPage:0];
//    [self loadScrollViewWithPage:1];
//    暂未解决滑动太快白屏现象，故取消动态滑动
    
    for (int i = 0; i<numberPages; i++) {
        [self loadScrollViewWithPage:i];
    }
    // Do any additional setup after loading the view from its nib.
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove all the subviews from our scrollview
    for (UIView *view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    NSUInteger numPages = self.lessons.count;
    
    // adjust the contentSize (larger or smaller) depending on the orientation
    self.scrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.scrollView.frame) * numPages, CGRectGetHeight(self.scrollView.frame));
    
    // clear out and reload our pages
    self.viewControllers = nil;
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    
    [self loadScrollViewWithPage:self.pageControl.currentPage - 1];
    [self loadScrollViewWithPage:self.pageControl.currentPage];
    [self loadScrollViewWithPage:self.pageControl.currentPage + 1];
    [self gotoPage:NO]; // remain at the same page (don't animate)
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
        NSUInteger page = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
        self.pageControl.currentPage = page;
        
        [self loadScrollViewWithPage:page-1];
        [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page+1];
    }

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1;
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];
}

- (void) loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.lessons.count) {
        return;
    }
    DetailLessonController *controller = [self.viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null]) {
        controller = [[DetailLessonController alloc]initWithLesson:self.lessons[page]];
        [self.viewControllers replaceObjectAtIndex:page withObject:controller];
    }
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame)*page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
        [controller didMoveToParentViewController:self];
        [controller loadLesson];
    }
}

- (void)gotoPage:(BOOL)animated{
    NSInteger page = self.pageControl.currentPage;
    [self loadScrollViewWithPage:page-1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page+1];

    CGRect frame = self.scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePage:(id)sender {
    [self gotoPage:YES];

}

/*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
@end
