//
//  WYCNoteDetailView.m
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/23.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import "WYCNoteDetailView.h"
@interface WYCNoteDetailView()
@property (strong, nonatomic) IBOutlet UILabel *title;

@property (strong, nonatomic) IBOutlet UILabel *content;

@end
@implementation WYCNoteDetailView
+(WYCNoteDetailView *)initViewFromXib{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"WYCNoteDetailView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.frame = CGRectMake(0, 0, 270, 350);
        
    }
    return self;
}

-(void)initWithDic:(NSDictionary *)dic{
    self.title.text = [NSString stringWithFormat:@"备忘: %@",[dic objectForKey:@"title"]];
    self.title.font = [UIFont systemFontOfSize:14];
    self.title.textColor = [UIColor colorWithHexString:@"#444444"];
    self.title.textAlignment = NSTextAlignmentLeft;
    [self.title setNumberOfLines:0];
    self.title.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.content.text = [NSString stringWithFormat:@"内容: %@",[dic objectForKey:@"content"]];
    self.content.font = [UIFont systemFontOfSize:14];
    self.content.textColor = [UIColor colorWithHexString:@"#444444"];
    self.content.textAlignment = NSTextAlignmentLeft;
    [self.content setNumberOfLines:0];
    self.content.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat contentLabelHeight = [self calculateRowHeight:[dic objectForKey:@"content"] fontSize:12 width:self.content.frame.size.width];
    self.content.height = contentLabelHeight;
    
}
- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat)width{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}
@end
