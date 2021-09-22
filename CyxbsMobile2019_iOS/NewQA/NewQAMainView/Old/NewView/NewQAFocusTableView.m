//
//  NewQAFocusTableView.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/8/17.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAFocusTableView.h"
#import "NewQATopView.h"
#import "NewQAMainVC.h"
#import "UIView+Extension.h"

@interface NewQAFocusTableView() <UITableViewDelegate,UITableViewDataSource>

@end

@implementation NewQAFocusTableView

- (void)setTopView:(NewQATopView *)topView {
    _topView = topView;
    
    self.dataSource = self;
    self.delegate = self;
    
    self.scrollIndicatorInsets = UIEdgeInsetsMake(self.topView.itemHeight, 0, 0, 0);
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.topView.height)];
    self.tableHeaderView = tableHeaderView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 38;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseFirstTableViewCell = @"reuseFirstTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseFirstTableViewCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseFirstTableViewCell];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"A:第%ld行", (long)indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        NewQAMainVC *currentVC = (NewQAMainVC *)scrollView.nextResponder.nextResponder;
        
        if (currentVC.printPoint.x < SCREEN_WIDTH/2.0f) {
            if (scrollView.contentOffset.x > SCREEN_WIDTH *0.5) {
                [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
        else {
            if (scrollView.contentOffset.x < SCREEN_WIDTH *0.5) {
                [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            }
        }
    }
    else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSLog(@"FirstTableView_didSelectRowAtIndexPathRow:%ld", (long)indexPath.row);
        
    }
}


#pragma mark - firstTableView的代理方法scrollViewDidScroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat placeHolderHeight = self.topView.height - self.topView.itemHeight;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        self.topView.y = -offsetY+SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
    }
    else if (offsetY > placeHolderHeight) {
        self.topView.y = -placeHolderHeight+SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
    }
    else if (offsetY < 0) {
        self.topView.y = SCREEN_WIDTH * 0.04 * 11/15 + TOTAL_TOP_HEIGHT;
    }
}


@end
