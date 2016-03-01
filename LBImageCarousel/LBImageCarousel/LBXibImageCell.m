//
//  LBXibImageCell.m
//  图片轮播器
//
//  Created by 李斌 on 15/11/26.
//  Copyright © 2015年 Libin. All rights reserved.
//

#import "LBXibImageCell.h"

#import "LBImageModel.h"
@interface LBXibImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation LBXibImageCell
//给cell的组件设置数据
- (void)setImageModel:(LBImageModel *)imageModel{
    _imageView.image = [UIImage imageNamed:imageModel.imageName];
    
}







@end
