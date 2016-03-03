//
//  MZRequestManger+User.h
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZRequestManger.h"
#import "MZHttpServer.h"
#import "MZLoginParam.h"
#import "MZPhoneValidateParam.h"
#import "MZRegisterPhoneParam.h"
#import "MZCreateAlbumParam.h"

#import "MZModel.h"
#import "MZMainParam.h"
#import "MZDynamicListParam.h"
#import "MZPhotoGoodParam.h"
#import "MZPhotoAlbumDetailsParam.h"
#import "MZPhotoDetailParam.h"
#import "MZNewlistsParam.h"
#import "MZNewIsHaveParam.h"
#import "MZUploadHeadImgParam.h"

#import "AFNetworking.h"
#import "MZFeedbackParam.h"
#import "MZAddCommentParam.h"
#import "MZReplyCommentParam.h"
#import "MZForgetPasswordParam.h"
#import "MZUserFillParam.h"
#import "MZDoUploadParam.h"
#import "MZResetAlbumImg.h"
#import "MZPhoneDelParam.h"
#import "MZUserEditParam.h"
#import "MZDeleteAlbumMemberParam.h"
#import "MZEditAlbumParam.h"
#import "MZAlbumUserPhotosParam.h"
#import "MZReportUserParam.h"
#import "MZGoodsCommentsParam.h"
#import "MZIsAlbumParam.h"
#import "MZPhotoIssueParam.h"

#import "MZGroupListParam.h"
#import "MZAddGroupParam.h"
#import "MZReplyGroupParam.h"
#import "MZShareParam.h"
#import "MZAdvertParam.h"
#import "MZDownLoadParam.h"
#import "MZQuitLoginParam.h"
#import "MZAppAddParam.h"
#import "MZUploadSpeechParam.h"
#import "UIAlertView+MKBlockAdditions.h"
@interface MZRequestManger (User)

/**
 *  登陆请求
 *
 *  @param param   登陆body体
 *  @param success 登陆成功
 *  @param failure 登陆失败
 *
 *  @return 
 */
+ (AFHTTPRequestOperation *)loginRequest:(MZLoginParam *)param
                                 success:(void (^)(NSDictionary *object))success
                                 failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//手机号验证
+ (AFHTTPRequestOperation *)phoneValidateRequest:(MZPhoneValidateParam *)param
                                         success:(void (^)(NSString *object))success
                                         failure:(void (^)(NSString *errMsg))failure;
//手机号注册
+ (AFHTTPRequestOperation *)RegisterPhoneRequestsuccess:(void (^)(NSDictionary *object))success                                              failure:(void (^)(NSString *errMsg))failure;

