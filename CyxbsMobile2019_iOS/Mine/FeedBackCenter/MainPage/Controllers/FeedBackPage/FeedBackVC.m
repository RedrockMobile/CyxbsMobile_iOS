//
//  FeedBackVC.m
//  CyxbsMobile2019_iOS
//
//  Created by 钟文韬 on 2021/8/24.
//  Copyright © 2021 Redrock. All rights reserved.
//

#import "FeedBackVC.h"
#import "TypeSelectView.h"
#import "FeedBackView.h"
#import "UIView+XYView.h"
#import <PhotosUI/PHPicker.h>
#import "TypeButton.h"
@interface FeedBackVC () <PHPickerViewControllerDelegate>

@property (nonatomic,strong) TypeSelectView * typeSelectView;
@property (nonatomic,strong) FeedBackView *feedBackView;
@property (nonatomic,strong) UIButton *submitBtn;
@property (nonatomic,strong) NSMutableArray *photoAry;
@property (nonatomic,strong) TypeButton *correctBtn;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBar];
    [self.view addSubview:self.typeSelectView];
    [self.view addSubview:self.feedBackView];
    [self.view addSubview:self.submitBtn];
    self.photoAry = [[NSMutableArray alloc]initWithCapacity:4];
}


#pragma mark - getter
- (TypeSelectView *)typeSelectView{
    if (!_typeSelectView) {
        _typeSelectView = [[TypeSelectView alloc]initWithFrame:CGRectMake(0, Bar_H, SCREEN_WIDTH, 71)];
        [_typeSelectView setSelect:^(TypeButton * _Nonnull sender) {
//                    NSLog(@"%d",)
                    sender.backgroundColor = [UIColor colorNamed:@"typeBG"];
                    [sender setTitleColor:[UIColor colorNamed:@"type"] forState:UIControlStateNormal];
                    sender.layer.borderColor = [UIColor colorNamed:@"type"].CGColor;
        }];
    }
    return _typeSelectView;
}

- (FeedBackView *)feedBackView{
    if (!_feedBackView) {
        __weak typeof(self) weakSelf = self;
        _feedBackView = [[FeedBackView alloc]initWithFrame:CGRectMake(16, Bar_H + 71, SCREEN_WIDTH - 32, 509)];
        [_feedBackView setSelectPhoto:^{
            //PHPickerConfiguration
            PHPickerConfiguration *config = [[PHPickerConfiguration alloc]init];
            //个数限制
            config.selectionLimit = 3;
            //filter
            config.filter = [PHPickerFilter imagesFilter];
            //新建 PHPickerViewController ： pVC
            PHPickerViewController *pVC = [[PHPickerViewController alloc]initWithConfiguration:config];
            //代理
            pVC.delegate = self;
            //show
            [self presentViewController:pVC animated:YES completion:nil];
        }];
        
        [_feedBackView setDeletePhoto:^(NSInteger tag) {
            [weakSelf.photoAry removeObjectAtIndex:tag];
            if (weakSelf.photoAry.count == 0) {
                weakSelf.feedBackView.plusView.hidden = NO;
                weakSelf.feedBackView.plusView.frame = weakSelf.feedBackView.imageView1.frame;
                weakSelf.feedBackView.imageView1.hidden = YES;
                weakSelf.feedBackView.imageView2.hidden = YES;
                weakSelf.feedBackView.imageView3.hidden = YES;
                weakSelf.feedBackView.delete1.hidden = YES;
                weakSelf.feedBackView.delete2.hidden = YES;
                weakSelf.feedBackView.delete3.hidden = YES;
                weakSelf.feedBackView.photoCountLbl.text = @"0/3";
            }
            if (weakSelf.photoAry.count == 1) {
                weakSelf.feedBackView.plusView.hidden = NO;
                weakSelf.feedBackView.plusView.frame = weakSelf.feedBackView.imageView2.frame;
                weakSelf.feedBackView.imageView1.hidden = NO;
                weakSelf.feedBackView.imageView2.hidden = YES;
                weakSelf.feedBackView.imageView3.hidden = YES;
                weakSelf.feedBackView.delete1.hidden = NO;
                weakSelf.feedBackView.delete2.hidden = YES;
                weakSelf.feedBackView.delete3.hidden = YES;
                weakSelf.feedBackView.imageView1.image = weakSelf.photoAry[0];
                weakSelf.feedBackView.photoCountLbl.text = @"1/3";
            }
            if (weakSelf.photoAry.count == 2) {
                weakSelf.feedBackView.plusView.hidden = NO;
                weakSelf.feedBackView.plusView.frame = weakSelf.feedBackView.imageView3.frame;
                weakSelf.feedBackView.imageView1.hidden = NO;
                weakSelf.feedBackView.imageView2.hidden = NO;
                weakSelf.feedBackView.imageView3.hidden = YES;
                weakSelf.feedBackView.delete1.hidden = NO;
                weakSelf.feedBackView.delete2.hidden = NO;
                weakSelf.feedBackView.delete3.hidden = YES;
                weakSelf.feedBackView.imageView1.image = weakSelf.photoAry[0];
                weakSelf.feedBackView.imageView2.image = weakSelf.photoAry[1];
                weakSelf.feedBackView.photoCountLbl.text = @"2/3";
            }
            if (weakSelf.photoAry.count == 3) {
                weakSelf.feedBackView.plusView.hidden = YES;
                weakSelf.feedBackView.imageView1.hidden = NO;
                weakSelf.feedBackView.imageView2.hidden = NO;
                weakSelf.feedBackView.imageView3.hidden = NO;
                weakSelf.feedBackView.delete1.hidden = NO;
                weakSelf.feedBackView.delete2.hidden = NO;
                weakSelf.feedBackView.delete3.hidden = NO;
                weakSelf.feedBackView.imageView1.image = weakSelf.photoAry[0];
                weakSelf.feedBackView.imageView2.image = weakSelf.photoAry[1];
                weakSelf.feedBackView.imageView3.image = weakSelf.photoAry[2];
                weakSelf.feedBackView.photoCountLbl.text = @"3/3";
            }
        }];
   
    }
    return _feedBackView;
}

