//
//  UITextView+WZB.m
//  WZBTextView-demo
//
//  Created by normal on 2016/11/14.
//  Copyright © 2016年 WZB. All rights reserved.
//

#import "UITextView+WZB.h"
#import <objc/runtime.h>

// 占位文字
static const void *WZBPlaceholderViewKey = &WZBPlaceholderViewKey;
// 占位文字颜色
static const void *WZBPlaceholderColorKey = &WZBPlaceholderColorKey;
// 最大高度
static const void *WZBTextViewMaxHeightKey = &WZBTextViewMaxHeightKey;
// 最小高度
static const void *WZBTextViewMinHeightKey = &WZBTextViewMinHeightKey;
// 高度变化的block
static const void *WZBTextViewHeightDidChangedBlockKey = &WZBTextViewHeightDidChangedBlockKey;
// 存储添加的图片
static const void *WZBTextViewImageArrayKey = &WZBTextViewImageArrayKey;
// 存储最后一次改变高度后的值
static const void *WZBTextViewLastHeightKey = &WZBTextViewLastHeightKey;

@interface UITextView ()

// 存储添加的图片
@property (nonatomic, strong) NSMutableArray *imageArray;
// 存储最后一次改变高度后的值
@property (nonatomic, assign) CGFloat lastHeight;

@end

@implementation UITextView (WZB)

#pragma mark - Swizzle Dealloc
+ (void)load {
    // 交换dealoc
    Method dealoc = class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc"));
    Method myDealoc = class_getInstanceMethod(self.class, @selector(myDealoc));
    method_exchangeImplementations(dealoc, myDealoc);
}

- (void)myDealoc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    UITextView *placeholderView = objc_getAssociatedObject(self, WZBPlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (placeholderView) {
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        for (NSString *property in propertys) {
            @try {
                [self removeObserver:self forKeyPath:property];
            } @catch (NSException *exception) {}
        }
    }
    [self myDealoc];
}

