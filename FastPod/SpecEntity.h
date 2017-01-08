//
//  SpecEntity.h
//  FastPod
//
//  Created by 崔 明辉 on 2017/1/8.
//  Copyright © 2017年 Pony Cui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecEntity : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *compareType;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *domainOnGitHub;
@property (nonatomic, copy) NSString *nameOnGitHub;
@property (nonatomic, copy) NSString *tagOnGitHub;

@end
