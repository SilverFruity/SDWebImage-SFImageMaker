//
//  SDWebImageManager+SFImageMaker.h
//  SDWebImage-SFImageMaker
//
//  Created by Jiang on 2020/3/15.
//

#import <SDWebImage/SDWebImage.h>
#import <SFWebImageMakerHelper.h>
NS_ASSUME_NONNULL_BEGIN

@interface SDWebImageManager (SFImageMaker) <SFWebImageManagerDelegate>
- (SDWebImageCombinedOperation *)sf_loadImageWithURL:(NSURL *)url
                                          options:(SDWebImageOptions)options
                                          context:(nullable SDWebImageContext *)context
                                             flow:(SFImageFlow *)flow
                                      flowOptions:(SFWebImageCacheSaveOption)flowOptions
                                         progress:(nullable SDImageLoaderProgressBlock)progressBlock
                                        completed:(nonnull SDInternalCompletionBlock)completedBlock;

- (nullable SDWebImageCombinedOperation *)sf_loadImageWithURL:(nullable NSURL *)url
                                                      options:(SDWebImageOptions)options
                                                         flow:(SFImageFlow *)flow
                                                  flowOptions:(SFWebImageCacheSaveOption)flowOptions
                                                     progress:(nullable SDImageLoaderProgressBlock)progressBlock
                                                    completed:(nonnull SDInternalCompletionBlock)completedBlock;
@end

NS_ASSUME_NONNULL_END
