//
//  main.m
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpecEntity.h"
#import "SpecLoader.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        SpecEntity *item = [SpecEntity new];
        item.name = @"AFNetworking";
        [SpecLoader loadSpecs:@[item]];
    }
    return 0;
}
