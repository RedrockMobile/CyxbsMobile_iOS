//
//  WMTWeekChooseBar.m
//  MoblieCQUPT_iOS
//
//  Created by wmt on 2019/11/3.
//  Copyright © 2019 Orange-W. All rights reserved.
//

#import "WMTWeekChooseBar.h"
@interface WMTWeekChooseBar()
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *selectedTitleColor;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *selectedTitleFont;
@property (nonatomic, strong) NSMutableArray <UIButton *> *btnArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, assign) NSInteger titleCount;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIButton *WMTbtn;
@property (nonatomic, assign) CGFloat btnWidth;
@property (nonatomic, assign) CGFloat scrollViewHeight;
@end

@implementation WMTWeekChooseBar
-(instancetype)initWithFrame:(CGRect)frame nowWeek:(NSNumber *)nowWeek{
    self = [self initWithFrame:frame];
    self.btnArray = [[NSMutableArray alloc]init];
    if(self){
        NSMutableArray *titleArray = [@[@"整学期",@"第一周",@"第二周",@"第三周",@"第四周",@"第五周",@"第六周",@"第七周",@"第八周",@"第九周",@"第十周",@"第十一周",@"第十二周",@"第十三周",@"第十四周",@"第十五周",@"第十六周",@"第十七周",@"第十八周",@"第十九周",@"第二十周",@"二十一周",@"二十二周",@"二十三周",@"二十四周",@"二十五周"] mutableCopy];
       
        
        self.titleArray = titleArray;
        self.titleCount = titleArray.count;
        
        [self setProperty];
        if (self.titleArray.count >=5) {
            _btnWidth = self.frame.size.width/5;
            _scrollViewHeight = self.frame.size.height;
            
        }
        else{
            _btnWidth = self.frame.size.width/self.titleCount;
            _scrollViewHeight = self.frame.size.height;
            
        }
        
        [self setupScrollView];
        [self addBtn];
    }
    return self;
}
//设置属性
- (void)setProperty{
    _index = 0;
    _backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    _selectedTitleColor = [UIColor colorWithHexString:@"#15315B"];
     _titleColor = [UIColor colorWithHexString:@"#15315B"];
    _font = [UIFont systemFontOfSize:14];
    _selectedTitleFont = [UIFont systemFontOfSize:18];
}
//添加scrollView
-(void)setupScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.contentSize = CGSizeMake(_btnWidth*_titleArray.count, _scrollViewHeight);
    _scrollView.backgroundColor = _backgroundColor;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    _sliderView = [[UIView alloc]initWithFrame:CGRectMake(0, _scrollViewHeight-2, _btnWidth, 2)];
    _sliderView.backgroundColor = _selectedTitleColor;
    [_scrollView addSubview:_sliderView];
    [self addSubview:_scrollView];
}

//添加按钮
-(void)addBtn{
    for (int i = 0 ; i < _titleArray.count; i++) {
        _WMTbtn = [[UIButton alloc]initWithFrame:CGRectMake(i*_btnWidth, 0, _btnWidth, _scrollViewHeight)];
        [_WMTbtn setTitle:_titleArray[i] forState:UIControlStateNormal];
        [_WMTbtn setTitleColor:_titleColor forState:UIControlStateNormal];
        [_WMTbtn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        _WMTbtn.tag = i;
        [_WMTbtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btnArray addObject:_WMTbtn];
        [_scrollView addSubview:_WMTbtn];
//        [_btnArray addObject:_WMTbtn];
//        [_scrollView addSubview:_WMTbtn];
    }
}


//按钮点击事件
-(void)clickBtn:(UIButton *)sender{
    
    if (sender.tag != _index) {
        
        _index = sender.tag;
        //NSLog(@"index:%ld",_index);
        [self updateScrollView];
        
        
    }
    
}

-(void)changeIndex:(NSInteger)index{
    _index = index;
    [self updateScrollView];
}

-(void)updateScrollView{
    CGFloat offSetX = (_index - (5/2))*_btnWidth;
    //offSetX = (_index - (_subviewCountInView/2))*_btnWidth;
    if (   (_index - (5/2))*_btnWidth < 0) {
        offSetX = 0;
    }
    if(  (_index + (5/2))*_btnWidth >= _scrollView.contentSize.width){
        offSetX = _scrollView.contentSize.width - 5*_btnWidth;
    }
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self->_scrollView setContentOffset:CGPointMake(offSetX, 0)];
        self->_sliderView.frame = CGRectMake(self->_index * self->_btnWidth, self->_scrollViewHeight - 2, self->_btnWidth, 2);
    } completion:nil];
    for (int i = 0; i < self.btnArray.count; i++) {
           UIButton *btn = self.btnArray[i];
           if (i == self.index) {
               btn.titleLabel.font = _selectedTitleFont;
           }else{
               btn.titleLabel.font = _font;
           }
       }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewBarChanged" object:nil];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
