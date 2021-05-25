//
//  SFWebImageProcessor.m
//  SFImageMaker
//
//  Created by Jiang on 2020/3/13.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import "SFWebImageMakerHelper.h"
#import <SFImageMaker/SFImageMaker.h>
@interface SFWebImageMakerHelper()
@property (nonatomic, strong)SFImageFlow *flow;
@property (nonatomic, readwrite, strong)NSURL *url;
@property (nonatomic, copy)NSString *identifier;
@end
@implementation SFWebImageMakerHelper
- (instancetype)initWithUrl:(NSURL *)url flow:(SFImageFlow *)flow{
    self = [super init];
    self.url = url;
    self.flow = flow;
    self.identifier = self.flow.identifier;
    return self;
}
- (NSString *)identifier{
    return self.flow.identifier;
}
- (UIImage *)prcoessWithDownloadImage:(UIImage *)downloadImage{
    self.flow.targetImage = downloadImage;
    UIImage *resultImage = [self.flow image];
    // save with identifier
    NSString *key = [self.delegate keyForUrl:self.url identifier:self.identifier];
    if (self.saveOption & SFWebImageCacheSaveOptionResultMemery) {
        [self.delegate saveMemeryCache:resultImage forKey:key];
    }
    if (self.saveOption & SFWebImageCacheSaveOptionResultDisk) {
        [self.delegate saveDiskCache:resultImage forKey:key completed:nil];
    }
    return resultImage;
}

- (UIImage *)diskImage{
    // search in DiskCache with identifier
    NSString *key = [self.delegate keyForUrl:self.url identifier:self.identifier];
    UIImage *image = [self.delegate diskCacheForKey:key];
    if (image) {
        if (self.saveOption & SFWebImageCacheSaveOptionResultMemery) {
            [self.delegate saveMemeryCache:image forKey:key];
        }
        return image;
    }
    NSString *noIdentifierKey = [self.delegate keyForUrl:self.url identifier:nil];
    image = [self.delegate diskCacheForKey:noIdentifierKey];
    if (image) {
        self.flow.targetImage = image;
        UIImage *resultImage = [self.flow image];
        if (self.saveOption & SFWebImageCacheSaveOptionResultDisk) {
            [self.delegate saveDiskCache:resultImage forKey:key completed:nil];
        }
        if (self.saveOption & SFWebImageCacheSaveOptionResultMemery) {
            [self.delegate saveMemeryCache:resultImage forKey:key];
        }
        return image;
    }
    return nil;    
}
- (UIImage *)memeryImage{
    // search in MemCache with identifier
    NSString *key = [self.delegate keyForUrl:self.url identifier:self.identifier];
    UIImage *image = [self.delegate memeryCacheForKey:key];
    if (image) {
        return image;
    }
    // search in MemCache without identifer
    NSString *noIdentifierKey = [self.delegate keyForUrl:self.url identifier:nil];
    image = [self.delegate memeryCacheForKey:noIdentifierKey];
    if (image) {
        self.flow.targetImage = image;
        UIImage *resultImage = [self.flow image];
        if (self.saveOption & SFWebImageCacheSaveOptionResultMemery) {
            [self.delegate saveMemeryCache:resultImage forKey:key];
        }
        return resultImage;
    }
    return nil;
}
@end
