//
//  TODOModel.m
//  ZY
//
//  Created by 欧紫浩 on 2021/8/12.
//

#import "TODOModel.h"

@implementation TODOModel

-(void)encodeWithCoder:(NSCoder *)coder{
    NSInteger timestamp =1;
    id b =@(timestamp);
    [coder encodeObject:_modeltodo_thing forKey:@"thing"];
    [coder encodeObject:b forKey:@"time"];
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super init]){
        self.modeltodo_thing = [coder decodeObjectForKey:@"thing"];
        self.b = [coder decodeObjectForKey:@"time"];
    }
    return  self;
}
@end
