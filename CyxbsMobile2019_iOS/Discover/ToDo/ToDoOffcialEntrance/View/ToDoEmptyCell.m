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
@property (nonatomic,strong) UIImageView *todoimage;
///待办文字
@property (nonatomic,strong) UILabel *todolbl;
///完成图
@property (nonatomic,strong) UIImageView *finishimage;
///完成文字
@property (nonatomic,strong) UILabel *finishlbl;

@end

@implementation ToDoEmptyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
  
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self configUI];
    }
    return self;
}

/// 配置UI
- (void)configUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _todoimage = [[UIImageView alloc]init];
    _todoimage.image = [UIImage imageNamed:@"待办图"];
    _todoimage.frame = CGRectMake(SCREEN_WIDTH*0.23466, 21, 200, 146.62);
    [self.contentView addSubview:_todoimage];
    
    _todolbl = [[UILabel alloc]init];
    _todolbl.frame = CGRectMake(61, 184, 300, 17);
    _todolbl.text = @"还没有待做事项哦，快去添加吧！";
    _todolbl.textColor = [UIColor colorNamed:@"17_44_84&223_223_227"];
    [self.contentView addSubview:_todolbl];
    
    _finishimage = [[UIImageView alloc]init];
    _finishimage.image = [UIImage imageNamed:@"已完成"];
    _finishimage.frame = CGRectMake(SCREEN_WIDTH*0.23466, 21, 200, 146.62);
    [self.contentView addSubview:_finishimage];
    
    _finishlbl = [[UILabel alloc]init];
    _finishlbl.frame = CGRectMake(50, 184, 350, 17);
    _finishlbl.text = @"还没有已完成事项哦，期待你的好消息！";
    _finishlbl.textColor = [UIColor colorNamed:@"17,44,84,1"];
    _finishlbl.font = [UIFont fontWithName:@"PingFangSC-Noraml" size:8];
    [self.contentView addSubview:_finishlbl];

}

#pragma mark - setter方法
- (void)setType:(NSInteger)type{
    _type = type;
    //待办空视图
    if (type == 0) {
        _finishimage.hidden = true;
        _finishlbl.hidden = true;
        
        _todoimage.hidden = false;
        _todolbl.hidden = false;
    }
    //已办空视图
    else if(type == 1){
        
        _finishimage.hidden = false;
        _finishlbl.hidden = false;
        
        _todoimage.hidden = true;
        _todolbl.hidden = true;
        

    }
}

-(void)setMoel:(TODOModel *)model{
    _model = model;
    self.todo_thing.text = model.modeltodo_thing;
    if (model.timestamp > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
        self.todo_time.text = [formatter stringFromDate:date];
    } else {
        self.todo_time.text = nil;
    }
}
@end
