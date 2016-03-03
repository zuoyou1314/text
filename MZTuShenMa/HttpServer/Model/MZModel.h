//
//  MZModel.h
//  MZTuShenMa
//
//  Created by zuo on 15/9/1.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZModel : NSObject

@property (nonatomic, assign) NSInteger errCode;

@property (nonatomic, copy) NSString *errMsg;

@property (nonatomic, strong) NSArray *responseData;
/**
 *  照片列表
 */
@property (nonatomic, strong) NSArray *photoLists;
///**
// *  个人中心
// */
//@property (nonatomic, strong) NSArray *issueLists;

/**
 *
 */
@property (nonatomic, strong) NSArray *issueList;

@property (nonatomic, copy) NSString *goodID;
/**
 * 相册主表示   0.非相册主  1.相册主
 */
@property (nonatomic,assign) NSInteger bos;
/**
 * 相册成员
 */
@property (nonatomic,strong) NSArray *albumMembers;
/**
 * 相册信息详情
 */
@property (nonatomic,strong) NSArray *userAlbumDetails;


/**
 * 照片详情
 */
@property (nonatomic,strong) NSDictionary *issueDetail;
/**
 *  点赞列表
 */
@property (nonatomic,strong) NSArray *goodLists;
/**
 *  评论列表
 */
@property (nonatomic,strong) NSArray *commentLists;
/**
 * 是否有删除权力  0.没有  1.有
 */
@property (nonatomic,assign) NSInteger is_bos;
/**
 * 用户是否点过赞  0，没有  1.
 */
@property (nonatomic,assign) NSInteger is_good;
/**
 * 点赞数
 */
@property (nonatomic,assign) NSInteger goodNum;
/**
 * 评论数
 */
@property (nonatomic,assign) NSInteger commentNums;


/**
 *  新消息条数
 */
@property (nonatomic,assign) NSInteger totleNums;


/**
 *  消息列表
 */
@property (nonatomic,strong) NSArray *newlistss;

/**
 *  图像
 */
@property (nonatomic,copy) NSString *user_img;


/**
 *  用户反馈
 */
@property (nonatomic,assign) NSInteger upNum;


/**
 *  评论id
 */
@property (nonatomic,assign) NSInteger commentId;

/**
 *  回复id，也就是评论id
 */
@property (nonatomic,assign) NSInteger replyId;
/**
 *  此表示用来判断用户是否有权力删除这个成员
 */
//@property (nonatomic,assign) NSInteger idDelMem;

//是否有相册  1有  0无
@property (nonatomic, copy) NSString * is_album;


//发布id
@property (nonatomic, copy) NSString * issue_id;
//照片标识
@property (nonatomic, copy) NSString * photo_num;
@property (nonatomic, copy) NSString * photo_id;



//////////////////////////群聊////////////////////////////////////////////////////////
/**
 *  群聊列表
 */
@property (nonatomic, strong) NSArray *groupChatLists;
//////////////////////////分享////////////////////////////////////////////////////////
@property (nonatomic, copy) NSString *url;
//////////////////////////广告位////////////////////////////////////////////////////////

@property (nonatomic, strong) NSArray *data;


@end
