//
//  IDCardAnimationView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2021/9/28.
//  Copyright © 2021 Redrock. All rights reserved.
//

//MARK: - 为了使变量在数学运算看起来更简洁，方便查看表达式，部分变量采用缩写。汇总如下：
// tp：target point 目标点
// dt：吸附状态时的形变，全称为 destination transform
// bt：手势开始时的形变，全称为 began transform
// tt：调用一次拖拽手势后的理论形变, 全写为theoretical transform
// dv: 表示手势位置的向量，从_destinationOrigin指向self.frame.origin，全称：position Vector
// vv: 手势的速度向量 全写为 velocity Vector

#import "IDCardAnimationView.h"
#import "IDMsgDisplayView.h"
#import <AVFoundation/AVFoundation.h>
// 卡片宽高，不包含 cell 底部的白边
#define idCardWidth 0.9146666667*SCREEN_WIDTH
#define idCardHeight 0.3333333333*SCREEN_WIDTH
//开启CCLog
#define CCLogEnable 1

@interface IDCardAnimationView ()<
    UIGestureRecognizerDelegate
> {
    // 会被吸附的距离
    double _lockDistance;
    // cell 高度
    double _cellHeight;
}

@property (nonatomic, assign)BOOL isLockingWithAnimation;

/// 手势开始时是否已经是lock的状态
@property (nonatomic, assign)BOOL isLockedBegan;

/// 是否可以解锁
@property (nonatomic, assign)BOOL canUnLock;

/// 当前状态是否是锁住
@property (nonatomic, assign)BOOL isLocked;

/// 是否可以识别pan手势
@property (nonatomic, assign)BOOL pgrShouldBegin;

/// 拖拽手势
@property (nonatomic, strong)UIPanGestureRecognizer *pgr;

/// 长按手势
@property (nonatomic, strong)UILongPressGestureRecognizer *lpgr;

/// 在上方展示的 idCard
@property (nonatomic, strong)IDMsgDisplayView *dispayedIdMsgView;

/// 被拖拽的卡片的顶部区域的截图
@property (nonatomic, strong) UIImageView *topImgView;

/// 被拖拽的卡片所在区域的截图
@property (nonatomic, strong) UIImageView *dragImgView;

/// 被拖拽的卡片的底部区域的截图
@property (nonatomic, strong) UIImageView *bottomImgView;

/// 白色背景板
@property (nonatomic, strong) UIView *whiteBlockView;

/// tableView 的contentOffset 备份
@property (nonatomic, assign) CGPoint contOffset_bk;

/// cell 刚刚被拖拽时在 self 中的 y
@property (nonatomic, assign)CGFloat beganYOfCellInSelf;

/// 身份卡片被拖拽的目标矩形区域的 origin
@property (nonatomic, assign)CGPoint tp;

// 临时的，只有在动画进行期间用到的数据
@property (nonatomic, assign)CGRect cellFrame_tmp;
@property (nonatomic, strong)NSIndexPath *cellIndexPath_tmp;
@property (nonatomic, strong)UITableView *tableView_tmp;

@end

@implementation IDCardAnimationView

- (instancetype)initWithTargetPoint:(CGPoint)tp cellHeight:(CGFloat)cellHeight
{
    self = [super init];
    if (self) {
        // 会被吸附的距离(这里选取值为1/2的self高度)
        _lockDistance = 0.1666666667*SCREEN_WIDTH;
        _cellHeight = cellHeight;
        
        self.frame = [UIScreen mainScreen].bounds;
        self.tp = tp;
        [self configGesture];
    }
    return self;
}

// 不一定每次都用上，所以是懒加载
- (IDMsgDisplayView *)dispayedIdMsgView {
    if (_dispayedIdMsgView==nil) {
        IDMsgDisplayView *msgView = [[IDMsgDisplayView alloc] init];
        _dispayedIdMsgView = msgView;
        
        [self addSubview:msgView];
        msgView.frame = CGRectMake(_tp.x, _tp.y, idCardWidth, idCardHeight);
    }
    return _dispayedIdMsgView;
}

- (UIImageView *)topImgView {
    if (_topImgView==nil) {
        _topImgView = [[UIImageView alloc] init];
    }
    return _topImgView;
}

- (UIImageView *)dragImgView {
    if (_dragImgView==nil) {
        _dragImgView = [[UIImageView alloc] init];
    }
    return _dragImgView;
}

