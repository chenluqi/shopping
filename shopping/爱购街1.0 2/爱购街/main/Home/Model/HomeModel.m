//
//  HomeModel.m
//  买买买
//
//  Created by Jhwilliam on 16/2/1.
//  Copyright © 2016年 hxc. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

- (NSDictionary *)attributeMapDictionary:(NSDictionary *)jsonDic
{
    NSDictionary *mapDic = @{
                             @"image_url" : @"image_url",
                             @"cover_image_url" : @"cover_image_url",
                             @"target_id" : @"target_id",
                             @"id" : @"id",
                             @"name" : @"name",
                             @"type" : @"type",
                             @"title" : @"title",
                             @"url" : @"url",
                             @"target_url" : @"target_url",
                             @"description" : @"descriptions",
                             @"image_urls" : @"image_urls",
                             @"favorites_count" : @"favorites_count",
                             @"price" : @"price",
                             @"purchase_url" : @"purchase_url",
                             @"likes_count" : @"likes_count",
                             @"channels" : @"channels",
                             @"icon_url" : @"icon_url",
                             @"subcategories" : @"subcategories",
                             @"key" : @"key",
                             @"hot_words" : @"hot_words"
                             };
    
    return mapDic;
}

@end
