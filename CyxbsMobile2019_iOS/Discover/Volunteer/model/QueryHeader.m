//
//  QueryHeader.m
//  MoblieCQUPT_iOS
//
//  Created by MaggieTang on 08/10/2017.
//  Copyright © 2017 Orange-W. All rights reserved.
//

#import "QueryHeader.h"
@interface QueryHeader()

@property UIImageView *redLine;
@property CGFloat itemWidth;
@property CGFloat itemHeight;
@end

@implementation QueryHeader

- (instancetype)initWithFrame:(CGRect)frame andControllers:(NSArray <UIViewController *> *)controllers {
    self = [self initWithFrame:frame];
    if(self){
        self.controllers = controllers;
        if (self.controllers.count >=5) {
            self.itemWidth = MAIN_SCREEN_W/5;
        }
        else{
            self.itemWidth = MAIN_SCREEN_W/self.controllers.count;
        }
        [self setItems:_items];
    }
    return self;
}

-(void)setItems:(NSArray *)items
{
    _items = items;
    _itemWidth =MAIN_SCREEN_W/5;
    _itemHeight = self.frame.size.height-2;
    _btnArray = [NSMutableArray<UIButton *> array];

    for (int i = 0; i < items.count; i++) {
            
        UIButton *button = [[UIButton alloc]initWithFrame: CGRectMake(i*_itemWidth, 0, _itemWidth, _itemHeight)];
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor]forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        UIColor *myColor = [UIColor colorWithRed:250/255.0 green:128/255.0 blue:114/225.0 alpha:1];
        [button setTitleColor:myColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = Button_Origin_Tag+i;
        [self addSubview:button];
        [_btnArray addObject:button];
        if (i == 0) {
            button.selected = YES;
        }
    }
        _redLine = [[UIImageView alloc]init];
        _redLine.frame = CGRectMake(0, self.frame.size.height-2, _itemWidth, 2);
        _redLine.image = [UIImage imageNamed:@"scroll"];
        _redLine.contentMode = UIViewContentModeCenter;
        [self addSubview:_redLine];
}


-(void)buttonClick:(UIButton*)button{
    NSInteger index = button.tag - Button_Origin_Tag;
    [self setSelectAtIndex:index];
}
-(void)setSelectAtIndex:(NSInteger)index{
    for (int i = 0; i < self.items.count; i++) {
        UIButton * button = [self viewWithTag:i+Button_Origin_Tag];
        
        if (button.tag-Button_Origin_Tag == index) {
            button.selected = YES;
            if (self.itemClickAtIndex) {
                _itemClickAtIndex(index);
            }
        }else{
            button.selected = NO;
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = _redLine.frame;
        rect.origin.x = index*rect.size.width;
        _redLine.frame = rect;
    }];
}


@end