- (UIImageView *)bottomImgView {
    if (_bottomImgView==nil) {
        _bottomImgView = [[UIImageView alloc] init];
    }
    return _bottomImgView;
}

- (UIView *)whiteBlockView {
    if (_whiteBlockView==nil) {
        _whiteBlockView = [[UIView alloc] init];
        _whiteBlockView.backgroundColor = [UIColor dm_colorWithLightColor:RGBColor(255, 255, 255, 1) darkColor:RGBColor(29, 29, 29, 1)];
    }
    return _whiteBlockView;
}


- (void)configGesture {
    //++++++++++++++++++添加长按手势++++++++++++++++++++  Begain
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panWithPGR:)];
    self.pgr = pgr;
    [self addGestureRecognizer:pgr];
    pgr.delegate = self;
    //++++++++++++++++++添加长按手势++++++++++++++++++++  End
    
    
    //++++++++++++++++++添加拖拽手势++++++++++++++++++++  Begain
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWithLPGR:)];
    self.lpgr = lpgr;
    [self addGestureRecognizer:lpgr];
    lpgr.delegate = self;
    //++++++++++++++++++添加拖拽手势++++++++++++++++++++  End
}


- (IDModel *)model {
    return self.dispayedIdMsgView.model;
}

- (void)setModel:(IDModel *)model {
    self.dispayedIdMsgView.model = model;
}


- (void)longPressWithLPGR:(UILongPressGestureRecognizer*)lpgr {
    if (lpgr.state==UIGestureRecognizerStateBegan) {
        CCLog(@"longPressWithLPGR");
        self.pgrShouldBegin = [self judgePGRShouldBeginAndInitTempDataWithPoint:[lpgr locationInView:_tableView_tmp]];
    }else if(lpgr.state==UIGestureRecognizerStateEnded) {
        /*
         移除伪装：
         如果卡片没有移到上方
            ①将 cell 添加到 tableView
            ②复原 tableView.contentOffset
            ③使用动画将 伪装view 回弹到起始位置
            ④移除 伪装view
         如果卡片移动到了上方
            ①将旧的卡片添加到 tableView
            ②使伪装view 和 tableView 位置重合
            ③移除 伪装View
         */
        self.pgrShouldBegin = NO;
        CCLog(@"ENDD+++");
    }
}

/// 判断手指点击的地方是否在一个合法的 cell 上，如果合法，将 cell 的 frame 拷贝出来
- (BOOL)judgePGRShouldBeginAndInitTempDataWithPoint:(CGPoint)tblvPoint {
    // 目前没有取消展示身份的这个需求，所以先把卡片下拉回tableView的功能禁用掉
    UITableView *tableView = self.tableView_tmp =  [self.delegate currentTableView:self];
    
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:tblvPoint];
    
    // 如果 indexPath 是空的，那么是非法的
    if (indexPath==NULL) { return NO; }
    CGRect cellFrame = [tableView cellForRowAtIndexPath:indexPath].frame;
    // cell.y < contentOffset.y 时动画不好看，所以禁止掉
    if (cellFrame.origin.y < tableView.contentOffset.y) { return NO; }
    self.cellIndexPath_tmp = indexPath;
    self.cellFrame_tmp = cellFrame;
    return YES;
}


/*
 ① 判断有没有命中一个 cell 或者 最顶部的卡片
 
 */
- (void)imageView:(UIImageView*)imgView setImgfrom:(UIView*)view frame:(CGRect)frame radius:(CGFloat)r {
    imgView.frame = [self convertRect:frame fromView:view];
    imgView.image = [self getImgOfView:view inFrame:frame radius:r];
    [self addSubview:imgView];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%.0f.png", frame.origin.y]];
    [UIImagePNGRepresentation(imgView.image) writeToFile:path atomically:YES];
}

