//
//  TYCollectionViewCell.m
//  TYPictureCarousel
//
//  Created by 马天野 on 2017/6/10.
//  Copyright © 2017年 MTY. All rights reserved.
//

#import "TYCollectionViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface TYCollectionViewCell ()

@property (nonatomic, strong) UIImageView *pictureImageView;

@end

@implementation TYCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:frame];
        self.pictureImageView = pictureImageView;
        [self.contentView addSubview:pictureImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pictureImageView.frame = CGRectMake(0, 0, kScreenWidth, 150);
}

- (void)setPictureName:(NSString *)pictureName {
    _pictureName =  pictureName;
    self.pictureImageView.image = [UIImage imageNamed:pictureName];
}

@end
