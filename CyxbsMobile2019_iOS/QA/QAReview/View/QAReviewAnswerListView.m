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
        
//        self.backgroundView.layer.cornerRadius = 30;
        [self layoutIfNeeded];
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.backgroundView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(30, 30)];
        CAShapeLayer *cornerRadiusLayer = [ [CAShapeLayer alloc ] init];
        cornerRadiusLayer.frame = self.backgroundView.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        self.backgroundView.layer.mask = cornerRadiusLayer;
    }
    return self;
}
- (void)setupView:(NSDictionary *)dic isSelf:(BOOL)isSelf{
    self.answerId = [dic objectForKey:@"id"];
    
    [self.userNameLabel setText:[dic objectForKey:@"nickname"]];
    NSURL *userIconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"photo_thumbnail_src"]]];
    
    [self.userIcon setImageWithURL:userIconUrl placeholder:[UIImage imageNamed:@"默认头像"]];
    self.userIcon.layer.cornerRadius = 20;
    self.userIcon.clipsToBounds = YES;
    
    [self.timeLabel setText:[dic objectForKey:@"created_at"]];

    [self.contentLabel setText:[dic objectForKey:@"content"]];
    
    if (@available(iOS 11.0, *)) {
        self.userNameLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.contentLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.timeLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
    } else {
        self.userNameLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
        self.contentLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
        self.timeLabel.textColor = [UIColor colorWithHexString:@"#15315B"];
    }
    self.contentLabel.alpha = 0.5;
    self.timeLabel.alpha = 0.54;
}

@end
