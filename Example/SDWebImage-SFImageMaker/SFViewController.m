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
    NSURL *url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1584298042188&di=3e45e9a224d77e74ddef8693db1e8c84&imgtype=0&src=http%3A%2F%2Fa4.att.hudong.com%2F21%2F09%2F01200000026352136359091694357.jpg"];
    SFShadowImageMaker *shadow = [[SFShadowImageMaker alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowBlurRadius = 40;
    shadow.position = UIShadowPostionAll;
    shadow.shadowOffset = CGSizeZero;
    
    self.helper = [[SFWebImageMakerHelper alloc] initWithUrl:url processors:@[[SFBlockImageMaker resizeWithMaxValue:200],[SFBlockImageMaker circle],shadow]];
    self.helper.delegate = [SDWebImageManager sharedManager];
    self.helper.saveOption = SFWebImageCacheSaveOptionAll;
    [self.helper prcoessWithCompleted:^(UIImage * _Nullable image, NSURL * _Nullable url, NSError * _Nullable error) {
        self.imageView.image = image;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
