//
//  MZDynamicDetailViewController.h
//  MZTuShenMa
//
//  Created by zuo on 15/8/25.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZBaseViewController.h"

// 用于标识是否需要是公关相册
typedef NS_ENUM(NSUInteger,DynamicDetailViewControllerType) {
    DynamicDetailViewControllerTypePublicAlbum,//公共相册动态详情
    DynamicDetailViewControllerTypeNormal//普通相册动态详情
};

@interface MZDynamicDetailViewController : MZBaseViewController

@property (nonatomic, assign) DynamicDetailViewControllerType albumType;

/**
 *  相册ID
 */
@property (nonatomic, copy) NSString *album_id;
/**
 *  相册名
 */
@property (nonatomic, copy) NSString *album_name;
///**
// *  照片id
// */
//@property (nonatomic, copy) NSString *photo_id;
/**
 *  发布id
 */
@property (nonatomic, copy) NSString *issue_id;



@property(nonatomic,retain) NSString *type;
//@property(nonatomic,retain) NSString *touserid;
@property (nonatomic, strong) NSString *tonick;

/**
 *  这条评论的id
 */
@property (nonatomic,strong) NSString *comment_id;
/**
 *  这条评论的群聊id
 */
@property (nonatomic,strong) NSString *group_id;
/**
*  这条评论的用户id
*/
@property (nonatomic,strong) NSString *comment_user_id;



@end
