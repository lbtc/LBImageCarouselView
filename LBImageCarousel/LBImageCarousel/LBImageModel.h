//
//  LBImageModel.h
//  图片轮播器
//
//  Created by 李斌 on 15/11/26.
//  Copyright © 2015年 Libin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBImageModel : NSObject
@property (nonatomic,copy) NSString *imageName;
+ (instancetype)modelWithImageName:(NSString *)imageName;
@end
