//
//  MZRequestManger+User.m
//  MZTuShenMa
//
//  Created by Wangxin on 15/8/26.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZRequestManger+User.h"
#import "UserHelp.h"
#import "MJExtension.h"
#import "MZLaunchManager.h"
@implementation MZRequestManger (User)

+ (AFHTTPRequestOperation *)loginRequest:(MZLoginParam *)param
                                 success:(void (^)(NSDictionary *object))success
                                 failure:(void (^)(NSString *errMsg,NSString *errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([[self class] isSuccessCode:response])
                {
                    [[UserHelp sharedUserHelper] setValuesForKeysWithDictionary:responseObject[@"responseData"]];
                    
//                    success(response.body[0]);
                    success(responseObject[@"responseData"]);
                }
                else
                {
                    failure(response.errMsg,response.errCode);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}


//手机号验证
+ (AFHTTPRequestOperation *)phoneValidateRequest:(MZPhoneValidateParam *)param
                                         success:(void (^)(NSString *object))success
                                         failure:(void (^)(NSString *errMsg))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([[self class] isSuccessCode:response])
                {
                    
                    success(responseObject[@"code"]);
                }
                else
                {
                    failure(response.errMsg);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error]);
        }
    }];
    
    return openation;
}


//手机号注册
+ (AFHTTPRequestOperation *)RegisterPhoneRequestsuccess:(void (^)(NSDictionary *))success
                                                failure:(void (^)(NSString *))failure
{
    MZRegisterPhoneParam *param = [[MZRegisterPhoneParam alloc] init];
    
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([[self class] isSuccessCode:response])
                {
//                    success(responseObject[@"userId"]);
                      success(responseObject[@"responseData"]);
                }
                else
                {
                    failure(response.errMsg);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error]);
        }
    }];
    
    return openation;
}


//填写用户资料
+ (AFHTTPRequestOperation *)UserFillRequest:(MZUserFillParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
//                MZModel *model = [MZModel objectWithKeyValues:responseObject];
//                success(model.responseData);
//                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
                
                if ([[self class] isSuccessCode:response])
                {
                    [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                    success(responseObject[@"responseData"]);
                }
                else
                {
                    failure(response.errMsg,response.errCode);
                }

            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}


+ (AFHTTPRequestOperation *)forgetPasswordRequest:(MZForgetPasswordParam *)param   success:(void (^)(NSString *object,NSString *errMsg))success                                              failure:(void (^)(NSString *errMsg))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([[self class] isSuccessCode:response])
                {
                     [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                    success(responseObject[@"userId"],response.errMsg);
                }
                else
                {
                    failure(response.errMsg);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error]);
        }
    }];
    
    return openation;

}





+ (AFHTTPRequestOperation *)createAlbumRequest:(MZCreateAlbumParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([[self class] isSuccessCode:response])
                {
                    
                    success(response.body[0]);
                }
                else
                {
                    if ([response.errMsg isEqualToString:@"账号冻结"]) {
                        [self freezeUser];
                    }

                    failure(response.errMsg,response.errCode);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
            
        }
    }];
    
    return openation;

}



