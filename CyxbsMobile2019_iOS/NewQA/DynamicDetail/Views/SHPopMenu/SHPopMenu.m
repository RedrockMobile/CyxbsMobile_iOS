//
//  SHPopMenu.m
//  SHPopMenuDemo
//
//  Created by hh on 15/12/22.
//  Copyright © 2015年 陈胜辉. All rights reserved.
//

#import "SHPopMenu.h"
#import "UIColor+SYColor.h"
/**
 *  下拉菜单
 **/
@interface SHPopMenu()<UITableViewDataSource,UITableViewDelegate>

//蒙版
@property (nonatomic, strong) UIButton *maskView;

//容器 (设置背景颜色与内容)
@property (nonatomic, strong) UIImageView *container;

//箭头
@property (nonatomic, strong) UIImageView *imageArrow;

//内容展示
@property (nonatomic, strong) UITableView *contentView;

//点击回调
@property (nonatomic, copy) void(^block)(SHPopMenu *menu,NSInteger index);

@end

@implementation SHPopMenu

static NSString *reuseIdentifier = @"cell";

#pragma mark - 懒加载
- (UIButton *)maskView{
    if (!_maskView) {
        _maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        _maskView.backgroundColor = [UIColor clearColor];
        [_maskView addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_maskView];
    }
    return _maskView;
}

- (UIImageView *)container{
    if (!_container) {
        _container = [[UIImageView alloc] init];
        _container.userInteractionEnabled = YES;
        
        _container.backgroundColor = [UIColor clearColor];
        
        _container.layer.cornerRadius = 15;
        _container.layer.borderWidth = 1;
        _container.layer.masksToBounds = YES;
        _container.layer.borderColor = [UIColor colorWithLightColor:KUIColorFromRGB(0xF1F3F8) DarkColor:KUIColorFromRGB(0x000000)].CGColor;
        
        [self addSubview:_container];
    }
    return _container;
}

- (UITableView *)contentView{
    //创建tabview
    if (!_contentView) {
        _contentView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _contentView.delegate = self;
        _contentView.dataSource = self;
        _contentView.separatorInset = UIEdgeInsetsMake(0, 18, 0, 18);
        _contentView.bounces = NO;
        _contentView.showsVerticalScrollIndicator = NO;
        _contentView.backgroundColor = [UIColor colorWithLightColor:KUIColorFromRGB(0xF1F3F8) DarkColor:KUIColorFromRGB(0x000000)];
        //内容
        [self.container addSubview:_contentView];
    }
    return _contentView;
}

- (UIImageView *)imageArrow{
    if (!_imageArrow) {
        //箭头
        UIImageView *imageArrow = [[UIImageView alloc]init];
        imageArrow.frame = CGRectMake(0, 0, 16, 7);
        imageArrow.image = [UIImage imageNamed:@"pop_arrow"];
        [self addSubview:imageArrow];
        _imageArrow = imageArrow;
    }
    return _imageArrow;
}

