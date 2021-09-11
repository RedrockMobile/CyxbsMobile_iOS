//
//  NewQAMainPageTableViewController+delegateMethod.m
//  CyxbsMobile2019_iOS
//
//  Created by 阿栋 on 2021/7/15.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "NewQAMainPageTableViewController+delegateMethod.h"
#import "PostTableViewCell.h"
#import "DynamicDetailMainVC.h"

@implementation NewQAMainPageTableViewController (delegateMethod)

///点赞的逻辑：根据点赞按钮的tag来获取post_id，并传入后端
- (void)ClickedStarBtn:(PostTableViewCell *)cell{
    cell.starBtn.isFirst = NO;
    if (cell.starBtn.selected == YES) {
        cell.starBtn.selected = NO;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"未点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] - 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor colorNamed:@"FuncBtnColor"];
        } else {
            // Fallback on earlier versions
        }
    }else {
        cell.starBtn.selected = YES;
        cell.starBtn.iconView.image = [UIImage imageNamed:@"点赞"];
        NSString *count = cell.starBtn.countLabel.text;
        cell.starBtn.countLabel.text = [NSString stringWithFormat:@"%d",[count intValue] + 1];
        if (@available(iOS 11.0, *)) {
            cell.starBtn.countLabel.textColor = [UIColor colorNamed:@"countLabelColor"];

        } else {
            // Fallback on earlier versions
        }

    }
    self.starpostmodel = [[StarPostModel alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.itemDic = self.tableArray[indexPath.row];
    [self.starpostmodel starPostWithPostID:[NSNumber numberWithString:self.itemDic[@"post_id"]]];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:self.itemDic];
    tempDic[@"is_praised"] = cell.starBtn.selected == YES ? @"1" : @"0";
    tempDic[@"praise_count"] = [NSNumber numberWithString:cell.starBtn.countLabel.text];
    [self.tableArray replaceObjectAtIndex:indexPath.row withObject:tempDic];
}

#pragma mark -点击评论按钮跳转到具体的帖子
- (void)ClickedCommentBtn:(PostTableViewCell *)cell{
    DynamicDetailMainVC *dynamicDetailVC = [[DynamicDetailMainVC alloc]init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.item = [[PostItem alloc] initWithDic:self.tableArray[indexPath.row]];
    dynamicDetailVC.post_id = self.item.post_id;
    dynamicDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

#pragma mark -点击分享按钮
- (void)ClickedShareBtn:(PostTableViewCell *)cell {
    [self showBackViewWithGesture];
    [self.view.window addSubview:self.shareView];
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.window.mas_top).mas_offset(SCREEN_HEIGHT * 460/667);
        make.left.right.bottom.mas_equalTo(self.view.window);
    }];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.itemDic = self.tableArray[indexPath.row];
    //此处还需要修改
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *shareURL = [NSString stringWithFormat:@"https://fe-prod.redrock.team/zscy-youwen-share/#/dynamic?id=%@",self.itemDic[@"post_id"]];
    pasteboard.string = shareURL;
}

# pragma mark - 关注，举报和屏蔽的多功能按钮
- (void)ClickedFuncBtn:(PostTableViewCell *)cell{
    UIWindow* desWindow=self.view.window;
    CGRect frame = [cell.funcBtn convertRect:cell.funcBtn.bounds toView:desWindow];
    [self showBackViewWithGesture];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.itemDic = self.tableArray[indexPath.row];
    if ([self.itemDic[@"is_self"] intValue] == 1) {
        self.selfPopView.deleteBtn.tag = indexPath.row;
        self.selfPopView.postID = self.itemDic[@"post_id"];
        self.selfPopView.layer.cornerRadius = 8;
        self.selfPopView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5* 1/3);
        [self.view.window addSubview:self.selfPopView];
    } else {
        self.popView.starGroupBtn.tag = indexPath.row;
        self.popView.shieldBtn.tag = indexPath.row;
        self.popView.reportBtn.tag = indexPath.row;
        if ([self.itemDic[@"is_follow_topic"] intValue] == 1) {
            [self.popView.starGroupBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }else {
            [self.popView.starGroupBtn setTitle:@"关注圈子" forState:UIControlStateNormal];
        }
        self.popView.layer.cornerRadius = 8;
        self.popView.frame = CGRectMake(frame.origin.x - SCREEN_WIDTH * 0.27, frame.origin.y + 10, SCREEN_WIDTH * 0.3057, SCREEN_WIDTH * 0.3057 * 105/131.5);
        [self.view.window addSubview:self.popView];
    }
}

#pragma mark -多功能View的代理方法
///点击关注按钮
- (void)ClickedStarGroupBtn:(UIButton *)sender {
    self.itemDic = self.tableArray[sender.tag];
    [self.followgroupmodel FollowGroupWithName:self.itemDic[@"topic"]];
    __weak typeof(self) weakSelf = self;
    if ([sender.titleLabel.text isEqualToString:@"关注圈子"]) {
        [self.followgroupmodel setBlock:^(id  _Nonnull info) {
            if (![info isKindOfClass:[NSError class]]) {
                if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    [weakSelf showOperationSuccessfulWithString:@"  关注圈子成功  "];
                    [weakSelf.heightArray removeAllObjects];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
                }else  {
                    [weakSelf showOperationSuccessfulWithString:@"  关注圈子失败  "];
                }
            }else {
                [weakSelf showOperationSuccessfulWithString:@"  操作失败  "];
            }
        }];
        [self refreshTableArrayWithTopicID:weakSelf.itemDic[@"topic"] WithStar:1];
    } else if ([sender.titleLabel.text isEqualToString:@"取消关注"]) {
        [self.followgroupmodel setBlock:^(id  _Nonnull info) {
            if (![info isKindOfClass:[NSError class]]) {
                if ([info[@"status"] isEqualToNumber:[NSNumber numberWithInt:200]]) {
                    [weakSelf showOperationSuccessfulWithString:@"  取消关注圈子成功  "];
                    [weakSelf.heightArray removeAllObjects];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshNewQAMainViewController" object:nil userInfo:nil];
                }else  {
                    [weakSelf showOperationSuccessfulWithString:@"  取消关注圈子失败  "];
                }
            }else {
                [weakSelf showOperationSuccessfulWithString:@"  操作失败  "];
            }
        }];
        [self refreshTableArrayWithTopicID:weakSelf.itemDic[@"topic"] WithStar:0];
    }
}