//填写用户资料
+ (AFHTTPRequestOperation *)UserFillRequest:(MZUserFillParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;


//重置密码
+ (AFHTTPRequestOperation *)forgetPasswordRequest:(MZForgetPasswordParam *)param   success:(void (^)(NSString *object,NSString *errMsg))success                                              failure:(void (^)(NSString *errMsg))failure;

///**
// *  用户头像上传
// *
// *  @param param   用户头像上传body体
// *  @param success 成功
// *  @param failure 失败
// *
// *  @return
// */
//- (AFHTTPRequestOperationManager *)uploadHeadimgRequest:(MZUploadHeadImgParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;


/**
 *  创建相册
 *
 *  @param param   创建相册body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)createAlbumRequest:(MZCreateAlbumParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
/**
 *  相册列表
 *
 *  @param param   相册列表的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return 
 */
+ (AFHTTPRequestOperation *)AlbumlistsRequest:(MZMainParam *)param success:(void (^)(NSArray *responseData,NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
/**
 *  照片列表
 *
 *  @param param   照片列表的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)photolistsRequest:(MZDynamicListParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
/**
 *  照片点赞
 *
 *  @param param  照片点赞的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)photoGoodRequest:(MZPhotoGoodParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
/**
 *  相册详情
 *
 *  @param param   相册详情的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)albumDetailsRequest:(MZPhotoAlbumDetailsParam *)param success:(void (^)(NSArray *albumMembers,NSArray *userAlbumDetails))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
/**
 *  相片详情
 *
 *  @param param   相册详情的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)photoDetailRequest:(MZPhotoDetailParam *)param success:(void (^)(MZModel *model,NSDictionary *issueDetail,NSArray *goodLists,NSArray *commentLists))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;


/**
 *  新消息条数
 *
 *  @param param  新消息条数的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)newIsHaveRequest:(MZNewIsHaveParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
/**
 *  消息列表
 *
 *  @param param   消息列表的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)newlistsRequest:(MZNewlistsParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;


/**
 *  用户反馈
 *
 *  @param param   用户反馈的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)fankRequest:(MZFeedbackParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

/**
 *  添加评论
 *
 *  @param param   添加评论的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)addCommentRequest:(MZAddCommentParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
/**
 *  添加回复
 *
 *  @param param   添加回复的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)replyCommentRequest:(MZReplyCommentParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//照片上传
+ (AFHTTPRequestOperation *)doUploadRequest:(MZDoUploadParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//更改相册封面
+ (AFHTTPRequestOperation *)resetAlbumImgRequest:(MZResetAlbumImg *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//删除照片
+ (AFHTTPRequestOperation *)phoneDelRequest:(MZPhoneDelParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//获取用户资料
+ (AFHTTPRequestOperation *)userEditRequest:(MZUserEditParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//删除相册成员|退出相册（群主可删，相册详情标)
+ (AFHTTPRequestOperation *)deleteAlbumemberRequest:(MZDeleteAlbumMemberParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//编辑个人相册详情（提交详情）
+ (AFHTTPRequestOperation *)editAlbumRequest:(MZEditAlbumParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//用户相册上传照片列表
+ (AFHTTPRequestOperation *)albumUserPhotosRequest:(MZAlbumUserPhotosParam *)param success:(void (^)(NSString * idDelMem, NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

//举报接口
+ (AFHTTPRequestOperation *)reportUserRequest:(MZReportUserParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//更新检查接口
+ (AFHTTPRequestOperation *)checkRequest:(MZReportUserParam *)param  success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

//返回照片点赞数评论数
+ (AFHTTPRequestOperation *)goodsCommentsRequest:(MZGoodsCommentsParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

//返回用户是否有相册
+ (AFHTTPRequestOperation *)isAlbumRequest:(MZIsAlbumParam *)param success:(void (^)(NSString *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

//照片发布接口（获取捆绑id）
+ (AFHTTPRequestOperation *)photosIssueRequest:(MZPhotoIssueParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;


//群聊列表
+ (AFHTTPRequestOperation *)groupListRequest:(MZGroupListParam *)param success:(void (^)(NSArray *groupChatLists))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

//群聊发送接口
+ (AFHTTPRequestOperation *)addGroupRequest:(MZAddGroupParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

//群聊回复接口
+ (AFHTTPRequestOperation *)replyGroupRequest:(MZReplyGroupParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

//分享接口（照片详情页）
+ (AFHTTPRequestOperation *)shareRequest:(MZShareParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

//广告位接口
+ (AFHTTPRequestOperation *)advertRequest:(MZAdvertParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;


//下载链接
+ (AFHTTPRequestOperation *)downLoadParamRequest:(MZDownLoadParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//退出登录接口
+ (AFHTTPRequestOperation *)quitLoginRequest:(MZQuitLoginParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//app端二维码加入相册
+ (AFHTTPRequestOperation *)appAddRequest:(MZAppAddParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//录音上传
+ (AFHTTPRequestOperation *)uploadSpeechRequest:(MZUploadSpeechParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;
//公共相册接口
+ (AFHTTPRequestOperation *)publicAlbumRequest:(MZAdvertParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure;

@end
