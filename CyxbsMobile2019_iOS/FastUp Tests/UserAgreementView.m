//
//  UserAgreementView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/29.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "UserAgreementView.h"

#import <CocoaMarkdown/CocoaMarkdown.h>

#pragma mark - UserAgreementView ()

@interface UserAgreementView ()

/// title
@property (nonatomic, strong) UILabel *titleLab;

/// text view
@property (nonatomic, strong) UITextView *agreementTextView;

@end

#pragma mark - UserAgreementView

@implementation UserAgreementView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =
        [UIColor Light:UIColorHex(#F8F9FC) Dark:UIColorHex(#000000)];
        self.layer.cornerRadius = 5;
        
        [self addSubview:self.titleLab];
        [self addSubview:self.agreementTextView];
    }
    return self;
}

- (void)_addAttribute {
    dispatch_async(dispatch_queue_create("UserAgreementView._addAttribute", DISPATCH_QUEUE_CONCURRENT), ^{
        CMDocument *document = [[CMDocument alloc] initWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"UserAgreement" ofType:@"md"] options:CMDocumentOptionsSmart];
        CMTextAttributes *attributes = [[CMTextAttributes alloc] init];
        attributes.h2Attributes = @{
            NSFontAttributeName : [UIFont fontWithName:FontName.PingFangSC.Semibold size:18],
            NSBackgroundColorAttributeName : [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)]
        };
        attributes.textAttributes = @{
            NSFontAttributeName : [UIFont fontWithName:FontName.PingFangSC.Medium size:14],
            NSBackgroundColorAttributeName : [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)]
        };
        NSAttributedString *string = [document attributedStringWithAttributes:attributes];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.agreementTextView.attributedText = string;
        });
    });
}

#pragma mark - Getter

- (UILabel *)titleLab {
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:self.SuperFrame];
        _titleLab.backgroundColor = self.backgroundColor;
        _titleLab.height = 48;
        _titleLab.text = @"掌上重邮用户协议";
        _titleLab.font = [UIFont fontWithName:FontName.PingFangSC.Semibold size:22];
        _titleLab.textColor =
        [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)];
    }
    return _titleLab;
}

- (UITextView *)agreementTextView {
    if (_agreementTextView == nil) {
        _agreementTextView = [[UITextView alloc] initWithFrame:CGRectMake(3, 3, self.width - 6, self.height - 6)];
    }
    return _agreementTextView;
}

@end