///点击屏蔽按钮
- (void)ClickedShieldBtn:(UIButton *)sender {
    self.itemDic = self.tableArray[sender.tag];
    [self.shieldmodel ShieldPersonWithUid:self.itemDic[@"uid"]];
    __weak typeof(self) weakSelf = self;
    [self.shieldmodel setBlock:^(id  _Nonnull info) {
        if ([info[@"info"] isEqualToString:@"success"]) {
            [weakSelf showOperationSuccessfulWithString:@"  将不再推荐该用户的动态给你  "];
        }else if ([info[@"info"] isEqualToString:@"该用户已屏蔽"]) {
            [weakSelf showOperationSuccessfulWithString:@"  该用户已经屏蔽了  "];
        } else {
            [weakSelf showOperationSuccessfulWithString:@"  屏蔽失败了  "];
        }
    }];
}
///点击举报按钮
- (void)ClickedReportBtn:(UIButton *)sender  {
    [self.popView removeFromSuperview];
    self.itemDic = self.tableArray[sender.tag];
    self.reportView.postID = self.itemDic[@"post_id"];
    [self.view.window addSubview:self.reportView];
    [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view.window);
        make.size.mas_equalTo(CGSizeMake(MAIN_SCREEN_W - MAIN_SCREEN_W*2*0.1587, MAIN_SCREEN_W * 0.6827 * 329/256));
    }];
    self.isShowedReportView = YES;
}

#pragma mark -举报页面的代理方法
///举报页面点击确定按钮
- (void)ClickedSureBtn {
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    self.reportmodel = [[ReportModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.reportmodel ReportWithPostID:self.reportView.postID WithModel:[NSNumber numberWithInt:0] AndContent:self.reportView.textView.text];
    [self.reportmodel setBlock:^(id  _Nonnull info) { //3
        [weakSelf showOperationSuccessfulWithString:@"  举报成功  "];
    }];
    self.isShowedReportView = NO;
}

///举报页面点击取消按钮
- (void)ClickedCancelBtn {
    [self.reportView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    self.isShowedReportView = NO;
}

#pragma mark -多功能View--自己的代理方法
- (void)ClickedDeletePostBtn:(UIButton *)sender {
    [self.selfPopView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    self.itemDic = self.tableArray[sender.tag];
    self.deletepostmodel = [[DeletePostModel alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.deletepostmodel deletePostWithID:self.itemDic[@"post_id"] AndModel:[NSNumber numberWithInt:0]];
    [self.deletepostmodel setBlock:^(id  _Nonnull info) {
        for (int i = 0;i < [self.tableArray count]; i++) {
            if ([weakSelf.tableArray[i][@"post_id"] isEqualToString:weakSelf.itemDic[@"post_id"]]) {
                [weakSelf.tableArray removeObjectAtIndex:i];
                break;
            }
        }
        [NewQAHud showHudWith:@"  已经删除该帖子 " AddView:weakSelf.view AndToDo:^{
            [weakSelf.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tableView reloadData];
        }];
    }];
}

#pragma mark -点击标签跳转到相应的圈子
- (void)ClickedGroupTopicBtn:(PostTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    self.itemDic = self.tableArray[indexPath.row];
    NSString *groupName = self.itemDic[@"topic"];
    YYZTopicDetailVC *detailVC = [[YYZTopicDetailVC alloc] init];
    int topicID = 0;
    for(int i = 0;i < self.topicArray.count; i++) {
        NSDictionary *dic = self.topicArray[i];
        if([dic[@"topic_name"] isEqualToString:groupName])
            topicID = i+1;
    }
    detailVC.topicIdString = groupName;
    detailVC.topicID = topicID;
    detailVC.hidesBottomBarWhenPushed = YES;
    ((ClassTabBar *)self.tabBarController.tabBar).hidden = NO;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark- 配置相关操作成功后的弹窗
- (void)showOperationSuccessfulWithString:(NSString *)str {
    [self.popView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
    [NewQAHud showHudWith:str AddView:self.view.window];
}

#pragma mark -分享View的代理方法
///点击取消
- (void)ClickedCancel {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享QQ空间
- (void)ClickedQQZone {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享朋友圈
- (void)ClickedVXGroup {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享QQ
- (void)ClickedQQ {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享微信好友
- (void)ClickedVXFriend {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

///点击分享复制链接
- (void)ClickedUrl {
    [self.shareView removeFromSuperview];
    [self.backViewWithGesture removeFromSuperview];
}

#pragma mark -点击取消关注或者关注圈子时，刷新帖子列表的数据源数组
- (void)refreshTableArrayWithTopicID:(NSString *)topicName WithStar:(NSInteger)op{
    for (int i = 0;i < [self.tableArray count]; i++) {
        self.itemDic = [NSMutableDictionary dictionaryWithDictionary:self.tableArray[i]];
        if ([self.itemDic[@"topic"] isEqualToString:topicName]) {
            [self.itemDic setObject:[NSNumber numberWithInteger:op] forKey:@"is_follow_topic"];
            [self.tableArray replaceObjectAtIndex:i withObject:self.itemDic];
        }
    }
}



@end
