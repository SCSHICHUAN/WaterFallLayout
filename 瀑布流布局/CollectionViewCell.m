//
//  CollectionViewCell.m
//  瀑布流布局
//
//  Created by 石川 on 2020/1/9.
//  Copyright © 2020 石川. All rights reserved.
//

#import "CollectionViewCell.h"
#import "MJRefresh.h"
#import <SDWebImage/SDWebImage.h>

@interface CollectionViewCell()
{
    UIImageView *imagev;
}
@end
@implementation CollectionViewCell
{
    
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = UIColor.lightGrayColor;
        [self setUI];
    }
    return self;
}
-(void)setUI
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.contentView addSubview:imageView];
    imagev = imageView;
}
-(void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    NSURL *url = [NSURL URLWithString:imageUrl];
       [imagev sd_setImageWithURL:url placeholderImage:nil];
}
@end
