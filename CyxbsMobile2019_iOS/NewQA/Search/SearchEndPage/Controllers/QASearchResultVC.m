//
//  QASearchResultVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 石子涵 on 2021/12/11.
//  Copyright © 2021 Redrock. All rights reserved.
//


//VC
#import "QASearchResultVC.h"
#import "CYSearchEndKnowledgeDetailView.h"

//View
#import "QASearchResultRootView.h"
@interface QASearchResultVC ()
<
    SearchTopViewDelegate,
    SZHHotSearchViewDelegate
>
@property (nonatomic, strong) QASearchResultRootView *rootView;
/// 知识库详情页的model数组
@property (nonatomic, strong) NSMutableArray *knowledgeDetaileModelsAry;

@end

@implementation QASearchResultVC
#pragma mark -life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = self.rootView;
    
    [self setUI];
    
}
#pragma mark -private methonds
- (void)setUI{
    //加载上半部分视图
    self.knowledgeDetaileModelsAry = [NSMutableArray array];
    if (self.knowlegeAry.count != 0) {
        NSMutableArray *muteAry = [NSMutableArray array];
        for (NSDictionary *dic in self.knowlegeAry) {
            CYSearchEndKnowledgeDetailModel *knowledgeDetaileModel  = [CYSearchEndKnowledgeDetailModel initWithDict:dic];
            [muteAry addObject:knowledgeDetaileModel.titleStr];
            [self.knowledgeDetaileModelsAry addObject:knowledgeDetaileModel];
        }
        self.rootView.topView.knowledgeView.buttonTextAry = muteAry;
        [self.rootView.topView.knowledgeView updateBtns];  //添加知识库的button
        [self.rootView.topView updateHotSearchViewFrame];  //重新设置topview的frame布局
    }
    
}

#pragma mark -Delegate
#pragma mark -SearchTopViewDelegate
//返回上一界面
- (void)jumpBack{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -SZHHotSearchViewDelegate
//点击重邮知识库按钮 弹出详细界面
- (void)touchCQUPTKonwledgeThroughBtn:(UIButton *)btn{
    
    CYSearchEndKnowledgeDetailView *vc = [[CYSearchEndKnowledgeDetailView alloc] init];
    //设置知识库的数据
    for (CYSearchEndKnowledgeDetailModel *model in self.knowledgeDetaileModelsAry) {
        if ([model.titleStr isEqualToString:btn.titleLabel.text] ) {
            vc.model = model;
            break;
        }
    }
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark -getter
- (QASearchResultRootView *)rootView{
    if (!_rootView) {
        if (self.knowlegeAry.count == 0) {
            _rootView = [[QASearchResultRootView alloc] initWithFrame:self.view.frame IsHaveKnoweledge:NO];
        }else{
            _rootView = [[QASearchResultRootView alloc] initWithFrame:self.view.frame IsHaveKnoweledge:YES];
        }
    }
    return _rootView;
}
@end
