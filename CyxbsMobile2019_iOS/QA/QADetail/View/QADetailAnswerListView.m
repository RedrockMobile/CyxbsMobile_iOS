//
//  QADetailAnswerListView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailAnswerListView.h"

@implementation QADetailAnswerListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = NSStringFromClass(self.class);
        [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.contentView];
    }
    return self;
}
-(void)setupView:(NSDictionary *)dic{
    self.answerId = [dic objectForKey:@"id"];
    
    self.adoptBtn.layer.cornerRadius = 10;
    self.adoptBtn.tag = self.answerId.integerValue;
    
    self.separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    self.separateView.alpha = 0.1;
    [self.userNameLabel setText:[dic objectForKey:@"nickname"]];
    NSURL *userIconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"photo_thumbnail_src"]]];
    
    [self.userIcon setImageWithURL:userIconUrl placeholder:[UIImage imageNamed:@"userIcon"]];
    
    [self.timeLabel setText:[dic objectForKey:@"created_at"]];
    
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@条回复",[dic objectForKey:@"comment_num"]] forState:UIControlStateNormal];
    self.commentBtn.tag = self.answerId.integerValue;
    
    self.praiseNumLabel.text = [dic objectForKey:@"praise_num"];
    
    NSNumber *is_praised = [dic objectForKey:@"is_praised"];
    if (is_praised.integerValue == 1) {
        [self.praiseBtn setSelected:YES];
    }
    self.praiseBtn.tag = self.answerId.integerValue;
    
    NSNumber *is_adopt = [dic objectForKey:@"is_adopt"];
    if (is_adopt.integerValue == 1) {
        [self.adoptBtn setSelected:YES];
        self.adoptBtn.backgroundColor = [UIColor colorWithHexString:@"#E8F0FC"];
        [self.adoptBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"#94A6C4"]];
    }
    [self.contentLabel setText:[dic objectForKey:@"content"]];
    [self.praiseBtn addTarget:self.superview action:@selector(tapPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.adoptBtn addTarget:self.superview action:@selector(tapAdoptBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.commentBtn addTarget:self.superview action:@selector(tapCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

@end
