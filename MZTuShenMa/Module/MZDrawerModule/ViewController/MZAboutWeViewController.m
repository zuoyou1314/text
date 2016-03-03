//
//  MZAboutWeViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/9/16.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZAboutWeViewController.h"

@interface MZAboutWeViewController ()

@end

@implementation MZAboutWeViewController
- (instancetype)init
{
    if (self = [super init])
    {
        NSString *name;
        if (iPhone6P) {
            name = @"MZAboutWeViewController(6Plus)";
        }else if (iPhone6){
            name = @"MZAboutWeViewController(6)";
        }else{
            name = @"MZAboutWeViewController";
        }
        self.view = [[[NSBundle mainBundle] loadNibNamed:name owner:self options:nil] lastObject];
        [self setUIDef];
        [self setLeftBarButton];
    }
    return self;
}

- (void) setUIDef
{
    self.title = @"关于我们";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
