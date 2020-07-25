//
//  QAReviewAnswerListView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAReviewAnswerListView.h"

@implementation QAReviewAnswerListView

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
- (void)setupView:(NSDictionary *)dic isSelf:(BOOL)isSelf{
    self.answerId = [dic objectForKey:@"id"];
  
    self.backgroundView.layer.cornerRadius = 15;
    
    [self.userNameLabel setText:[dic objectForKey:@"nickname"]];
    NSURL *userIconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"photo_thumbnail_src"]]];
    
    [self.userIcon setImageWithURL:userIconUrl placeholder:[UIImage imageNamed:@"默认头像"]];
    self.userIcon.layer.cornerRadius = 15;
    
    [self.timeLabel setText:[dic objectForKey:@"created_at"]];
    
  
   

    [self.contentLabel setText:[dic objectForKey:@"content"]];
    [self.contentLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    
    
}

@end