- (void)addDisguiseView {
    /*
     添加伪装
     ①添加伪装 view（要把整个tableView盖住）
     ②记录 tableView.contentOffset
     ③把 cell 从 tableView 移除
     ④伪装view随着拖拽卡片移动
     */
    // ①添加伪装 view（要把整个tableView盖住）
    [self addDisguiseViewCellFrame:_cellFrame_tmp];
    // ②记录 tableView.contentOffset
    self.contOffset_bk = _tableView_tmp.contentOffset;
    // ③把 cell 从 tableView 移除
//            IDModel *model = [self.delegate getModelforIndexPath:indexPath pageIndex:[self.delegate currentSegmentViewIndex:self] :self];
//            [self.delegate removeCellWithModel:model :self];
}
/// 添加手指点击在 cellFrame 对应的 cell 时的伪装
- (void)addDisguiseViewCellFrame:(CGRect)cellFrame {
     /*
      ①添加伪装 view（要把整个tableView盖住）
        1.添加白板
        2.截屏
        3.将截取到的图片显示出来
      */
    UITableView *tableView = [self.delegate currentTableView:self];
    // cell 在 self 的 origin 的 y
    CGFloat cy_s = [self convertPoint:cellFrame.origin fromView:tableView].y;
    // tableView 在 self 的 frame
    CGRect tableFrame_s = [self convertRect:tableView.frame fromView:tableView.superview];
    
    self.whiteBlockView.frame = tableFrame_s;
//    self.whiteBlockView.backgroundColor = [UIColor grayColor];
    [self addSubview:self.whiteBlockView];
    
    CGFloat cy = cellFrame.origin.y, cw = cellFrame.size.width, ch = cellFrame.size.height, tcy = tableView.contentOffset.y;
    
    // topImg 在 tableView 中的 frame
    CGRect topImgFrame = CGRectMake(0,
                                    tcy,
                                    cw,
                                    cy - tcy);
    
    // bottomImg 在 tableView 中的 frame
    CGRect bottomImgFrame = CGRectMake(0,
                                       cy + ch,
                                       cw,
                                       SCREEN_HEIGHT-cy_s+ch);
    
    // 截取图形，并在 imgView 上显示，并调整 imgView 的 frame
    [self imageView:self.topImgView setImgfrom:tableView frame:topImgFrame radius:-1];
    [self imageView:self.bottomImgView setImgfrom:tableView frame:bottomImgFrame radius:-1];
    [self imageView:self.dragImgView setImgfrom:tableView frame:(CGRect){cellFrame.origin, cellFrame.size.width, idCardHeight} radius:9.5];
    
    CCLog(@"%@", NSHomeDirectory());
}


// 待优化
- (void)panWithPGR:(UIPanGestureRecognizer*)pgr {
    if (pgr.state==UIGestureRecognizerStateBegan) {
        [self addDisguiseView];
        CCLog(@"panWithPGR");
        self.isLockedBegan = self.isLocked;
        self.canUnLock = YES;
        [pgr setTranslation:self.dragImgView.frame.origin inView:self];
        self.beganYOfCellInSelf = self.dragImgView.frame.origin.y;
    }
    printf("%.2f\n", self.dragImgView.frame.origin.y);
    //调用完该方法后的理论origin, 全写为theoretical origin
    CGPoint to = [pgr translationInView:self];
    
    //调用完该方法后和的理论距离
    CGFloat theoryDistance = sqrt((_tp.x-to.x)*(_tp.x-to.x) + (_tp.y-to.y)*(_tp.y-to.y));
    
    // pv: position vector，表示手势位置的向量，
    // pv 从 _destinationOrigin 指向 idMsgDispayedView.frame.origin
    CGPoint pv = CGPointMake(self.dragImgView.frame.origin.x - _tp.x, self.dragImgView.frame.origin.y - _tp.y);
    
    //vv: velocity vector，即手势的速度向量
    CGPoint vv = [pgr velocityInView:self.superview];
    //pv.x * vv.x + pv.y * vv.y是pv与vv的内积，为负数代表self正在靠近矩形框，
    
    //强转为int避免由于浮点数精度问题而导致误判
    BOOL isApproaching = ((int)(pv.x * vv.x + pv.y * vv.y)) < 0;
    
    CCLog(@"%.2f", sqrt(vv.x*vv.x + vv.y*vv.y));
    if (self.isLocked) {
        //判定是否要解锁
        if (self.canUnLock && isApproaching==NO && self.isLockingWithAnimation==NO) {
            self.isLocked = NO;
            self.dragImgView.origin = to;
            [self dragCardOutImpact];
        }else {
            [pgr setTranslation:_tp inView:self];
        }
    }else {
        //判定是否要吸附
        if (isApproaching==YES && theoryDistance<=_lockDistance && (sqrt(vv.x*vv.x + vv.y*vv.y)) < 100) {
            //吸附
            self.isLocked = YES;
            self.canUnLock = NO;
            [pgr setTranslation:_tp inView:self];
            [self performLockAnimation];
        }else {
            self.dragImgView.origin = to;
        }
    }
    
    //在手势终止时，做一些收尾工作：判定要吸附还是弹回原位
    if (pgr.state==UIGestureRecognizerStateEnded) {
        [pgr setTranslation:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT) inView:self];
        //这里选取值为2/3的self高度
        if (theoryDistance > 0.222222*SCREEN_WIDTH) {
            // 回弹
            [self performBounceBackAnimation];
        }else if(self.isLocked==NO) {
            // 吸附
            self.isLocked = YES;
            [self performLockAnimation];
        }else {
            // 已经吸附
            
        }
        CCLog(@"吸附");
    }
    
    [self idCardPanGestureDidChange];
}


