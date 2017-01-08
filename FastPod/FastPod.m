//
//  FastPod.m
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import "FastPod.h"

@implementation FastPod

+ (NSString *)apiBase {
    return @"http://localhost/app/";
}

+ (NSString *)specBase {
    NSString *appBase = [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory,
                                                             NSUserDomainMask,
                                                             YES) firstObject];
    return [appBase stringByReplacingOccurrencesOfString:@"/Applications"
                                              withString:@"/.cocoapods/repos/master/Specs/"];
}

@end
