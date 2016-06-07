//
//  ClassifyModel.h
//  爱购街
//
//  Created by Jhwilliam on 16/2/17.
//  Copyright © 2016年 01. All rights reserved.
//

#import "BaseModel.h"

@interface ClassifyModel : BaseModel

@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *cover_image_url;
@property(nonatomic,copy)NSString *target_id;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *target_url;
@property(nonatomic,copy)NSString *descriptions;
@property(nonatomic,strong)NSMutableArray *image_urls;
@property(nonatomic,retain)NSNumber *favorites_count;
//@property(nonatomic,copy)NSString *favorites_count;
@property(nonatomic,retain)NSNumber *price;
//@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *purchase_url;
@property(nonatomic,retain)NSNumber *likes_count;
@property(nonatomic,strong)NSMutableArray *channels;
@property(nonatomic,copy)NSString *icon_url;
@property(nonatomic,strong)NSMutableArray *subcategories;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,strong)NSMutableArray *hot_words;
@end
