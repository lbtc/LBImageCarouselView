//
//  LBImageCell.m
//  图片轮播器
//
//  Created by 李斌 on 15/11/26.
//  Copyright © 2015年 Libin. All rights reserved.
//

#import "LBImageCell.h"
#import "LBImageModel.h"
@interface LBImageCell ()
@property (nonatomic,strong) UIImageView *imageView;


@end

@implementation LBImageCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

//给cell的组件设置数据
- (void)setImageModel:(LBImageModel *)imageModel{
    _imageView.image = [UIImage imageNamed:imageModel.imageName];
}
//给cell的组件设置frame
- (void)layoutSubviews{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
   
}




@end