- (void)idCardPanGestureDidChange {
    if (fabs(self.bottomImgView.frame.origin.y-self.beganYOfCellInSelf) < DBL_EPSILON || self.isLockingWithAnimation) { return; }
    //让bottomImgView的顶部贴着operatingIDCardView的底部
    CGRect frame = self.bottomImgView.frame;
    frame.origin.y = self.dragImgView.frame.origin.y + _cellHeight;
    //y不允许超过self.bottomImgViewDestinationOriginY
    if (frame.origin.y < self.beganYOfCellInSelf) {
        frame.origin.y = self.beganYOfCellInSelf;
    }
    self.bottomImgView.frame = frame;
}

- (void)performLockAnimation {
    if (self.isLockingWithAnimation==YES) { return; }
    self.isLockingWithAnimation = YES;
    
    [self bringSubviewToFront:self.dispayedIdMsgView];
    [self insertSubview:self.dispayedIdMsgView belowSubview:self.dragImgView];
    IDModel *oldModel = self.dispayedIdMsgView.model;
    if (!oldModel) {
        [UIView animateWithDuration:idCardAnimationTime animations:^{
            self.dragImgView.origin = self->_tp;
        }completion:^(BOOL finished) {
            self.isLockingWithAnimation = NO;
            [self cardAttachImpact];
            CCLog(@"吸lock");
            [self endAnimationWithState:[self getStateOptionWithBegan:self->_isLocked final:self->_isLocked]];
        }];
        return;
    }
    
    
    NSInteger idx = [self.delegate currentSegmentViewIndex:self];
    NSInteger option = [oldModel.idTypeStr isEqualToString:IDModelIDTypeAut] * 2 + idx;
    
    CGRect idCardFrame = self.dispayedIdMsgView.frame, bottomImgFrame = self.bottomImgView.frame;
    
    switch (option) {
        case 0:
            // 右移
            idCardFrame.origin = [self convertPoint:self.cusTableView.origin fromView:self.cusTableView.superview];
            break;
        case 1:
            // 同一个页面的卡片置换
            idCardFrame.origin = [self convertPoint:self.cellFrame_tmp.origin fromView:self.tableView_tmp];
            bottomImgFrame.origin.y += _cellHeight;
            break;
        case 2:
            // 同一个页面的卡片置换
            idCardFrame.origin = [self convertPoint:self.cellFrame_tmp.origin fromView:self.tableView_tmp];
            bottomImgFrame.origin.y += _cellHeight;
            break;
        case 3:
            // 左移
            idCardFrame.origin = [self convertPoint:self.autTableView.origin fromView:self.autTableView.superview];
            break;
            
        default:
            break;
    }
    [UIView animateWithDuration:idCardAnimationTime animations:^{
        self.dragImgView.origin = self->_tp;
        self.dispayedIdMsgView.frame = idCardFrame;
        self.bottomImgView.frame = bottomImgFrame;
    }completion:^(BOOL finished) {
        self.isLockingWithAnimation = NO;
        [self cardAttachImpact];
        CCLog(@"吸lock");
        [self endAnimationWithState:[self getStateOptionWithBegan:self->_isLocked final:self->_isLocked]];
    }];
}

