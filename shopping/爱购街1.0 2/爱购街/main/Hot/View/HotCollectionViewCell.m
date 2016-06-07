//
//  HotCollectionViewCell.m
//  买买买
//
//  Created by huiwen on 16/2/3.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "HotCollectionViewCell.h"

@implementation HotCollectionViewCell

{
    UIImageView *_imageView;
    UITextView *_nameTextView;
    UILabel *_priceLabel;
    UIView *_goodView;
    UIImageView *_goodImageView;
    UILabel *_goodLabel;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth - 30) / 2, (kScreenWidth - 30) / 2)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 15;
        _imageView.layer.masksToBounds = YES;
        
        _nameTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, (kScreenWidth - 30) / 2 + 10, (kScreenWidth - 30) / 2 - 20, (kScreenWidth - 30) / 8)];
//        _nameTextView.numberOfLines = 2;
        _nameTextView.font = [UIFont systemFontOfSize:16];
        _nameTextView.selectable = NO;
//        _nameTextView.contentMode = UIViewContentModeBottom;
        
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (kScreenWidth - 30) * 3 / 4 - 25, (kScreenWidth - 30) / 4 - 10, 30)];
        _priceLabel.textColor = [UIColor orangeColor];
        
        _goodView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 30) / 2 - 80, (kScreenWidth - 30) * 3 / 4 - 25, 80, 30)];
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
        _goodImageView.image = [UIImage imageNamed:@"Search_GiftBtn_Default@2x"];
        [_goodView addSubview:_goodImageView];
        
        _goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 40, 30)];
        _goodLabel.font = [UIFont systemFontOfSize:11];
        _goodLabel.textColor = [UIColor lightGrayColor];
        [_goodView addSubview:_goodLabel];
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_nameTextView];
        [self.contentView addSubview:_priceLabel];
        [self.contentView addSubview:_goodView];
    }
    
    return self;
}

- (void)setHomeModel:(HomeModel *)homeModel
{
    if (_homeModel != homeModel) {
        _homeModel = homeModel;
        
        [self configView];
        
    }
}

- (void)configView
{
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_homeModel.cover_image_url]];
    _nameTextView.text = _homeModel.name;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[_homeModel.price floatValue]];
//    _priceLabel.text = _homeModel.price;
//    _goodLabel.text = _homeModel.favorites_count;
//    NSString *text = _homeModel.favorites_count;
    _goodLabel.text = [NSString stringWithFormat:@"%ld",[_homeModel.favorites_count longValue]];
}

@end
