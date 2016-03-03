//
//  MZCreateQRCodeViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/11/16.
//  Copyright © 2015年 killer. All rights reserved.
//

#import "MZCreateQRCodeViewController.h"
#import "UIImageView+WebCache.h"
@interface MZCreateQRCodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *createQRCodeImage;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;



@end

@implementation MZCreateQRCodeViewController
{
    UIImage *tmpImage;
}
- (instancetype)initWithAlbumId:(NSString *)albumId
{
    if (self = [super init])
    {
        self.view = [[[NSBundle mainBundle] loadNibNamed:@"MZCreateQRCodeViewController" owner:self options:nil] lastObject];
        [self setUIDef:albumId];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    return self;
}

- (void)setUIDef:(NSString *)albumId
{
    [self setLeftBarButton];
    self.title = @"相册二维码";
    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
    _saveButton.layer.cornerRadius = 25;
    _saveButton.layer.masksToBounds = YES;
    
    float width = _createQRCodeImage.frame.size.width;
    float height = _createQRCodeImage.frame.size.height;
    
    self.createQRCodeImage.image = [self generateQRCode:[NSString stringWithFormat:@"%@:%@/%@?album_id=%@",kHost,kPort,kAppAdd,albumId] width:width height:height];
    
    
 
    
}

- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    //绘制
    CIImage *qrImage = filter.outputImage;
    CGSize size = CGSizeMake(300, 300);
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage 	fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    //生成的QRCode就是上下颠倒的,需要翻转一下
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
//    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
//    CGFloat scaleY = height / qrcodeImage.extent.size.height;
//    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
//    tmpImage = [UIImage imageWithCIImage:transformedImage];
    return codeImage;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (IBAction)didClickSaveButtonAction:(id)sender {
    [self saveImage];
}



/**
 *  保存图片
 */
- (void)saveImage{
//    UIImage *image = [UIImage imageNamed:@"imageHolder"];
    UIImageWriteToSavedPhotosAlbum(self.createQRCodeImage.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
