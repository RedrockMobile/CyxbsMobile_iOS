//
//  JWZXNewDownloadVC.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/4/12.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "JWZXNewDownloadVC.h"

#import "NewDownloadCell.h"

#pragma mark - JWZXNewDownloadVC ()

@interface JWZXNewDownloadVC () <
    UITableViewDelegate,
    UITableViewDataSource,
    NewDownloadCellDelegate
>

/// 细节模型
@property (nonatomic, strong) JWZXDetailNewsModel *detailModel;

/// 为了好看，加个标题
@property (nonatomic, strong) UILabel *titleLab;

/// 下载的一个tableView
@property (nonatomic, strong) UITableView *downLoadTableView;

@end

#pragma makr -  JWZXNewDownloadVC

@implementation JWZXNewDownloadVC

#pragma mark - Life cycle

- (instancetype)initWithDetailNewsModel:(JWZXDetailNewsModel *)model {
    self = [super init];
    if (self) {
        self.detailModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#F2F3F8" alpha:1] darkColor:[UIColor colorWithHexString:@"#000000" alpha:1]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view addSubview:self.downLoadTableView];
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.annexModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:NewDownloadCellReuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[NewDownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewDownloadCellReuseIdentifier];
        cell.frame = CGRectMake(0, 0, self.view.width, 0);
    }
    cell.delegate = self;
    [cell drawWithTitle:self.detailModel.annexModels[indexPath.row].name];
    return cell;
}

#pragma mark - <NewDownloadCellDelegate>

- (void)newDownloadCell:(NewDownloadCell *)cell shouldDownLoadAtIndex:(NSInteger)index {
        [UIApplication.sharedApplication
          openURL:[NSURL URLWithString:
            [NSString stringWithFormat: @"%@?id=%@",
            [CyxbsMobileBaseURL_1 stringByAppendingString:@"magipoke-jwzx/jwNews/file"],
             self.detailModel.annexModels[index].annexID]]
          options:@{}
          completionHandler:nil];
}

#pragma mark - Getter

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.downLoadTableView.width - 30, 100)];
        _titleLab.numberOfLines = 0;
        _titleLab.textColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#F0F0F2" alpha:1]];
        _titleLab.font = [UIFont fontWithName:PingFangSCSemibold size:22];
        
        _titleLab.text = self.detailModel.title;
        CGRect rect =
        [self.detailModel.title
         boundingRectWithSize:CGSizeMake(_titleLab.width, 0)
         options:NSStringDrawingUsesFontLeading
                |NSStringDrawingUsesLineFragmentOrigin
         attributes:@{NSFontAttributeName : _titleLab.font}
         context:nil];
        
        _titleLab.size = rect.size;
        _titleLab.height += 30;
    }
    
    return _titleLab;
}

- (UITableView *)downLoadTableView {
    if (_downLoadTableView == nil) {
        _downLoadTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 30, self.view.width - 30, self.view.height) style:UITableViewStyleGrouped];
        _downLoadTableView.tableHeaderView = self.titleLab;
        _downLoadTableView.delegate = self;
        _downLoadTableView.dataSource = self;
        _downLoadTableView.backgroundColor = UIColor.clearColor;
        _downLoadTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        [_downLoadTableView registerClass:NewDownloadCell.class forCellReuseIdentifier:NewDownloadCellReuseIdentifier];
    }
    return _downLoadTableView;
}

@end
