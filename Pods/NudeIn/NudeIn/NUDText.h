//  NUDText.h
//  Copyright (c) 2018 HJ-Cai
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import "NUDAttribute.h"

@class NUDTextMaker,NUDText,NUDTextUpdate;

@interface NUDText : NUDAttribute<NUDText *> <NSCopying>

@property (nonatomic,copy,readonly) NSString *string;

@property (nonatomic,weak) NUDTextUpdate *update;

- (instancetype)initWithFather:(NUDTextMaker *)maker string:(NSString *)str;

@end

@class NUDTextTemplate;
@interface NUDTextTemplate : NUDAttribute<NUDTextTemplate *> <NUDTemplate>

- (NSDictionary *)tplAttributes;

@end


@interface NUDShadowTag : NSObject <NSCopying>
@property (nonatomic,assign) CGSize shadowOffset;
@property (nonatomic,assign) CGFloat shadowBlur;
@property (nonatomic,assign) UIColor *shadowColor;

- (void)mergeShadowTag:(NUDShadowTag *)shadowTag;
- (NSShadow *)makeShadow;
@end