-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc]init];
        _submitBtn.size = CGSizeMake(117, 41);
        _submitBtn.centerX = self.view.centerX;
        _submitBtn.y = 719;
        [_submitBtn setImage:[UIImage imageNamed:@"submit"] forState:UIControlStateNormal];
    }
    return _submitBtn;
}


#pragma mark - 私有方法
- (void)setupBar{
    self.view.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.VCTitleStr = @"意见反馈";
    self.topBarView.backgroundColor = [UIColor colorNamed:@"248_249_252_1"];
    self.splitLineColor = [UIColor systemGray5Color];
    self.titlePosition = TopBarViewTitlePositionLeft;
    self.titleFont = [UIFont fontWithName:PingFangSCBold size:21];
}

#pragma - mark PHPicker Delegate
- (void)picker:(PHPickerViewController *)picker didFinishPicking:(NSArray<PHPickerResult *> *)results{
    //picker消失时的操作
    [picker dismissViewControllerAnimated:YES completion:nil];
    //遍历
    for (PHPickerResult *result in results) {
        [result.itemProvider loadObjectOfClass:[UIImage class] completionHandler:^(__kindof id<NSItemProviderReading>  _Nullable object, NSError * _Nullable error) {
            //如果结果的类型是UIImage
            if (object) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.photoAry addObject:object];
                    if (self.photoAry.count == 1) {
                        self.feedBackView.plusView.hidden = NO;
                        self.feedBackView.plusView.frame = self.feedBackView.imageView2.frame;
                        self.feedBackView.imageView1.hidden = NO;
                        self.feedBackView.imageView2.hidden = YES;
                        self.feedBackView.imageView3.hidden = YES;
                        self.feedBackView.delete1.hidden = NO;
                        self.feedBackView.delete2.hidden = YES;
                        self.feedBackView.delete3.hidden = YES;
                        self.feedBackView.imageView1.image = self.photoAry[0];
                        self.feedBackView.photoCountLbl.text = @"1/3";
                    }
                    if (self.photoAry.count == 2) {
                        self.feedBackView.plusView.hidden = NO;
                        self.feedBackView.plusView.frame = self.feedBackView.imageView3.frame;
                        self.feedBackView.imageView1.hidden = NO;
                        self.feedBackView.imageView2.hidden = NO;
                        self.feedBackView.imageView3.hidden = YES;
                        self.feedBackView.delete1.hidden = NO;
                        self.feedBackView.delete2.hidden = NO;
                        self.feedBackView.delete3.hidden = YES;
                        self.feedBackView.imageView1.image = self.photoAry[0];
                        self.feedBackView.imageView2.image = self.photoAry[1];
                        self.feedBackView.photoCountLbl.text = @"2/3";
                    }
                    if (self.photoAry.count == 3) {
                        self.feedBackView.plusView.hidden = YES;
                        self.feedBackView.imageView1.hidden = NO;
                        self.feedBackView.imageView2.hidden = NO;
                        self.feedBackView.imageView3.hidden = NO;
                        self.feedBackView.delete1.hidden = NO;
                        self.feedBackView.delete2.hidden = NO;
                        self.feedBackView.delete3.hidden = NO;
                        self.feedBackView.imageView1.image = self.photoAry[0];
                        self.feedBackView.imageView2.image = self.photoAry[1];
                        self.feedBackView.imageView3.image = self.photoAry[2];
                        self.feedBackView.photoCountLbl.text = @"3/3";
                    }
                });
            }
        }];
    }
    //获取主线程（更新UI）

    
    
}
@end
