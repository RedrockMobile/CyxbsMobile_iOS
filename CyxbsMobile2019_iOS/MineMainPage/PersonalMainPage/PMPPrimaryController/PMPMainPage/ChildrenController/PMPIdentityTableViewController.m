//
//  PMPIdentityTableViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by Edioth Jin on 2021/9/27.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "PMPIdentityTableViewController.h"
// model

#import "AuthenticViewController.h"
#import "StampCenterVC.h"

@interface PMPIdentityTableViewController ()
<UITextViewDelegate>

@property (nonatomic, strong) UIImageView * defaultImgView;
@property (nonatomic, strong) UITextView * defaultTextView;

@property (nonatomic, assign) BOOL canScroll;

@property (nonatomic, strong) NSString * redid;

@property (nonatomic, strong) NSMutableArray <IDModel *> * identityAry;

/// cell高度，这里的cell高度不是卡片的高度，而是卡片的高度加上卡片间距
@property (nonatomic, assign)CGFloat cellHeight;
@end

@implementation PMPIdentityTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
                        redid:(NSString *)redid
{
    self = [super initWithStyle:style];
    if (self) {
        _redid = redid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _cellHeight = 0.3866666667*SCREEN_WIDTH;
    self.tableView.backgroundColor = [UIColor colorNamed:@"white&29_29_29_1"];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[IDCardTableViewCell class] forCellReuseIdentifier:NSStringFromClass(IDCardTableViewCell.class)];
    [self addNotification];
    [self loadData];
    [self.view addSubview:self.defaultTextView];
    [self.defaultTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_centerY);
        make.centerX.mas_equalTo(self.view);
        make.width.mas_lessThanOrEqualTo(300);
    }];
    self.defaultTextView.hidden = YES;
    
    [self.view addSubview:self.defaultImgView];
    [self.defaultImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.defaultTextView.mas_top).offset(-10);
        make.centerX.mas_equalTo(self.view);
    }];
    self.defaultImgView.hidden = YES;
}

- (void)loadData {
    [[IDDataManager shareManager]
     loadAllIDWithRedid:self.redid
     success:^(NSMutableArray<IDModel *> * _Nonnull modelArr) {
        self.identityAry = modelArr;
        self.defaultTextView.hidden = modelArr.count != 0;
        self.defaultImgView.hidden = modelArr.count != 0;
        [self.tableView reloadData];
    }
     failure:^{
        self.defaultTextView.hidden = NO;
        self.defaultImgView.hidden = NO;
        [NewQAHud
         showHudWith:@" 获取身份失败!网络出现了问题. "
         AddView:self.view];
    }];
}

#pragma mark - notifivation

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeGoTopNotification object:nil];
    //其中一个TAB离开顶部的时候，如果其他几个偏移量不为0的时候，要把他们都置为0
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsg:) name:kHomeLeaveTopNotification object:nil];
}

- (void)acceptMsg:(NSNotification *)notification {
    NSString *notificationName = notification.name;
    if ([notificationName isEqualToString:kHomeGoTopNotification]) {
        NSDictionary *userInfo = notification.userInfo;
        NSString *canScroll = userInfo[@"canScroll"];
        if ([canScroll isEqualToString:@"1"]) {
            _canScroll = YES;
            self.tableView.showsVerticalScrollIndicator = YES;
        }
    }else if([notificationName isEqualToString:kHomeLeaveTopNotification]){
        self.tableView.contentOffset = CGPointZero;
        _canScroll = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.canScroll) {
        [scrollView setContentOffset:CGPointZero];
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY < 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeLeaveTopNotification object:nil userInfo:@{@"canScroll":@"1"}];
    }
}

#pragma mark - textViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    //    NSLog(@"%@", URL.scheme);
    if ([[URL resourceSpecifier] isEqualToString:@"stamp_store://"]) {
        
        [self.parentViewController.navigationController pushViewController:[[StampCenterVC alloc] init] animated:YES];
        return NO;
    }
    return true;
}

#pragma mark - private

- (NSAttributedString *)getContentLabelAttributedText:(NSString *)text
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    [attrStr
     addAttribute:NSLinkAttributeName
     value:@"stamp_store://"
     range:[text rangeOfString:@" 邮票商城 "]];
    [attrStr
     addAttribute:NSForegroundColorAttributeName
     value:[UIColor purpleColor]
     range:[text rangeOfString:@" 邮票商城 "]];
    
    return attrStr;
}

#pragma mark - Table view dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.identityAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IDCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(IDCardTableViewCell.class)];
    
    // Configure the cell...
    cell.model = self.identityAry[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _cellHeight;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //    return [self.redid isEqualToString:[UserItem defaultItem].redid];
    return true;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if (![self.redid isEqualToString:[UserItem defaultItem].redid]) {
    //        return [UISwipeActionsConfiguration configurationWithActions:@[]];
    //    }
    UIContextualAction *SettingRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"设置" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self.parentViewController.navigationController pushViewController:[[AuthenticViewController alloc] init] animated:YES];
    }];
    SettingRowAction.image = [UIImage imageNamed:@"identity_setting"];
    SettingRowAction.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [IDModel
         deleteIdentityWithIdentityId:self.identityAry[indexPath.row].idStr
         success:^{
            [NewQAHud showHudWith:@"删除成功!"
                          AddView:self.view
                          AndToDo:^{
                [self.identityAry removeObjectAtIndex:indexPath.row];
                completionHandler(true);
                [self.tableView reloadData];
            }];
        }
         failure:^{
            [NewQAHud showHudWith:@"删除失败!"
                          AddView:self.view];
        }];
    }];
    deleteRowAction.image = [UIImage imageNamed:@"trash"];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[SettingRowAction, deleteRowAction]];
    return config;
}

#pragma mark - lazy

- (UITextView *)defaultTextView {
    if (_defaultTextView == nil) {
        _defaultTextView = [[UITextView alloc] init];
        _defaultTextView.attributedText = [self getContentLabelAttributedText:@"欸,您暂时还没有任何身份,可以前往“重邮帮”小程序通过”身份有证”申请身份,或者前往 邮票商城 兑换个性化身份"];
        _defaultTextView.textAlignment = NSTextAlignmentCenter;
        _defaultTextView.delegate = self;
        _defaultTextView.editable = NO;        //必须禁止输入，否则点击将弹出输入键盘
        _defaultTextView.scrollEnabled = NO;
    }
    return _defaultTextView;
}

- (UIImageView *)defaultImgView {
    if (_defaultImgView == nil) {
        _defaultImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_identity_default"]];
        [_defaultImgView sizeToFit];
    }
    return _defaultImgView;
}

@end
