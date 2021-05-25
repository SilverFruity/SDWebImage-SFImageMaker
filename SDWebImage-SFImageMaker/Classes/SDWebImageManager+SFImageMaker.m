//
//  SDWebImageManager+SFImageMaker.m
//  SDWebImage-SFImageMaker
//
//  Created by Jiang on 2020/3/15.
//

#import "SDWebImageManager+SFImageMaker.h"


@implementation SDWebImageManager (SFImageMaker)
- (SDWebImageCombinedOperation *)sf_loadImageWithURL:(NSURL *)url
                                          options:(SDWebImageOptions)options
                                          context:(SDWebImageContext *)context
                                             flow:(SFImageFlow *)flow
                                      flowOptions:(SFWebImageCacheSaveOption)flowOptions
                                         progress:(SDImageLoaderProgressBlock)progressBlock
                                        completed:(SDInternalCompletionBlock)completedBlock{
    SFWebImageMakerHelper *helper = [[SFWebImageMakerHelper alloc] initWithUrl:url flow:flow];
    helper.saveOption = flowOptions;
    helper.delegate = self;
    UIImage *memImage = [helper memeryImage];
    if (memImage) {
        NSData *data = memImage.sd_imageData;
        dispatch_async(dispatch_get_main_queue(), ^{
            progressBlock(data.length, data.length, url);
            completedBlock(memImage, data, nil, SDImageCacheTypeMemory, YES, url);
        });
        return nil;
    }
    UIImage *diskImage = [helper diskImage];
    if (diskImage) {
        NSData *data = diskImage.sd_imageData;
        dispatch_async(dispatch_get_main_queue(), ^{
            progressBlock(data.length, data.length, url);
            completedBlock(diskImage, data, nil, SDImageCacheTypeDisk, YES, url);
        });
        return nil;
    }
    return [self loadImageWithURL:url options:options context:context progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (image && error == nil) {
            image = [helper prcoessWithDownloadImage:image];
            data = image.sd_imageData;
        }
        completedBlock(image,data,error,cacheType,finished,imageURL);
    }];
}
- (nullable SDWebImageCombinedOperation *)sf_loadImageWithURL:(nullable NSURL *)url
                                                      options:(SDWebImageOptions)options
                                                         flow:(SFImageFlow *)flow
                                                  flowOptions:(SFWebImageCacheSaveOption)flowOptions
                                                     progress:(nullable SDImageLoaderProgressBlock)progressBlock
                                                    completed:(nonnull SDInternalCompletionBlock)completedBlock{
    return [self sf_loadImageWithURL:url options:options context:nil flow:flow flowOptions:flowOptions progress:progressBlock completed:completedBlock];
}
- (UIImage *)diskCacheForKey:(NSString *)key{
    return [SDImageCache.sharedImageCache imageFromDiskCacheForKey:key];
}
- (nonnull NSString *)keyForUrl:(nonnull NSURL *)url identifier:(nullable NSString *)identifier {
    return [NSString stringWithFormat:@"%@__%@",url.absoluteString,identifier];
}

- (nullable UIImage *)memeryCacheForKey:(nonnull NSString *)key {
    return [SDImageCache.sharedImageCache imageFromMemoryCacheForKey:key];
}

- (void)saveDiskCache:(nonnull UIImage *)image forKey:(nonnull NSString *)key completed:(nullable void (^)(NSError * _Nullable))completed {
    // Check image's associated image format, may return .undefined
    SDImageFormat format = image.sd_imageFormat;
    if (format == SDImageFormatUndefined) {
        if ([SDImageCoderHelper CGImageContainsAlpha:image.CGImage]) {
            format = SDImageFormatPNG;
        } else {
            format = SDImageFormatJPEG;
        }
    }
    NSData *data = [[SDImageCodersManager sharedManager] encodedDataWithImage:image format:format options:nil];
    [SDImageCache.sharedImageCache storeImageDataToDisk:data forKey:key];
    
}

- (void)saveMemeryCache:(nonnull UIImage *)image forKey:(nonnull NSString *)key {
    [SDImageCache.sharedImageCache storeImageToMemory:image forKey:key];
}

@end
