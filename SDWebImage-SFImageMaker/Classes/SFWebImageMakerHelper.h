//
//  SFWebImageProcessor.h
//  SFImageMaker
//
//  Created by Jiang on 2020/3/13.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFImageMaker-Protocol.h"
/**
 *  input: Url + processors
 *  search in WebImageFramework Cache with url + identifier
 *  success:
 *      processors process and call completeHandler
 *      return
 *  error: next
 *  search in WebImageFramework Cache with url
 *  success:
 *      processors process and call completeHandler
 *      save in WebImageFramework Cache with url + identifier
 *      return
 *  error: next
 *  use WebImageFramewor Download
 *  success:
 *      processors process and call completeHandler
 *      save in WebImageFramework Cache with url
 *      save in WebImageFramework Cache with url + identifier
 *      return
 *  error: complete with error
 **/
typedef void(^SFWebImageCompleteHandler)(UIImage * _Nullable image,NSURL * _Nullable url,NSError * _Nullable error);
/// 处理后的图片的缓存方式
typedef NS_OPTIONS(NSUInteger, SFWebImageCacheSaveOption){
    /// 不缓存
    SFWebImageCacheSaveOptionNone   = 0,
    /// 仅缓存到内存
    SFWebImageCacheSaveOptionResultMemery = 1 << 2,
    /// 仅缓存到磁盘
    SFWebImageCacheSaveOptionResultDisk = 1 << 3,
    /// 全缓存
    SFWebImageCacheSaveOptionAll    = ~0UL
};
NS_ASSUME_NONNULL_BEGIN
@protocol SFWebImageManagerDelegate <NSObject>
@required

- (NSString *)keyForUrl:(NSURL *)url identifier:(nullable NSString *)identifier;

- (nullable UIImage *)memeryCacheForKey:(NSString *)key;
- (void)saveMemeryCache:(UIImage *)image forKey:(NSString *)key;

- (nullable UIImage *)diskCacheForKey:(NSString *)key;
- (void)saveDiskCache:(UIImage *)image forKey:(NSString *)key completed:(nullable void(^)(NSError *_Nullable error))completed;

@end
@class SFImageFlow;
@interface SFWebImageMakerHelper : NSObject
@property (nonatomic, weak)id <SFWebImageManagerDelegate>delegate;
@property (nonatomic, assign)SFWebImageCacheSaveOption saveOption;
@property (nonatomic, readonly)NSString *identifier;
@property (nonatomic, readonly, strong)NSURL *url;
- (instancetype)initWithUrl:(NSURL *)url flow:(SFImageFlow *)flow;
- (UIImage *)prcoessWithDownloadImage:(UIImage *)downloadImage;
- (UIImage *)diskImage;
- (UIImage *)memeryImage;
@end

NS_ASSUME_NONNULL_END
