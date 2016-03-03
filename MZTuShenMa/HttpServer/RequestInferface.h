//
//  RequestInferface.h
//  ZhiXuan
//
//  Created by Wangxin on 15/6/5.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#ifndef ZhiXuan_RequestInferface_h
#define ZhiXuan_RequestInferface_h
#import <Foundation/Foundation.h>
// -- MARK: 请求host
//正式库
//static NSString * const kHost = @"http://tushenme.yuntumingzhi.cn";
//测试库
static NSString * const kHost = @"http://tushenme.52yingzheng.com";
//本地iP地址
//static NSString * const kHost = @"http://192.168.92.107";
// -- MARK: 请求端口号
static NSString * const kPort = @"80/3.0";
// -- MARK: 登录接口的固定盐值
static NSString * const kLoginAuth = @"ytzhixuan20";

// -- MARK: ------------------------------------- 请求地址 -----------------------------------------
// -- MARK: 共用字段名
#define AUTHCODE @"authcode"
// -- MARK: 登录
static NSString * const kLogin      = @"LoginApi/login";
// -- MARk: 手机号验证码
static NSString * const kPhoneValidate = @"LoginApi/phone_validate";
// -- MARK: 注册
static NSString * const kRegisterPhone = @"LoginApi/register_phone";
// -- MARK: 填写用户资料|更新资料
static NSString * const kUserFill = @"UserApi/user_fill";
// -- MARK: 用户头像上传
static NSString * const kUploadHeadimg = @"UserApi/upload_headImg";
// -- MARK: 创建相册
static NSString * const kCreateAlbum = @"AlbumApi/create_album";
// -- MARK: 相册列表
static NSString * const kAlbumlists = @"AlbumApi/album_lists";
// -- MARK: 照片列表
static NSString * const kPhotolists = @"PhotoApi/photo_lists";
// -- MARK: 照片点赞
static NSString * const kPhotoGood = @"PhotoApi/photo_good";
// -- MARK: 相册详情
static NSString * const kAlbumDetails = @"AlbumApi/album_details";
// -- MARK: 相片详情
static NSString * const kPhotoDetails = @"PhotoApi/photo_detail";
// -- MARK: 新消息条数
static NSString * const kNewIsHave = @"NewsApi/is_have";
// -- MARK: 新消息列表|历史消息列表
static NSString * const kNewlists = @"NewsApi/new_lists";
// -- MARK: 用户反馈
static NSString * const kFank = @"LoginApi/fank";
// -- MARK: 添加评论
static NSString * const kAddComment = @"CommentApi/add_comment";
// -- MARK: 添加回复
static NSString * const kReplyComment = @"CommentApi/reply_comment";
// -- MARK: 添加相册成员
static NSString * const kAddAlbumMember = @"AlbumApi/add_albumMember";
// -- MARK: 照片上传
static NSString * const kDoUpload = @"PhotoApi/do_upload";
// -- MARK: 更改相册封面
static NSString * const kResetAlbumImg = @"AlbumApi/reset_album_img";
// -- MARK: 删除照片
static NSString * const kPhoneDel = @"PhotoApi/phone_del";
// -- MARK: 获取用户资料
static NSString * const kUserEdit = @"UserApi/user_edit";
// -- MARK: 删除相册成员|退出相册（群主可删，相册详情标识已经带过去了）
static NSString * const kDeleteAlbumMember = @"AlbumApi/delete_albumMember";
// -- MARK: 编辑个人相册详情（提交详情）
static NSString * const kEditAlbum = @"AlbumApi/edit_album";
// -- MARK: 用户相册上传照片列表
static NSString * const kAlbumUserPhotos = @"AlbumApi/album_user_photos";
// -- MARK: 举报接口
static NSString * const kReportUser = @"UserApi/report_user";
// -- MARK: 更新检查接口
static NSString * const kCheck = @"LoginApi/check";
// -- MARK: 返回照片点赞数评论数
static NSString * const kGoodsComments = @"PhotoApi/goods_comments";
// -- MARK: 返回用户是否有相册
static NSString * const kIsAlbum = @"AlbumApi/is_album";
// -- MARK: 照片发布接口（获取捆绑id）
static NSString * const kPhotosIssue = @"PhotoApi/photos_issue";
// -- MARK: 群聊列表
static NSString * const kGroupList = @"GroupChatApi/group_list";
// -- MARK: 群聊发送接口
static NSString * const kAddGroup = @"GroupChatApi/add_group";
// -- MARK: 群聊回复接口
static NSString * const kReplyGroup = @"GroupChatApi/reply_group";
// -- MARK: 分享接口（照片详情页）
static NSString * const kShare = @"ShareApi/index";
//三十二.广告位接口  
static NSString * const kAdvertApi = @"AdvertApi/index";
//三十三.安装地址
static NSString * const kDownloadApi = @"PhotoH5/download";
//三十四.退出登录接口
static NSString * const kQuitLogin = @"LoginApi/quit_login";
//三十五.app端二维码加入相册
static NSString * const kAppAdd = @"AlbumApi/appAdd_albumMember";
//三十六.录音上传
static NSString * const kUploadSpeech = @"PhotoApi/upload_speech";
//三十七.公共相册接口
static NSString * const kPublicAlbum = @"AlbumApi/publicAlbum_lists";
//三十八.视频上传接口
static NSString * const kMp4Api = @"Mp4Api/upload_mp4";
#endif