- (void)performBounceBackAnimation {
    [UIView animateWithDuration:idCardAnimationTime animations:^{
        self.dragImgView.y = self.beganYOfCellInSelf;
        CGRect frame = self.bottomImgView.frame;
        frame.origin.y = self.beganYOfCellInSelf + self->_cellHeight;
        self.bottomImgView.frame = frame;
    } completion:^(BOOL finished) {
        [self cardBounceBackImpact];
        [self endAnimationWithState:[self getStateOptionWithBegan:self->_isLocked final:self->_isLocked]];
    }];
}

- (void)endAnimationWithState:(IDCardViewStateOption)state {
    if (state==IDCardViewStateOptionU2U) {
        [self.topImgView removeFromSuperview];
        [self.dragImgView removeFromSuperview];
        [self.bottomImgView removeFromSuperview];
        [self.whiteBlockView removeFromSuperview];
        return;
    }
    
    IDModel *oldModel = self.dispayedIdMsgView.model;
    IDModel *model = [self.delegate getModelforIndexPath:_cellIndexPath_tmp pageIndex:[self.delegate currentSegmentViewIndex:self] :self];
    [self.delegate setIDCardAsDisplayedWithModel:model :self];
    
    if (oldModel) {
        [self.delegate insertCellWithModel:oldModel atIndexPath:self.cellIndexPath_tmp :self];
    }
    self.dispayedIdMsgView.model = model;
    self.dispayedIdMsgView.frame = CGRectMake(_tp.x, _tp.y, idCardWidth, idCardHeight);
    
//    self.dragImgView.frame = CGRectZero;
    [self.topImgView removeFromSuperview];
    [self.dragImgView removeFromSuperview];
    [self.bottomImgView removeFromSuperview];
    [self.whiteBlockView removeFromSuperview];
    
    // 让 tableview 回弹
    self.tableView_tmp.contentOffset = self.contOffset_bk;
    CGFloat max_offset_y = self.tableView_tmp.contentSize.height - self.tableView_tmp.frame.size.height + self->_cellHeight;
    if (max_offset_y < 0) { max_offset_y = 0; }
    if (self.tableView_tmp.contentOffset.y > max_offset_y) {
        [self.tableView_tmp scrollRectToVisible:CGRectMake(0, max_offset_y, 1, 1) animated:YES];
    }
    CCLog(@"%@", self.tableView_tmp);
    CCLog(@"removeDisguiseView");
}

/// 获取view中，frame对应的矩形区域的截图
- (UIImage*)getImgOfView:(UIView*)view inFrame:(CGRect)frame radius:(CGFloat)r {
    //参数scale要填0，不然图片有些糊
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (r > 0) {
        // 添加圆角
        [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, frame.size.width, frame.size.height) cornerRadius:r] addClip];
    }
    CGContextTranslateCTM(ctx, -frame.origin.x, -frame.origin.y);
    BOOL is = view.clipsToBounds;
    view.clipsToBounds = NO;
    [view.layer renderInContext:ctx];
    view.clipsToBounds = is;
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


//有多个手势时，是否允许同时相应，如果NO，那么如果已经有手势在响应，其他手势就不能响应
//响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
   
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL shouldBegin = NO;
    if (gestureRecognizer==self.pgr) {
        // 让pgr只有在长按后才可以响应。
        if (self.pgrShouldBegin) {
            if (self.model.islate) {
                [NewQAHud showHudAtWindowWithStr:@"该身份已过期" enableInteract:YES];
                UINotificationFeedbackGenerator *notificationFeedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
                [notificationFeedbackGenerator notificationOccurred:UINotificationFeedbackTypeError];
            }else {
                shouldBegin = YES;
                // 拖拽手势即将开始
            }
        }
    }else {
        shouldBegin = YES;
    }
    return shouldBegin;
}

//// gestureRecognizer 是否需要等待 otherGestureRecognizer 识别失败后才能识别 <
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return NO;
//}

// 是否 允许 otherGestureRecognizer 需要等待 gestureRecognizer 识别失败后才能识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 使得 pgr 和 lpgr 的优先级高于其它手势，且 pgr 和 lpgr 平级
    if (otherGestureRecognizer==self.pgr || otherGestureRecognizer==self.lpgr) {
        return NO;
    }
    
    if (gestureRecognizer==self.pgr || gestureRecognizer==self.lpgr) {
        return YES;
    }
    return NO;
}

