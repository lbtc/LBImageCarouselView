//
//  LBImageCell.m
//  图片轮播器
//
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
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_imageView];
        self.backgroundColor = [UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.25];
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
