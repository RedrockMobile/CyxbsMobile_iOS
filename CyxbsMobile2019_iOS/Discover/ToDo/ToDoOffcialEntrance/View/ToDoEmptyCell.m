//
//  ToDoEmptyCell.m
//  ZY
//
//  Created by 欧紫浩 on 2021/8/12.
//
//Views
#import "ToDoEmptyCell.h"
//Controllers
#import "TODOMainViewController.h"
//Models
#import "TODOModel.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ToDoEmptyCell()
///待办图
@property (nonatomic,strong) UIImageView *toDoImageView;
///待办文字
@property (nonatomic,strong) UILabel *todoLbl;
///完成图
@property (nonatomic,strong) UIImageView *doneImageView;
///完成文字
@property (nonatomic,strong) UILabel *doneLbl;

@end

@implementation ToDoEmptyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

/// 配置UI
- (void)configUI{
    
    [self.contentView addSubview:self.toDoImageView];
    [self.contentView addSubview:self.todoLbl];
    [self.contentView addSubview:self.doneImageView];
    [self.contentView addSubview:self.doneLbl];

}

#pragma mark - setter方法
- (void)setType:(NSInteger)type{
    _type = type;
    //待办空视图
    if (type == 0) {
        self.doneImageView.hidden = true;
        self.doneLbl.hidden = true;
        
        self.toDoImageView.hidden = false;
        self.todoLbl.hidden = false;
    }
    //已办空视图
    else if(type == 1){
        self.doneImageView.hidden = false;
        self.doneLbl.hidden = false;
        
        self.toDoImageView.hidden = true;
        self.todoLbl.hidden = true;
    }
}


#pragma mark- getter
- (UIImageView *)toDoImageView{
    if (!_toDoImageView) {
        _toDoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.23466, SCREEN_HEIGHT * 0.0449,SCREEN_WIDTH * 0.6133, SCREEN_WIDTH * 0.3466)];
       _toDoImageView.image = [UIImage imageNamed:@"待办图"];
       
    }
    return _toDoImageView;
}

- (UIImageView *)doneImageView{
    if (!_doneImageView) {
        _doneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.23466, SCREEN_HEIGHT * 0.0449,SCREEN_WIDTH * 0.6133, SCREEN_WIDTH * 0.3466)];;
        _doneImageView.image = [UIImage imageNamed:@"已完成"];
        [self.contentView addSubview:_doneImageView];
    }
    return _doneImageView;
}

- (UILabel *)todoLbl{
    if (!_todoLbl) {
        _todoLbl = [[UILabel alloc] initWithFrame:CGRectMake(61, 184, 300, 17)];
        _todoLbl.text = @"还没有待做事项哦，快去添加吧！";
        _todoLbl.textColor = [UIColor colorNamed:@"17_44_84&223_223_227"];
    }
    return _todoLbl;
}

- (UILabel *)doneLbl{
    if (!_doneLbl) {
        _doneLbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 184, 350, 17)];
        _doneLbl.text = @"还没有已完成事项哦，期待你的好消息！";
        _doneLbl.textColor = [UIColor colorNamed:@"17_44_84&223_223_227"];
        _doneLbl.font = [UIFont fontWithName:@"PingFangSC-Noraml" size:8];
    }
    return _doneLbl;
}

@end
