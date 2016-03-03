//
//  MZCommonPhotoAlbumCollectionViewCell.m
//  MZTuShenMa
//
//  Created by zuo on 16/1/11.
//  Copyright © 2016年 killer. All rights reserved.
//

#import "MZCommonPhotoAlbumCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "MZListsModel.h"
@interface MZCommonPhotoAlbumCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIView *photoNumberView;
@property (weak, nonatomic) IBOutlet UIButton *photoNumberButton;
@property (weak, nonatomic) IBOutlet UIView *goodNumberView;
@property (weak, nonatomic) IBOutlet UIButton *goodNumberButton;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *describeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;


@end


@implementation MZCommonPhotoAlbumCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    _photoNumberView.layer.cornerRadius = 10;
    _photoNumberView.layer.masksToBounds = YES;
    
    _goodNumberView.layer.cornerRadius = 10;
    _goodNumberView.layer.masksToBounds = YES;
    
    _headImage.layer.cornerRadius = CGRectGetHeight([_headImage bounds])/2;
    _headImage.layer.masksToBounds = YES;
    
    _playButton.hidden = YES;
    
//    _segmentView.backgroundColor =  [self mostColor];
    
//     _backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    
}

- (void)setModel:(MZDynamicListModel *)model
{
    _model = model;
    if (_model.lists.count>0) {
        MZListsModel *listsModel = [_model.lists objectAtIndex:0];
        [_backgroundImage sd_setImageWithURL:[NSURL URLWithString:listsModel.path_img] placeholderImage:[UIImage imageNamed:@"main_dynamicPlaceholder"]];
        if ([listsModel.type isEqualToString:@"3"]) {
            _playButton.hidden = NO;
        }else{
            _playButton.hidden = YES;
        }
        
//        [listsModel.rbg isKindOfClass:[NSNull class]?nil:listsModel.rbg];
        
        if ([listsModel.rbg isKindOfClass:[NSNull class]] || [listsModel.rbg isEqualToString:@""]) {
            
        }else{
            NSString *redString = [listsModel.rbg  substringToIndex:2];
            NSString *greenString = [listsModel.rbg substringWithRange:NSMakeRange(3, 2)];
            NSString *blueString = [listsModel.rbg substringFromIndex:6];
            _segmentView.backgroundColor = RGB([redString integerValue], [greenString integerValue], [blueString integerValue]);
        }
        
    }
    [_photoNumberButton setTitle:[NSString stringWithFormat:@"  %ld",_model.lists.count] forState:UIControlStateNormal];
    [_goodNumberButton setTitle:[NSString stringWithFormat:@"  %ld",_model.goods] forState:UIControlStateNormal];
    [_headImage sd_setImageWithURL:[NSURL URLWithString:_model.user_img] placeholderImage:[UIImage imageNamed:@"main_dynamicPlaceholder"]];
    _describeLabel.text = _model.uname;
}


+(CGSize)getItemSize:(MZDynamicListModel *)model
{
    if (model.lists.count > 0) {
        MZListsModel *listsModel = [model.lists objectAtIndex:0];
        CGFloat width = SCREEN_WIDTH/2;
        CGFloat height = width*[listsModel.height floatValue]/[listsModel.width floatValue];
        NSLog(@"height == %f",height);
        return CGSizeMake(width, height);
    }else{
        return CGSizeMake(SCREEN_WIDTH/2,SCREEN_WIDTH/2 +20);
    }
   
}





//-(UIColor*)mostColor{
//    
//    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
//    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
//#else
//    int bitmapInfo = kCGImageAlphaPremultipliedLast;
//#endif
//    
//    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
//    CGSize thumbSize=CGSizeMake(50, 50);
//    
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGContextRef context = CGBitmapContextCreate(NULL,
//                                                 thumbSize.width,
//                                                 thumbSize.height,
//                                                 8,//bits per component
//                                                 thumbSize.width*4,
//                                                 colorSpace,
//                                                 bitmapInfo);
//    
//    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
//    CGContextDrawImage(context, drawRect, self.backgroundImage.image.CGImage);
//    CGColorSpaceRelease(colorSpace);
//    
//    
//    
//    //第二步 取每个点的像素值
//    unsigned char* data = CGBitmapContextGetData (context);
//    
//    if (data == NULL) return nil;
//    
//    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
//    
//    for (int x=0; x<thumbSize.width; x++) {
//        for (int y=0; y<thumbSize.height; y++) {
//            
//            int offset = 4*(x*y);
//            
//            int red = data[offset];
//            int green = data[offset+1];
//            int blue = data[offset+2];
//            int alpha =  data[offset+3];
//            
//            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
//            [cls addObject:clr];
//            
//        }
//    }
//    CGContextRelease(context);
//    
//    
//    //第三步 找到出现次数最多的那个颜色
//    NSEnumerator *enumerator = [cls objectEnumerator];
//    NSArray *curColor = nil;
//    
//    NSArray *MaxColor=nil;
//    NSUInteger MaxCount=0;
//    
//    while ( (curColor = [enumerator nextObject]) != nil )
//    {
//        NSUInteger tmpCount = [cls countForObject:curColor];
//        
//        if ( tmpCount < MaxCount ) continue;
//        
//        MaxCount=tmpCount;
//        MaxColor=curColor;
//        
//    }
//    
//    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
//}


@end
