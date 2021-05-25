//
//  SFViewController.m
//  SDWebImage-SFImageMaker
//
//  Created by 389185764@qq.com on 03/13/2020.
//  Copyright (c) 2020 389185764@qq.com. All rights reserved.
//

#import "SFViewController.h"
#import <SDWebImage/SDWebImage.h>
#import <SFImageMaker/SFImageMaker.h>
#import <SDWebImageManager+SFImageMaker.h>
@interface SFViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)SFWebImageMakerHelper *helper;
@end

@implementation SFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic4.zhimg.com%2F50%2Fv2-fde5891065510ef51e4c8dc19f6f3aff_hd.jpg&refer=http%3A%2F%2Fpic4.zhimg.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1624521350&t=8427bf918dda45516b3dbc7f4f527681"];
    SFImageFlow *flow = SFImageFlow.flow.resizeWithMax(200).circle.shadow(UIColor.blackColor, CGSizeZero, 40);
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SDWebImageManager sharedManager] sf_loadImageWithURL:url options:0 flow:flow flowOptions:SFWebImageCacheSaveOptionAll progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            self.imageView.image = image;
            NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
            NSLog(@"time1: %f", end - start);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSTimeInterval start = [[NSDate date] timeIntervalSince1970];
            [[SDWebImageManager sharedManager] sf_loadImageWithURL:url options:0 flow:flow flowOptions:SFWebImageCacheSaveOptionAll progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                self.imageView.image = image;
                NSTimeInterval end = [[NSDate date] timeIntervalSince1970];
                NSLog(@"time2: %f", end - start);
            }];
        });
    });
    [[SDWebImageManager sharedManager].imageCache clearWithCacheType:SDImageCacheTypeAll completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
