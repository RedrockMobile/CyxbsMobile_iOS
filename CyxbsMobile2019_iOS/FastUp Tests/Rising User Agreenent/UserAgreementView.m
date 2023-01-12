//
//  UserAgreementView.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/10/29.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "UserAgreementView.h"

#import <MarkDownEditor/MarkDownEditor.h>

#pragma mark - UserAgreementView ()

@interface UserAgreementView ()

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
        self.layer.cornerRadius = 8;
        
        [self addSubview:self.agreementTextView];
        [self _addAttribute];
    }
    return self;
}

- (void)_addAttribute {
    dispatch_async(dispatch_queue_create("UserAgreementView._addAttribute", DISPATCH_QUEUE_CONCURRENT), ^{
        CMDocument *document = [[CMDocument alloc] initWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"UserAgreement" ofType:@"md"] options:CMDocumentOptionsSmart];
        CMTextAttributes *attributes = [[CMTextAttributes alloc] init];
        attributes.h2Attributes = @{
            NSFontAttributeName : [UIFont fontWithName:FontName.PingFangSC.Semibold size:20],
            NSForegroundColorAttributeName : [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)]
        };
        
        attributes.textAttributes = @{
            NSFontAttributeName : [UIFont fontWithName:FontName.PingFangSC.Medium size:16],
            NSForegroundColorAttributeName : [UIColor Light:UIColorHex(#112C54) Dark:UIColorHex(#F0F0F2)]
        };
        
        NSAttributedString *string = [document attributedStringWithAttributes:attributes];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.agreementTextView.attributedText = string;
        });
    });
}

#pragma mark - Getter

- (UITextView *)agreementTextView {
    if (_agreementTextView == nil) {
        _agreementTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, -1, -1)];
        _agreementTextView.width = self.width - 2 * _agreementTextView.left;
        _agreementTextView.height = self.height - 2 * _agreementTextView.top;
        _agreementTextView.center = self.SuperCenter;
        _agreementTextView.backgroundColor = UIColor.clearColor;
        _agreementTextView.editable = NO;
        _agreementTextView.selectable = NO;
    }
    return _agreementTextView;
}

@end
