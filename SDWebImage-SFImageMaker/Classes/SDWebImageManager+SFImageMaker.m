//
//  SDWebImageManager+SFImageMaker.m
//  SDWebImage-SFImageMaker
//
//  Created by Jiang on 2020/3/15.
//

#import "SDWebImageManager+SFImageMaker.h"


@implementation SDWebImageManager (SFImageMaker)

- (void)diskCacheForKey:(nonnull NSString *)key completed:(nullable void (^)(UIImage * _Nullable, NSError * _Nullable))completed {
    if (![SDImageCache.sharedImageCache diskImageDataExistsWithKey:key]) {
        completed(nil,[NSError errorWithDomain:@"SFWebImageMakerHelper" code:3 userInfo:@{NSLocalizedDescriptionKey:@"disk image cache is not exited"}]);
    }
    UIImage *image = [SDImageCache.sharedImageCache imageFromDiskCacheForKey:key];
    completed(image,nil);
}

- (void)downloadForUrl:(nonnull NSURL *)url completed:(nonnull SFWebImageCompleteHandler)completed {
    [SDWebImageManager.sharedManager loadImageWithURL:url options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        completed(image,imageURL,error);
    }];
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