+ (AFHTTPRequestOperation *)AlbumlistsRequest:(MZMainParam *)param success:(void (^)(NSArray *responseData,NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                  MZModel *model = [MZModel objectWithKeyValues:responseObject];
                if (model.errCode ==10010) {
                    [self freezeUser];
                }
                  success(model.responseData,responseObject);
                
                  [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}

+ (AFHTTPRequestOperation *)photolistsRequest:(MZDynamicListParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
     AFHTTPRequestOperation *openation = [param bindRequestOperation];
     [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if(success)
         {
             if(responseObject)
             {
                 MZModel *model = [MZModel objectWithKeyValues:responseObject];
                 
                 // [response.errMsg isEqualToString:@"账号冻结"]
                 if ([model.errMsg isEqualToString:@"账号冻结"]) {
                     [self freezeUser];
                 }
                 
                success(model.photoLists);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
             }
         }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if(failure)
         {
             failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
         }
     }];
    
     return openation;
}

+ (AFHTTPRequestOperation *)photoGoodRequest:(MZPhotoGoodParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    

    
    return openation;

}

+ (AFHTTPRequestOperation *)albumDetailsRequest:(MZPhotoAlbumDetailsParam *)param success:(void (^)(NSArray *albumMembers,NSArray *userAlbumDetails))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZModel *model = [MZModel objectWithKeyValues:responseObject];
                success(model.albumMembers,model.userAlbumDetails);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
                if ([model.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }

            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}

+ (AFHTTPRequestOperation *)photoDetailRequest:(MZPhotoDetailParam *)param success:(void (^)(MZModel *model,NSDictionary *issueDetail,NSArray *goodLists,NSArray *commentLists))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZModel *model = [MZModel objectWithKeyValues:responseObject];
                success(model,model.issueDetail,model.goodLists,model.commentLists);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
                if ([model.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}


+ (AFHTTPRequestOperation *)newIsHaveRequest:(MZNewIsHaveParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    
    
    return openation;

}


+ (AFHTTPRequestOperation *)newlistsRequest:(MZNewlistsParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                MZModel *model = [MZModel objectWithKeyValues:responseObject];
                success(model.newlistss);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}


+ (AFHTTPRequestOperation *)fankRequest:(MZFeedbackParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                if ([response.errMsg isEqualToString:@"反馈成功"]) {
                    success(responseObject);
                }else{
                    failure(response.errMsg,response.errCode);
                }
                
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
                
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    
    
    return openation;

}


/**
 *  添加评论
 *
 *  @param param   添加评论的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)addCommentRequest:(MZAddCommentParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    
    
    return openation;
}
/**
 *  添加回复
 *
 *  @param param   添加回复的body体
 *  @param success 成功
 *  @param failure 失败
 *
 *  @return
 */
+ (AFHTTPRequestOperation *)replyCommentRequest:(MZReplyCommentParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}


+ (AFHTTPRequestOperation *)doUploadRequest:(MZDoUploadParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

//更改相册封面
+ (AFHTTPRequestOperation *)resetAlbumImgRequest:(MZResetAlbumImg *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

//删除照片
+ (AFHTTPRequestOperation *)phoneDelRequest:(MZPhoneDelParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}


//获取用户资料
+ (AFHTTPRequestOperation *)userEditRequest:(MZUserEditParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
         
            
            if(responseObject)
            {
                MZModel *model = [MZModel objectWithKeyValues:responseObject];
                success(model.responseData);
                
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
                if ([model.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}

//删除相册成员|退出相册（群主可删，相册详情标)
+ (AFHTTPRequestOperation *)deleteAlbumemberRequest:(MZDeleteAlbumMemberParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}


//编辑个人相册详情（提交详情）
+ (AFHTTPRequestOperation *)editAlbumRequest:(MZEditAlbumParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

//用户相册上传照片列表
+ (AFHTTPRequestOperation *)albumUserPhotosRequest:(MZAlbumUserPhotosParam *)param success:(void (^)(NSString * idDelMem,NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
//                MZModel *model = [MZModel objectWithKeyValues:responseObject];
                NSDictionary *dict = [responseObject objectForKey:@"responseData"];
                success([dict objectForKey:@"is_del"],[dict objectForKey:@"issueLists"]);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[responseObject objectForKey:@"errCode"] errMsg:[responseObject objectForKey:@"errMsg"]];
                if ([[responseObject objectForKey:@"errMsg"] isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
                
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}

//举报接口
+ (AFHTTPRequestOperation *)reportUserRequest:(MZReportUserParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}

//更新检查接口
+ (AFHTTPRequestOperation *)checkRequest:(MZReportUserParam *)param  success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([[self class] isSuccessCode:response])
                {
                    [[UserHelp sharedUserHelper] setValuesForKeysWithDictionary:responseObject[@"responseData"]];
                    
                    //                    success(response.body[0]);
                    success(responseObject[@"responseData"]);
                }
                else
                {
                    failure(response.errMsg,response.errCode);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

+ (AFHTTPRequestOperation *)goodsCommentsRequest:(MZGoodsCommentsParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([[self class] isSuccessCode:response])
                {
                    [[UserHelp sharedUserHelper] setValuesForKeysWithDictionary:responseObject[@"responseData"]];
                    success(responseObject[@"responseData"]);
                    [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                    
                }
                else
                {
                    failure(response.errMsg,response.errCode);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}

+ (AFHTTPRequestOperation *)isAlbumRequest:(MZIsAlbumParam *)param success:(void (^)(NSString *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                 MZModel *model = [MZModel objectWithKeyValues:responseObject];
                
//                if ([[self class] isSuccessCode:response])
//                {
//                    
                    success(model.is_album);
//                }
//                else
//                {
//                    failure(response.errMsg,response.errCode);
//                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}

+ (AFHTTPRequestOperation *)photosIssueRequest:(MZPhotoIssueParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                
                if ([[self class] isSuccessCode:response])
                {
                    [[UserHelp sharedUserHelper] setValuesForKeysWithDictionary:responseObject[@"responseData"]];
                    success(responseObject[@"responseData"]);
                    [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                    
                }
                else
                {
                    failure(response.errMsg,response.errCode);
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

//群聊列表
+ (AFHTTPRequestOperation *)groupListRequest:(MZGroupListParam *)param success:(void (^)(NSArray *groupChatLists))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                MZModel *model = [MZModel objectWithKeyValues:responseObject];
                success(model.groupChatLists);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
                
                if ([model.errMsg isEqualToString:@"账号冻结"]) {
                    
                    [self freezeUser];
                }
                
               
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

//群聊发送接口
+ (AFHTTPRequestOperation *)addGroupRequest:(MZAddGroupParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;
}

//群聊回复接口
+ (AFHTTPRequestOperation *)replyGroupRequest:(MZReplyGroupParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

//分享接口（照片详情页）
+ (AFHTTPRequestOperation *)shareRequest:(MZShareParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    return openation;
}

//广告位接口
+ (AFHTTPRequestOperation *)advertRequest:(MZAdvertParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                MZModel *model = [MZModel objectWithKeyValues:responseObject];
                success(model.responseData);
                
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
            }
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

+ (AFHTTPRequestOperation *)downLoadParamRequest:(MZDownLoadParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    return openation;
}


+ (AFHTTPRequestOperation *)quitLoginRequest:(MZQuitLoginParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    return openation;
}


//app端二维码加入相册
+ (AFHTTPRequestOperation *)appAddRequest:(MZAppAddParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
                if ([response.errMsg isEqualToString:@"账号冻结"]) {
                    [self freezeUser];
                }
                
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    return openation;
}


//录音上传
+ (AFHTTPRequestOperation *)uploadSpeechRequest:(MZUploadSpeechParam *)param success:(void (^)(NSDictionary *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(success)
        {
            if(responseObject)
            {
                MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:responseObject];
                success(responseObject);
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:response.errCode errMsg:response.errMsg];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    
    return openation;

}

//公共相册接口
+ (AFHTTPRequestOperation *)publicAlbumRequest:(MZAdvertParam *)param success:(void (^)(NSArray *object))success failure:(void (^)(NSString *errMsg,NSString * errCode))failure
{
    AFHTTPRequestOperation *openation = [param bindRequestOperation];
    
    [[MZHttpServer servse] requestByOperation:openation success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if(success)
        {
            if(responseObject)
            {
                MZModel *model = [MZModel objectWithKeyValues:responseObject];
                success(model.responseData);
                
                [self logInfoSuccessStatusCode:operation.response.statusCode responseObject:responseObject responseString:operation.responseString errCode:[NSString stringWithFormat:@"%ld",model.errCode] errMsg:model.errMsg];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(failure)
        {
            failure([[self class] showMsgWithError:error],[NSString stringWithFormat:@"%ld",error.code]);
        }
    }];
    return openation;
}


+(void)logInfoSuccessStatusCode:(NSInteger)statusCode responseObject:(id)responseObject responseString:(NSString*)responseString errCode:(NSString *)errCode errMsg:(NSString *)errMsg{
    NSLog(@"请求状态: %@",@"success");
    NSLog(@"状态码: %ld",(long)statusCode);
    NSLog(@"请求响应结果: %@",responseObject);
    NSLog(@"请求响应结果: %@",responseString);
    NSLog(@"错误码: %@,以及错误原因: %@",errCode,errMsg);
}

#pragma mark - Private Method

//冻结用户
+ (void)freezeUser
{
    [UIAlertView alertViewWithTitle:@"提示" message:@"您的账号被冻结了" cancelButtonTitle:@"确定" otherButtonTitles:nil onDismiss:^(int buttonIndex) {
    } onCancel:^{
        //退出登录
        MZQuitLoginParam *quitLoginParam = [[MZQuitLoginParam alloc]init];
        quitLoginParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
        [MZRequestManger quitLoginRequest:quitLoginParam success:^(NSDictionary *object) {
            
        } failure:^(NSString *errMsg, NSString *errCode) {
            
        }];
        [[MZLaunchManager manager] logoutScreen];
        [[MZLaunchManager manager] logout];
    }];

}


@end
