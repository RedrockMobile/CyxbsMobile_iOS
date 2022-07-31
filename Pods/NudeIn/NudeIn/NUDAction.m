//  NUDAction.m
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

#import "NUDAction.h"

@implementation NUDAction

@end

@implementation NUDLinkAction

@end

@implementation NUDTapAction

@end

@implementation NUDAttachmentAction

@end

@implementation NUDSelector

- (id)copyWithZone:(NSZone *)zone {
    NUDSelector *selector = [[[self class] alloc] init];
    selector.target = self.target;
    selector.action = self.action;
    selector.obj = self.obj;
    return selector;
}

- (NSString *)name {
    return NSStringFromSelector(self.action);
}

- (void)performAction:(NUDAction *)action {
    if ([self.target respondsToSelector:self.action]) {
        IMP p = [self.target methodForSelector:self.action];
        void (*method)(id,SEL,NUDAction *) = (void *)p;
        method(self.target,self.action,action);
    }
}

+ (void)perFormSelectorWithString:(NSString *)string target:(id)target {
    IMP p = [target methodForSelector:NSSelectorFromString(string)];
    void (*method)(id,SEL) = (void *)p;
    method(target,NSSelectorFromString(string));
}



@end
