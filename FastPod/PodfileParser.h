//
//  PodfileParser.h
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecEntity.h"

@interface PodfileParser : NSObject

+ (NSArray<SpecEntity *> *)startParsing;

@end
