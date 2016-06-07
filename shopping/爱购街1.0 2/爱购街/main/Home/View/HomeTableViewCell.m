//
//  HomeTableViewCell.m
//  买买买
//
//  Created by huiwen on 16/2/1.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

{
    UIImageView *_imageView;
    UILabel *_label;
    UIView *_goodView;
    UIImageView *_goodImageView;
    UILabel *_goodLabel;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, kScreenWidth * 4 / 9 - 20)];
        _imageView.layer.cornerRadius = 15;
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.contentView addSubview:_imageView];
        
        UIView *garyView = [[UIView alloc] initWithFrame:_imageView.bounds];
        garyView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
//        [_imageView addSubview:garyView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.frame.size.height - 30, kScreenWidth - 20, 30)];
        _label.font = [UIFont boldSystemFontOfSize:17];
        _label.textColor = [UIColor whiteColor];
        _label.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.4];
        
        [_imageView addSubview:_label];
        
        _goodView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 20 - 50, 0, 40, 50)];
        _goodView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.5];
        
        [_imageView addSubview:_goodView];
        
        _goodImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        _goodImageView.image = [UIImage imageNamed:@"Feed_FavoriteIcon"];
        
        _goodLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 40, 15)];
        _goodLabel.textAlignment = NSTextAlignmentCenter;
        _goodLabel.textColor = [UIColor whiteColor];
        _goodLabel.font = [UIFont systemFontOfSize:9];
        
        [_goodView addSubview:_goodImageView];
        [_goodView addSubview:_goodLabel];
        
        
        
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
    if (_homeModel.cover_image_url) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_homeModel.cover_image_url]];
    }
    else if (_homeModel.image_url)
    {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:_homeModel.image_url]];
    }
    
    
    
    _label.text = [NSString stringWithFormat:@"  %@",_homeModel.title];
    
    _goodLabel.text = [NSString stringWithFormat:@"%ld",[_homeModel.likes_count longValue]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
