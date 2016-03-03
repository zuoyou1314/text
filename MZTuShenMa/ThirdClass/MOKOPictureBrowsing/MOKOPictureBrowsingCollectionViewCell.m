//
//  MOKOPictureBrowsingCollectionViewCell.m
//  MOKODreamWork_iOS2
//
//  Created by _SS on 15/7/23.
//  Copyright (c) 2015年 moko. All rights reserved.
//

#import "MOKOPictureBrowsingCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#define IMAGE(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]
@interface MOKOPictureBrowsingCollectionViewCell ()<UIScrollViewDelegate>

/**
 *  承载imageView
 */
@property (nonatomic, strong) UIScrollView *imageContentView;
/**
 *  图片原始宽度
 */
@property (nonatomic, assign) CGFloat imageWidth;
/**
 *  图片原始高度
 */
@property (nonatomic, assign) CGFloat imageHeight;

@end

@implementation MOKOPictureBrowsingCollectionViewCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
        [self pictureBrowsingCollectionViewCellEventResponse];
        
    }
    return self;
}

- (void)createSubView{
    [self addSubview:self.imageContentView];
    [self.imageContentView addSubview:self.imageView];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageContentView.frame = CGRectMake(0.f, 0.f, SCREEN_WIDTH , SCREEN_HEIGHT);
    if (self.imageHeight>0 && self.imageWidth >0 ) {
        self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.imageHeight* SCREEN_WIDTH / self.imageWidth);
    }
    self.imageView.center = _imageContentView.center;
}



//找任意view所在控制器的方法
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark -- Event Response
- (void)pictureBrowsingCollectionViewCellEventResponse{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressImageShowctionSheet:)];
    [self.imageView addGestureRecognizer:longPress];

}
- (void)longPressImageShowctionSheet:(UILongPressGestureRecognizer *)longPress{
    if (self.longPressImageBlock == nil) {
        return;
    }
    if (longPress.state == UIGestureRecognizerStateEnded) {
        _longPressImageBlock();
        
    }
}

#pragma mark -- Getter and Setter

- (UIImageView *)imageView{
    if (_imageView != nil) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.userInteractionEnabled = YES;
    return _imageView;
}

- (UIScrollView *)imageContentView{
    if (_imageContentView != nil) {
        return _imageContentView;
    }
    _imageContentView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _imageContentView.backgroundColor = [UIColor blackColor];
    
    _imageContentView.delegate = self;
    _imageContentView.bouncesZoom = YES;
    _imageContentView.pagingEnabled = YES;
    
    _imageContentView.minimumZoomScale = 0.5;
    _imageContentView.maximumZoomScale = 2.0;
    
    _imageContentView.showsHorizontalScrollIndicator = NO;
    _imageContentView.showsVerticalScrollIndicator = NO;

    return _imageContentView;

}

- (void)setImageurl:(NSString *)imageurl{
    _imageurl = imageurl;
    
    __weak typeof(self) weakSelf = self;
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        weakSelf.imageWidth = image.size.width;
        weakSelf.imageHeight = image.size.height;
    }];

    [self.imageContentView removeFromSuperview];
    [self.imageView removeFromSuperview];
    [self addSubview:self.imageContentView];
    [self.imageContentView addSubview:self.imageView];
//    _imageView.image = IMAGE(imageurl);
    NSLog(@"imageurl == %@",imageurl);
     [_imageView sd_setImageWithURL:[NSURL URLWithString:imageurl] placeholderImage:[UIImage imageNamed:@"main_dynamicPlaceholder"]];
}

- (void)setImage:(UIImage *)image
{
    self.imageWidth = image.size.width;
    self.imageHeight = image.size.height;
    
    [self.imageContentView removeFromSuperview];
    [self.imageView removeFromSuperview];
    [self addSubview:self.imageContentView];
    [self.imageContentView addSubview:self.imageView];
    
    _imageView.image = image;
}


#pragma mark - scrollviewDelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat x = scrollView.center.x,y = scrollView.center.y;
    x = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :x;
    y = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : y;
    _imageView.center = CGPointMake(x, y);

}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _imageView;
}
@end
