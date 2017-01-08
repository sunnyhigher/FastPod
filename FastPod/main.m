//
//  main.m
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FastPod.h"
#import "SpecLoader.h"
#import "PodfileParser.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSArray *specs = [PodfileParser startParsing];
        [SpecLoader loadSpecs:specs];
        [FastPod podUpdate];
    }
    return 0;
}