- (IDCardViewStateOption)getStateOptionWithBegan:(BOOL)isLockedBegan final:(BOOL)isLockedFinal {
    return (IDCardViewStateOption)(((int)isLockedBegan)*2 + (int)isLockedFinal);
}

- (void)setAsDisplayWith:(IDModel*)model {
    self.model = model;
    self.dispayedIdMsgView.origin = _tp;
    self.isLocked = YES;
}

- (void)cleanData {
    self.model = nil;
    self.isLocked = NO;
}

/// 长按卡片后的震动
- (void)longTouchCardImpact {
    AudioServicesPlaySystemSound(1519);
}

/// 卡片吸附住后的震动
- (void)cardAttachImpact {
    AudioServicesPlaySystemSound(1519);
}

/// 从已选择的身份框拖离时调用
- (void)dragCardOutImpact {
    AudioServicesPlaySystemSound(1519);
}

/// 拖拽已过期的卡片到框后震动
- (void)cardAttachFailureImpact {
    UINotificationFeedbackGenerator *notificationFeedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
    [notificationFeedbackGenerator notificationOccurred:UINotificationFeedbackTypeError];
}

/// 卡片回弹的震动
- (void)cardBounceBackImpact {
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleSoft];
    [generator prepare];
    [generator impactOccurred];
}

@end


/*
 //    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleRigid];
 //    [generator prepare];
 //    [generator impactOccurred];
 
     //UIImpactFeedbackStyleRigid:弱弱的快速得震一下
     //UIImpactFeedbackStyleSoft:缓慢地持续的震动一下、绵软悠长
     //UIImpactFeedbackStyleHeavy:快速有力地震一下
     //UIImpactFeedbackStyleMedium:快速而无力地震一下
     //UIImpactFeedbackStyleLight:快速而无力地震一下
 
 
 
 
    // Pop 触感:震感很强
    //AudioServicesPlaySystemSound(1520);
    //Peek 触感:震感比20稍微弱一些
    //AudioServicesPlaySystemSound(1519);
    //三次连续的 Peek 触感振动
    //AudioServicesPlaySystemSound(1521);
 
 
    UINotificationFeedbackGenerator *notificationFeedbackGenerator = [[UINotificationFeedbackGenerator alloc] init];
    [notificationFeedbackGenerator notificationOccurred:UINotificationFeedbackTypeWarning];
    //UINotificationFeedbackTypeError
    //UINotificationFeedbackTypeSuccess
    //UINotificationFeedbackTypeWarning
 
 */

//bug及解决方案:
/*
 ①：
 idCard吸附时，如果使用恒定的动画时间。那么如果用户用较大的拖拽速度拖动卡片到吸入距离后，
 卡片的吸附动画就不能与用户的拖拽动画完美衔接，所以采用了根据拖拽的速度来动态计算动画时间的方案。
 这种方案会导致bug：AuthenticViewController中的exchangeIDCardState调用时机过早，
 导致卡片回弹动画闪烁。
 解决：
 采用统一的动画时间，然后为吸附加一个手势速率小于某个值的条件。
 或者将undisplayedIDCard，displayedIDCard和为一个类，进行更好的配合。
 
 
 */

/*
 动画管理类和控制器耦合太大，职责分离不好。
 未来的优化：
 设计一个动画管理类，全权管理动画，手势。降低对控制器的负担
 动画管理类和 tableView 的数据交流十分频繁，逻辑上，就是一个强耦合关系。
 考虑让动画管理类持有 tableView
 */

/*
 需要 tableView 提供的支持：
    cell 上拉时，获取某个 ponit 对应的cell的全部数据（初步可以预见的有：frame、model、）
    cell 下拉时，获取cell的下拉目标位置的数据（这个数据必须得是动态计算的），同时 tableView
 得配合着移动到合理位置。
    
    tableView 需要可以做到对cell进行增删，并且使 contentOffset 调整到一个合理位置，
 使得 伪装view 和 tableView 可以重合，不会被用户察觉
 
 */

/*
 实现业务的流程：
 ① 完全清楚交互逻辑、各个交互的动画效果、数据流动、合法交互、非法交互、预期之外的问题（网络问题等）
 ② 初步按功能划分实体，要分层
 ③ 分析各个 实体 的间的数据流、互动、依赖，耦合性强的分为一个模块
 ④ 预测未来的扩展，对结构进行微调
 */
