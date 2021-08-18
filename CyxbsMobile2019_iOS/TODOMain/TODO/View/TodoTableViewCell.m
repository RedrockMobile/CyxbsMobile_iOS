//
//  TodoTableViewCell.m
//  ZY
//
//  Created by 欧紫浩 on 2021/8/13.
//

#import "TodoTableViewCell.h"
#import "TODOModel.h"

@interface TodoTableViewCell ()
@property(nonatomic, strong) UIButton *circlebtn;
@property(nonatomic, strong) TODOModel *model;
@property(nonatomic, strong) UIView *lineV;
@end

@implementation TodoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

/// 圆圈按钮点击事件
-(void)select{
    NSLog(@"圆圈按钮被点击");
    if (!self.model) {
        NSLog(@"666666");
        return;
    }
     
    self.model.isDone = true;
    if (self.delegate && [self.delegate respondsToSelector:@selector(todoCellDidClickedDoneButton:)]) {
        [self.delegate todoCellDidClickedDoneButton:self];
    }
}

/// 配置UI
- (void)configUI {
    self.circlebtn = [[UIButton alloc] init];
    self.circlebtn.frame = CGRectMake(16, 16, 32, 32);
    [self.circlebtn setBackgroundImage:[UIImage imageNamed:@"未打勾"] forState:UIControlStateNormal];
    [self.circlebtn setBackgroundImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateSelected];
    [_circlebtn addTarget:self action:@selector(select) forControlEvents:UIControlEventTouchUpInside];
//    [_circlebtn.layer setMasksToBounds:YES]; //该方法设置后可以显示button的圆角
//    [_circlebtn.layer setCornerRadius:17.6];
//    [_circlebtn.layer setBorderColor:[UIColor grayColor].CGColor];
//    [_circlebtn.layer setBorderWidth:1];
    [self.contentView addSubview:self.circlebtn];
    self.nameL = [[UILabel alloc] init];
    self.nameL.frame = CGRectMake(64, 16, 280, 32);
    self.nameL.font = [UIFont fontWithName:@"PingFangSC-normal" size:16];
    [self.contentView addSubview:self.nameL];
    
    self.timeL = [[UILabel alloc] init];
    self.timeL.frame = CGRectMake(64, 64, 280, 32);
    [self.contentView addSubview:self.timeL];
    
    self.lineV = [UIView new];
    self.lineV.backgroundColor = [UIColor colorWithRed:0xEB/ 255.0 green:0xEB/ 255.0 blue:0xEB/ 255.0 alpha:1.0];
    [self.contentView addSubview:self.lineV];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.lineV.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
}

- (void)configTODOModel:(TODOModel *)model {
    self.model = model;
    
    self.nameL.text = model.modeltodo_thing;
    if (model.isDone) {
        
        self.nameL.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        self.timeL.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
    } else {
        self.nameL.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
        self.timeL.textColor = [UIColor colorNamed:@"21_49_91&240_240_242"];
    }

    self.circlebtn.selected = model.isDone;
    self.circlebtn.userInteractionEnabled = !model.isDone;
    
    if (model.timestamp > 0) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.timestamp];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd HH:mm";
        self.timeL.text = [formatter stringFromDate:date];
    } else {
        self.timeL.text = nil;
    }
}

@end
