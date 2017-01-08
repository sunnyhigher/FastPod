//
//  SpecLoader.m
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import "SpecLoader.h"
#import "FastPod.h"

@implementation SpecLoader

+ (void)loadSpecs:(NSArray<NSString *> *)specs {
    NSMutableArray *coms = [NSMutableArray array];
    for (SpecEntity *spec in specs) {
        if ([spec compareType] != nil && [spec version] != nil) {
            [coms addObject:[NSString stringWithFormat:@"%@|%@|%@",
                             spec.name,
                             spec.compareType,
                             spec.version]];
        }
        else {
            [coms addObject:spec.name];
        }
    }
    NSString *targets = [coms componentsJoinedByString:@","];
    NSString *loadType = @"1";
    NSURL *URL = [NSURL URLWithString:
                  [NSString stringWithFormat:@"%@/spec.php?targets=%@&loadType=%@",
                   [FastPod apiBase], targets, loadType]];
    if (URL != nil) {
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL]
                                             returningResponse:nil
                                                         error:nil];
        if (data != nil) {
            NSDictionary *specs = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:nil];
            if ([specs isKindOfClass:[NSDictionary class]]) {
                [specs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    NSString *name = key;
                    [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                        NSString *version = key;
                        NSString *contents = obj;
                        NSString *dir = [NSString stringWithFormat:@"%@/%@/%@",
                                         [FastPod specBase],
                                         name,
                                         version];
                        [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                                  withIntermediateDirectories:YES
                                                                   attributes:nil
                                                                        error:nil];
                        NSData *contentData = [[NSData alloc] initWithBase64EncodedString:contents
                                                                                  options:kNilOptions];
                        [contentData writeToFile:[NSString stringWithFormat:@"%@/%@.podspec.json", dir, name]
                                   atomically:YES];
                    }];
                }];
            }
        }
    }
}

@end