#pragma mark - set && get
- (UITextView *)placeholderView {
    
    // 为了让占位文字和textView的实际文字位置能够完全一致，这里用UITextView
    UITextView *placeholderView = objc_getAssociatedObject(self, WZBPlaceholderViewKey);
    
    if (!placeholderView) {
        
        // 初始化数组
        self.imageArray = [NSMutableArray array];
        
        placeholderView = [[UITextView alloc] init];
        // 动态添加属性的本质是: 让对象的某个属性与值产生关联
        objc_setAssociatedObject(self, WZBPlaceholderViewKey, placeholderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        placeholderView = placeholderView;
        
        // 设置基本属性
        self.scrollEnabled = placeholderView.scrollEnabled = placeholderView.showsHorizontalScrollIndicator = placeholderView.showsVerticalScrollIndicator = placeholderView.userInteractionEnabled = NO;
        placeholderView.textColor = [UIColor lightGrayColor];
        placeholderView.backgroundColor = [UIColor clearColor];
        [self refreshPlaceholderView];
        [self addSubview:placeholderView];
        
        // 监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange) name:UITextViewTextDidChangeNotification object:self];
        
        // 这些属性改变时，都要作出一定的改变，尽管已经监听了TextDidChange的通知，也要监听text属性，因为通知监听不到setText：
        NSArray *propertys = @[@"frame", @"bounds", @"font", @"text", @"textAlignment", @"textContainerInset"];
        
        // 监听属性
        for (NSString *property in propertys) {
            [self addObserver:self forKeyPath:property options:NSKeyValueObservingOptionNew context:nil];
        }
        
    }
    return placeholderView;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    // 为placeholder赋值
    [self placeholderView].text = placeholder;
}

- (NSString *)placeholder
{
    // 如果有placeholder值才去调用，这步很重要
    if (self.placeholderExist) {
        return [self placeholderView].text;
    }
    return nil;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    // 如果有placeholder值才去调用，这步很重要
    if (!self.placeholderExist) {
       
    } else {
        self.placeholderView.textColor = placeholderColor;
        
        // 动态添加属性的本质是: 让对象的某个属性与值产生关联
        objc_setAssociatedObject(self, WZBPlaceholderColorKey, placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIColor *)placeholderColor {
    return objc_getAssociatedObject(self, WZBPlaceholderColorKey);
}

- (void)setMaxHeight:(CGFloat)maxHeight {
    
    CGFloat max = maxHeight;
    
    // 如果传入的最大高度小于textView本身的高度，则让最大高度等于本身高度
    if (maxHeight < self.frame.size.height) {
        max = self.frame.size.height;
    }
    
    objc_setAssociatedObject(self, WZBTextViewMaxHeightKey, [NSString stringWithFormat:@"%lf", max], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)maxHeight {
    return [objc_getAssociatedObject(self, WZBTextViewMaxHeightKey) doubleValue];
}

- (void)setMinHeight:(CGFloat)minHeight {
    objc_setAssociatedObject(self, WZBTextViewMinHeightKey, [NSString stringWithFormat:@"%lf", minHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)minHeight {
    return [objc_getAssociatedObject(self, WZBTextViewMinHeightKey) doubleValue];
}

- (void)setLastHeight:(CGFloat)lastHeight {
    objc_setAssociatedObject(self, WZBTextViewLastHeightKey, [NSString stringWithFormat:@"%lf", lastHeight], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)lastHeight {
    return [objc_getAssociatedObject(self, WZBTextViewLastHeightKey) doubleValue];
}

- (void)setTextViewHeightDidChanged:(textViewHeightDidChangedBlock)textViewHeightDidChanged {
    objc_setAssociatedObject(self, WZBTextViewHeightDidChangedBlockKey, textViewHeightDidChanged, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (textViewHeightDidChangedBlock)textViewHeightDidChanged {
    void(^textViewHeightDidChanged)(CGFloat currentHeight) = objc_getAssociatedObject(self, WZBTextViewHeightDidChangedBlockKey);
    return textViewHeightDidChanged;
}

- (void)setImageArray:(NSMutableArray *)imageArray {
    objc_setAssociatedObject(self, WZBTextViewImageArrayKey, imageArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)imageArray {
    return objc_getAssociatedObject(self, WZBTextViewImageArrayKey);
}

- (NSArray *)getImages {
    return self.imageArray;
}

#pragma mark - KVO监听属性改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [self refreshPlaceholderView];
    if ([keyPath isEqualToString:@"text"]) [self textViewTextChange];
}

- (void)refreshPlaceholderView {
    
    UITextView *placeholderView = objc_getAssociatedObject(self, WZBPlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (placeholderView) {
        self.placeholderView.frame = self.bounds;
        self.placeholderView.font = self.font;
        self.placeholderView.textAlignment = self.textAlignment;
        self.placeholderView.textContainerInset = self.textContainerInset;
    }
}

- (void)textViewTextChange {
    UITextView *placeholderView = objc_getAssociatedObject(self, WZBPlaceholderViewKey);
    
    // 如果有值才去调用，这步很重要
    if (placeholderView) {
        self.placeholderView.hidden = (self.text.length > 0 && self.text);
    }
    
    if (self.maxHeight >= self.bounds.size.height) {
        
        // 计算高度
        NSInteger currentHeight = ceil([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
        
        // 如果高度有变化，调用block
        if (currentHeight != self.lastHeight) {
            // 是否可以滚动
            self.scrollEnabled = currentHeight >= self.maxHeight;
            CGFloat currentTextViewHeight = currentHeight >= self.maxHeight ? self.maxHeight : currentHeight;
            // 改变textView的高度
            if (currentTextViewHeight >= self.minHeight) {
                CGRect frame = self.frame;
                frame.size.height = currentTextViewHeight;
                self.frame = frame;
                // 调用block
                if (self.textViewHeightDidChanged) self.textViewHeightDidChanged(currentTextViewHeight);
                // 记录当前高度
                self.lastHeight = currentTextViewHeight;
            }
        }
    }
    
//    if (!self.isFirstResponder) [self becomeFirstResponder];
}

- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight {
    [self autoHeightWithMaxHeight:maxHeight textViewHeightDidChanged:nil];
}

- (void)autoHeightWithMaxHeight:(CGFloat)maxHeight textViewHeightDidChanged:(void(^)(CGFloat currentTextViewHeight))textViewHeightDidChanged {
    [self placeholderView];
    self.maxHeight = maxHeight;
    if (textViewHeightDidChanged) self.textViewHeightDidChanged = textViewHeightDidChanged;
}

// 判断是否有placeholder值，这步很重要
- (BOOL)placeholderExist {
    
    // 获取对应属性的值
    UITextView *placeholderView = objc_getAssociatedObject(self, WZBPlaceholderViewKey);
    
    // 如果有placeholder值
    if (placeholderView) return YES;
    
    return NO;
}

- (void)addImage:(UIImage *)image {
    [self addImage:image size:CGSizeZero];
}

/* 添加一张图片 image:要添加的图片 size:图片大小 */
- (void)addImage:(UIImage *)image size:(CGSize)size {
    [self insertImage:image size:size index:self.attributedText.length > 0 ? self.attributedText.length : 0];
}
/* 插入一张图片 image:要添加的图片 size:图片大小 index:插入的位置 */
- (void)insertImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index {
    [self addImage:image size:size index:index multiple:-1];
}

/* 添加一张图片 image:要添加的图片 multiple:放大／缩小的倍数 */
- (void)addImage:(UIImage *)image multiple:(CGFloat)multiple {
    [self addImage:image size:CGSizeZero index:self.attributedText.length > 0 ? self.attributedText.length : 0 multiple:multiple];
}
/* 插入一张图片 image:要添加的图片 multiple:放大／缩小的倍数 index:插入的位置 */
- (void)insertImage:(UIImage *)image multiple:(CGFloat)multiple index:(NSInteger)index {
    [self addImage:image size:CGSizeZero index:index multiple:multiple];
}

- (void)addImage:(UIImage *)image size:(CGSize)size index:(NSInteger)index multiple:(CGFloat)multiple {
    if (image) [self.imageArray addObject:image];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;
    CGRect bounds = textAttachment.bounds;
    if (!CGSizeEqualToSize(size, CGSizeZero)) {
        bounds.size = size;
        textAttachment.bounds = bounds;
    } else if (multiple <= 0) {
        CGFloat oldWidth = textAttachment.image.size.width;
        CGFloat scaleFactor = oldWidth / (self.frame.size.width - 10);
        textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    } else {
        bounds.size = image.size;
        textAttachment.bounds = bounds;
    }
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString replaceCharactersInRange:NSMakeRange(index, 0) withAttributedString:attrStringWithImage];
    self.attributedText = attributedString;
    [self textViewTextChange];
    [self refreshPlaceholderView];
    
}

@end
