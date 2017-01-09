//
//  SpecLoader.m
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "SpecLoader.h"
#import "FastPod.h"

@implementation NSString (MD5)

- (NSString *) MD5Hash {
    CC_MD5_CTX md5;
    CC_MD5_Init (&md5);
    CC_MD5_Update (&md5, [self UTF8String], (CC_LONG) [self length]);
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final (digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0],  digest[1],
                   digest[2],  digest[3],
                   digest[4],  digest[5],
                   digest[6],  digest[7],
                   digest[8],  digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

@end

@implementation SpecLoader

+ (void)loadSpecs:(NSArray<NSString *> *)specs {
    NSMutableArray *coms = [NSMutableArray array];
    for (SpecEntity *spec in specs) {
        if ([spec compareType] != nil && [spec version] != nil) {
            [coms addObject:[NSString stringWithFormat:@"%@_%@_%@",
                             [spec.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                             [spec.compareType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                             [spec.version stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
        else {
            [coms addObject:spec.name];
        }
    }
    NSString *targets = [coms componentsJoinedByString:@","];
    NSString *loadType = [FastPod loadType];
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
                        NSData *contentData = [[NSData alloc] initWithBase64EncodedString:contents
                                                                                  options:kNilOptions];
                        {
                            // old version CocoaPods
                            NSString *dir = [NSString stringWithFormat:@"%@/%@/%@",
                                             [FastPod specBase],
                                             name,
                                             version];
                            [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                                      withIntermediateDirectories:YES
                                                                       attributes:nil
                                                                            error:nil];
                            [contentData writeToFile:[NSString stringWithFormat:@"%@/%@.podspec.json", dir, name]
                                          atomically:YES];
                        }
                        {
                            // new version CocoaPods
                            NSString *md5 = [[name MD5Hash] lowercaseString];
                            NSString *dir = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",
                                             [FastPod specBase],
                                             [md5 substringWithRange:NSMakeRange(0, 1)],
                                             [md5 substringWithRange:NSMakeRange(1, 1)],
                                             [md5 substringWithRange:NSMakeRange(2, 1)],
                                             name,
                                             version];
                            [[NSFileManager defaultManager] createDirectoryAtPath:dir
                                                      withIntermediateDirectories:YES
                                                                       attributes:nil
                                                                            error:nil];
                            [contentData writeToFile:[NSString stringWithFormat:@"%@/%@.podspec.json", dir, name]
                                          atomically:YES];
                        }
                        if ([[FastPod loadType] isEqualToString:@"2"]) {
                            NSDictionary *specObj = [NSJSONSerialization JSONObjectWithData:contentData
                                                                                    options:kNilOptions
                                                                                      error:nil];
                            if ([specObj isKindOfClass:[NSDictionary class]]) {
                                if ([specObj[@"source"] isKindOfClass:[NSDictionary class]]) {
                                    if ([specObj[@"source"][@"http"] isKindOfClass:[NSString class]]) {
                                        [SpecLoader prepareZIP:specObj[@"source"][@"http"]];
                                    }
                                }
                            }
                        }
                    }];
                }];
            }
        }
    }
}

+ (void)prepareZIP:(NSString *)zipPath {
    NSString *fn = [zipPath lastPathComponent];
    fn = [fn stringByReplacingOccurrencesOfString:@".zip" withString:@""];
    NSArray *coms = [fn componentsSeparatedByString:@"-"];
    if ([coms count] < 3) {
        return;
    }
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/zip.php?domain=%@&name=%@&tag=%@",
                                       [FastPod apiBase], coms[0], coms[1], coms[2]]];
    NSLog(@"\nPreparing %@/%@", coms[0], coms[1]);
    if (URL != nil) {
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        if ([[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] isEqualToString:@"1"]) {
        }
        else {
            NSLog(@"Prepare %@ zip failed.", coms[1]);
            abort();
        }
    }
}

@end
