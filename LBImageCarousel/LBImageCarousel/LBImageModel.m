//
//  LBImageModel.m
//  图片轮播器
//
//  Created by 李斌 on 15/11/26.
//  Copyright © 2015年 Libin. All rights reserved.
//

#import "LBImageModel.h"

@implementation LBImageModel
+(instancetype)modelWithImageName:(NSString *)imageName{
    return [[self alloc] initWithImageName:imageName];
}
- (instancetype)initWithImageName:(NSString *)imageName{
    if (self = [super init]) {
        _imageName = imageName;
    }
    return self;
}

@end