#pragma mark - SET
- (void)setMList:(NSArray *)mList{
    _mList = mList;
    
    //不存在则计算
    if (!self.menuW) {
        //计算宽度
        self.menuW = 0.0;
        for (id obj in mList) {
            
            if ([obj isKindOfClass:[NSDictionary class]]) {//文字 + 图片
                
                NSDictionary *dic = (NSDictionary *)obj;
                CGSize size = [dic.allValues[0] boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX)  options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                //宽度(文字 + 图片 + 左右的间距)
                self.menuW = MAX(size.width + 75, self.menuW);
                
            }else if ([obj isKindOfClass:[NSString class]]){//文字
                
                CGSize size = [obj boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
                //宽度(文字 + 左右的间距)
                self.menuW = MAX(size.width + 40, self.menuW);
                
            }else if ([obj isKindOfClass:[NSAttributedString class]]){//富文本
                NSAttributedString *att = (NSAttributedString *)obj;
                CGSize size = [att boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin context:nil].size;
                //宽度(文字 + 左右的间距)
                self.menuW = MAX(size.width + 40, self.menuW);
            }
        }
    }
}

- (void)setDimBackground:(BOOL)dimBackground{
    
    _dimBackground = dimBackground;
    
    if (dimBackground) {
        self.maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    } else {
        self.maskView.backgroundColor = [UIColor clearColor];
    }
}

- (void)setContentColor:(UIColor *)contentColor{
    _contentColor = contentColor;
    self.container.backgroundColor = contentColor;
}

- (void)setContentImage:(UIImage *)contentImage{
    _contentImage = contentImage;
    self.container.image = contentImage;
}

- (void)setArrowImage:(UIImage *)arrowImage{
    _arrowImage = arrowImage;
    self.imageArrow.image = arrowImage;
}

#pragma mark - 内部方法
- (void)btnAction{
    
    [self dismiss];
}

#pragma mark - 公共方法
- (void)showInRectX:(int)x rectY:(int)y block:(void (^)(SHPopMenu *, NSInteger))block{
    
    if (!self.mList.count) {
        NSLog(@"先设置 mList");
        return;
    }
    
    //初始化
    self.contentH = self.contentH?:44;
    self.font = self.font?:[UIFont systemFontOfSize:14];
    self.textColor = self.textColor?:[UIColor whiteColor];
    self.separatorColor = self.separatorColor?:[UIColor colorWithLightColor:KUIColorFromRGB(0xE2E8EE) DarkColor:KUIColorFromRGB(0x252525)];
    
    //赋值
    self.block = block;
    
    // 添加菜单整体到窗口身上
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    self.maskView.frame = self.bounds;
    
    // 设置容器的frame
    long count = self.mList.count;
    long height = self.contentH*count;
    
    //气泡距离下方 50
    CGFloat max_h = window.frame.size.height - y - CGRectGetHeight(self.imageArrow.frame) - 50;
    
    //超过最大则用最大的 弹框内部滑动
    if (height > max_h) {
        height = max_h;
    }
    
    //设置内容
    self.container.frame = CGRectMake(x , y + CGRectGetHeight(self.imageArrow.frame), self.menuW, height);
    self.contentView.frame = self.container.bounds;
    self.contentView.separatorColor = self.separatorColor;
    self.contentView.layer.cornerRadius = 15;
    self.contentView.layer.masksToBounds = YES;
    
    //设置箭头frame
    CGRect frame = self.imageArrow.frame;
    frame.origin = CGPointMake(self.container.frame.origin.x + self.arrowX, y);
    self.imageArrow.frame = frame;
    
    //刷新
    [self.contentView reloadData];
}

#pragma mark 消失
- (void)dismiss{
    
    [self removeFromSuperview];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = self.font;
        cell.textLabel.textColor = [UIColor colorWithLightColor:self.textColor DarkColor:KUIColorFromRGB(0xF0F0F2)];
    }
    
    //取出内容
    id obj = self.mList[indexPath.row];
    
    if ([obj isKindOfClass:[NSDictionary class]]) {//字典：图片为key、内容为obj
        
        NSDictionary *dic = obj;
        cell.textLabel.text = dic.allValues[0];
        cell.imageView.backgroundColor = [UIColor lightGrayColor];
        cell.imageView.image = [self imageWithImage:[UIImage imageNamed:dic.allKeys[0]] size:CGSizeMake(self.contentH/2, self.contentH/2)];
    }else if ([obj isKindOfClass:[NSString class]]){//字符串：只有内容
        
        NSString *str = obj;
        cell.textLabel.text = str;
    }else if ([obj isKindOfClass:[NSAttributedString class]]){//富文本
        
        NSAttributedString *att = obj;
        cell.textLabel.attributedText = att;
    }
    
    return cell;
}

//单元格点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //消失
    [self dismiss];
    
    if (self.block) {
        self.block(self,indexPath.row);
    }
}

//设置单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.contentH;
}

#pragma mark - 获取指定大小的Image
- (UIImage *)imageWithImage:(UIImage *)image size:(CGSize)size{
    
    UIImage *sourceImage = image;
    
    UIImage *newImage = nil;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = size.width;
    
    CGFloat targetHeight = size.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor < heightFactor)
            
            scaleFactor = widthFactor;
        
        else
            
            scaleFactor = heightFactor;
        
        scaledWidth  = width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        // center the image
        
        if (widthFactor < heightFactor) {
            
            
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        } else if (widthFactor > heightFactor) {
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width  = scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil) {
        return image;
    }
    
    return newImage ;
}

@end

