//
//  MZDynamicDetailViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/8/25.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZDynamicDetailViewController.h"
#import "MZDynamicDetailTableViewCell.h"
#import "DynamicCommentTableViewCell.h"
#import "MZPraisePersonTableViewCell.h"
#import "MZMessageViewController.h"
#import "MZPhotoDetailParam.h"
#import "MZMainCommentListsModel.h"
#import "MZMainGoodListsModel.h"
#import "MZMainPhotoDetailModel.h"
#import "MZAddCommentParam.h"
#import "MZReplyCommentParam.h"
#import "MZShareView.h"
#import "MZMoreView.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UIImageView+WebCache.h"
#import "MZReplyCommentParam.h"
#import "MZReplyListsModel.h"

#import "FaceToolBar.h"
#import "MZOneMoreView.h"

@interface MZDynamicDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,MZMoreViewDelegate,MZShareViewDelegate,DynamicCommentTableViewCellDelegate,MZDynamicDetailTableViewCellDelegate,UIScrollViewDelegate,FaceToolBarDelegate,facialViewDelegate,MZOneMoreViewDelegate,UIAlertViewDelegate>
{
     UIView *_tabBar;
     UITextView *_input;
     UILabel *_placeholder;
     UIButton *_sendButton;
    //存放照片详情的model
//    NSMutableArray *_photoDetailArray;
    MZMainPhotoDetailModel *_photoDetailModel;
    
    //存放点赞列表的model
    NSMutableArray *_goodListsArray;
    //存放评论列表的model
    NSMutableArray *_commentListsArray;
    UITableView *_tableView;
    UIButton *_messageButton;
    UIView *_redView;
    MZModel *_model;
    NSString *_path_img;
    NSString *_img_id;     //发布id
    NSUInteger _row;
    //是否为回复
    BOOL _isReply;
    NSMutableArray *_replyListsArray;
    CGFloat _height;//照片自适应高度
    CGFloat _commentHeight;
    NSMutableArray *_commentHeightArray;
    CGFloat _totalHeight;
    BOOL _isFirst;
    CGFloat _oldHeight;
    CGFloat _goodHeight;//点赞的高度
    BOOL _eventShare;
    BOOL _eventWechatShare;
    BOOL _eventMomentsShare;
    BOOL _eventMore;
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    UIButton *_faceButton;
    BOOL _keyboardIsShow;//键盘是否显示
    NSString *_photoListOfTheUserId;     //照片详情的用户iD
    BOOL _faceReply;//判断添加表情后,是否还是回复

}
@end

@implementation MZDynamicDetailViewController

static NSString *const dynamicDetailCellIdentifier = @"detailCell";
static NSString *const dynamicCommentTableViewCellIdentifier = @"commentCell";
static NSString *const praisePersonTableViewCellIdentifier = @"praisePersonCell";

#pragma mark -- Life Cycle


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[MDWMediaCenter defaultCenter]stopPlay];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"动态详情";
    [self setLeftBarButton];
    _isFirst = YES;
    _faceReply = YES;
    [self initData];
    // Do any additional setup after loading the view.
}

- (void)initUI:(MZMainPhotoDetailModel *)photoDetailModel
{
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:rect(0.0f,0.0f,SCREEN_WIDTH,SCREEN_HEIGHT)];
    scrollView.backgroundColor = RGB(244, 244, 244);;
    scrollView.delegate = self;
    scrollView.tag = 30000;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    if (photoDetailModel.lists.count == 1) {
        _height = SCREEN_WIDTH-30.0f;
    }else if (photoDetailModel.lists.count == 2){
        _height = (SCREEN_WIDTH-30.0f)/2;
    }else if (photoDetailModel.lists.count == 3){
        _height = (SCREEN_WIDTH-30.0f)/3;
    }else if (photoDetailModel.lists.count == 4){
        _height = (SCREEN_WIDTH-30.0f);
    }else if (photoDetailModel.lists.count > 4 && photoDetailModel.lists.count < 7){
        _height = ((SCREEN_WIDTH-30.0f)/3)*2;
    }else{
        if (photoDetailModel.lists.count%3>0) {
            _height = ((SCREEN_WIDTH-30.0f)/3)*(photoDetailModel.lists.count/3+1);
        }else{
            _height = ((SCREEN_WIDTH-30.0f)/3)*(photoDetailModel.lists.count/3);
        }
///        _height = SCREEN_WIDTH;
    }
    
//    _height = photoDetailModel.height/(photoDetailModel.weight/(SCREEN_WIDTH-30.0f));
     NSLog(@"_height = %f",_height);
    
    _goodHeight =35*(_goodListsArray.count/7+1);
//    _goodHeight =35*(21/7+1);
    
    for (int i = 0; i< _commentHeightArray.count; i++) {
        CGFloat height = [[_commentHeightArray objectAtIndex:i]floatValue];
        NSLog(@"height = %f",height);
        _totalHeight = _totalHeight+height;
    }
      NSLog(@"_totalHeight = %f",_totalHeight);
    
    if (_goodListsArray.count == 0) {
        if (_isFirst==NO ) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15,15,SCREEN_WIDTH-30,_height+90.0f+35.0f+_totalHeight-_oldHeight) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15,15,SCREEN_WIDTH-30,_height+90.0f+35.0f+_totalHeight) style:UITableViewStylePlain];
        }
        
    }else{
        if (_isFirst==NO) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15,15,SCREEN_WIDTH-30,_height+90.0f+_goodHeight+_totalHeight-_oldHeight) style:UITableViewStylePlain];;
        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(15,15,SCREEN_WIDTH-30,_height+90.0f+_goodHeight+_totalHeight) style:UITableViewStylePlain];
        }
    }
    _tableView.layer.borderColor = [[UIColor colorWithRed:241.0f/255.0f green:246.0f/255.0f blue:246.0f/255.0f alpha:1.0f]CGColor];
    _tableView.layer.borderWidth= 1.0f;
    _tableView.layer.cornerRadius = 8;
    _tableView.layer.masksToBounds = YES;
    _tableView.scrollEnabled = NO;
//    _tableView.backgroundColor = [UIColor redColor];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //去掉多余的分割线
//   _tableView.tableFooterView = [[UIView alloc]init];
    [scrollView addSubview:_tableView];
    
    
    //注册标识
    [_tableView registerNib:[UINib nibWithNibName:@"MZDynamicDetailTableViewCell" bundle:nil] forCellReuseIdentifier:dynamicDetailCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"DynamicCommentTableViewCell" bundle:nil] forCellReuseIdentifier:dynamicCommentTableViewCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"MZPraisePersonTableViewCell" bundle:nil] forCellReuseIdentifier:praisePersonTableViewCellIdentifier];
    
    [self createTabbarView];
    
    if (_tableView.frame.size.height>SCREEN_HEIGHT-64.0f-toolBarHeight-20.0f) {
        NSLog(@"_tableView.frame.size.height = %f",_tableView.frame.size.height);
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _tableView.frame.size.height-(SCREEN_HEIGHT-64.0f-toolBarHeight-20.0f)+SCREEN_HEIGHT);
    }else{
        scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    }
}

//创建底部的Tabbar
- (void)createTabbarView
{
    _keyboardIsShow = YES;
    
    _tabBar=[[UIView alloc] initWithFrame:CGRectMake(0.0f, SCREEN_HEIGHT-toolBarHeight-64.0f, self.view.frame.size.width, toolBarHeight)];
     _tabBar.backgroundColor=RGB(235, 236, 237);
    [self.view addSubview:_tabBar];
    
    UIView *lineView = [[UIView alloc]initWithFrame:rect(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGB(206, 206, 206);
    [_tabBar addSubview:lineView];
    
    _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _faceButton.frame = rect(10.0f, 0, 30.0f, 50.0f);
    [_faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [_faceButton addTarget:self action:@selector(didClickFaceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:_faceButton];
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, keyboardHeight)];
//    _scrollView.backgroundColor = [UIColor redColor];
    [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
    for (int i=0; i<9; i++) {
        FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*i, 15, SCREEN_WIDTH-24, facialViewHeight)];
//        [fview setBackgroundColor:[UIColor greenColor]];
        if (iPhone6) {
            [fview loadFacialView:i size:CGSizeMake(38, 43)];
        }else if (iPhone6P){
            [fview loadFacialView:i size:CGSizeMake(43, 43)];
        }else{
            [fview loadFacialView:i size:CGSizeMake(33, 43)];
        }
        
        fview.delegate=self;
        [_scrollView addSubview:fview];
    }
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    _scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*9, keyboardHeight);
    _scrollView.pagingEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.tag = 30001;
    [self.view addSubview:_scrollView];
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(_scrollView.center.x-75.0f, self.view.frame.size.height-30, 150, 30)];
    [_pageControl setCurrentPage:0];
    _pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
    _pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    _pageControl.numberOfPages = 9;//指定页面个数
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    _pageControl.hidden=YES;
    [_pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
    
    

    _input=[[UITextView alloc] initWithFrame:CGRectMake(45.0f, 7.5f, self.view.frame.size.width-110.0f-25.0f, 35.0f)];
    _input.keyboardType = UIKeyboardTypeDefault;
    _input.layer.borderColor=[RGB(206, 206, 206) CGColor];
    _input.layer.borderWidth=0.4f;
    _input.layer.cornerRadius = 3;
    _input.layer.masksToBounds = YES;
    _input.delegate=self;
    _input.font=[UIFont systemFontOfSize:18.0f];
    //    [self.view addSubview:_input];
    [_tabBar addSubview:_input];
    
    _placeholder=[[UILabel alloc] initWithFrame:CGRectMake(48.0f, 0.0f, self.view.frame.size.width-110.0f, 50.0f)];
    _placeholder.font=[UIFont systemFontOfSize:18.0f];
    _placeholder.textColor=[UIColor grayColor];
    [_tabBar addSubview:_placeholder];
    
    _sendButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sendButton.layer.cornerRadius = 3;
    _sendButton.layer.masksToBounds = YES;
    _sendButton.frame=CGRectMake(_input.frame.origin.x+_input.bounds.size.width+10.0f, 7.5f, self.view.frame.size.width-20.0f-_input.bounds.size.width-_input.frame.origin.x, 35.0f);
    [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
    _sendButton.titleLabel.font=[UIFont systemFontOfSize:15.0f];
    [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendButton setBackgroundColor:UIColorFromRGB(0x308afc)];
    [_sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:_sendButton];
    [_tabBar addSubview:_sendButton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)sendTextAction:(NSString *)inputText{
    NSLog(@"sendTextAction%@",inputText);
}

- (void)initData
{
    __weak typeof(self) weakSelf = self;
    MZPhotoDetailParam *photoDetailParam = [[MZPhotoDetailParam alloc]init];
    photoDetailParam.album_id = self.album_id;
    photoDetailParam.issue_id = self.issue_id;
    photoDetailParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    
    [self showHoldView];
    [MZRequestManger photoDetailRequest:photoDetailParam success:^(MZModel *model,NSDictionary *issueDetail, NSArray *goodLists, NSArray *commentLists) {
        [weakSelf hideHUD];
        
        _model = model;
        
        _photoDetailModel = [MZMainPhotoDetailModel objectWithKeyValues:issueDetail];
        
        if (_isFirst==NO) {
            [_goodListsArray removeAllObjects];
        }else{
            _goodListsArray = [NSMutableArray arrayWithCapacity:goodLists.count];
        }
        
        for (NSDictionary *dic in goodLists) {
            MZMainGoodListsModel *mainGoodListsModel = [MZMainGoodListsModel objectWithKeyValues:dic];
            [_goodListsArray addObject:mainGoodListsModel];
        }
        
        if (_isFirst==NO) {
            [_commentListsArray removeAllObjects];
            [_commentHeightArray removeAllObjects];
        }else{
            _commentListsArray = [NSMutableArray arrayWithCapacity:commentLists.count];
            _commentHeightArray  = [NSMutableArray arrayWithCapacity:commentLists.count];
        }
        
        for (NSDictionary *dic in commentLists) {
            MZMainCommentListsModel *commentListsModel = [MZMainCommentListsModel objectWithKeyValues:dic];
            if (commentListsModel.type == 0) {
                [_commentHeightArray addObject: [NSString stringWithFormat:@"%f",[DynamicCommentTableViewCell getCommentHeightWithNickname:[NSString stringWithFormat:@"%@: %@",commentListsModel.uname,commentListsModel.discuss]]]];
            }else{
                [_commentHeightArray addObject: [NSString stringWithFormat:@"%f",[DynamicCommentTableViewCell getCommentHeightWithNickname:[NSString stringWithFormat:@"%@回复%@:",commentListsModel.uname,commentListsModel.cname]]]];
            }
            [_commentListsArray addObject:commentListsModel];
            
        }

        if (_photoDetailModel) {
              [self initUI:_photoDetailModel];
        }
    } failure:^(NSString *errMsg, NSString *errCode) {
        
    }];
     
   
}


//表情键盘
- (void)didClickFaceButtonAction
{
    //显示键盘
    if (_keyboardIsShow == NO) {
        [UIView animateWithDuration:Time animations:^{
            [_scrollView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, keyboardHeight)];
        }];
        [_input becomeFirstResponder];
        [_pageControl setHidden:YES];
         _keyboardIsShow = YES;
        [_faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        NSLog(@"_tabBar显示键盘 = %@",_tabBar);
    }else{
        //显示表情
        NSLog(@"_tabBar啦啦 = %@",_tabBar);
        [UIView animateWithDuration:Time animations:^{
            _tabBar.frame = CGRectMake(0, self.view.frame.size.height-keyboardHeight-toolBarHeight+10.0f,self.view.bounds.size.width,toolBarHeight);
        } completion:^(BOOL finished) {
            _tabBar.frame = CGRectMake(0, self.view.frame.size.height-keyboardHeight-toolBarHeight,self.view.bounds.size.width,toolBarHeight);
        }];
    
        [UIView animateWithDuration:Time animations:^{
            [_scrollView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight,self.view.frame.size.width, keyboardHeight)];
        }];
        [_pageControl setHidden:NO];
        [_input resignFirstResponder];
        [_faceButton setImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
        _keyboardIsShow = NO;
        NSLog(@"_tabBar显示表情 = %@",_tabBar);
    }

}

#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    NSLog(@"进代理了");
    _placeholder.hidden=YES;
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (_input.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[_input.text substringFromIndex:_input.text.length-2]]) {
                NSLog(@"删除emoji %@",[_input.text substringFromIndex:_input.text.length-2]);
                newStr=[_input.text substringToIndex:_input.text.length-2];
            }else{
                NSLog(@"删除文字%@",[_input.text substringFromIndex:_input.text.length-1]);
                newStr=[_input.text substringToIndex:_input.text.length-1];
            }
            _input.text=newStr;
        }
        NSLog(@"删除后更新%@",_input.text);
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",_input.text,str];
        [_input setText:newStr];
        NSLog(@"点击其他后更新%d,%@",str.length,_input.text);
    }
    
    if (_input.text.length == 0) {
        _faceReply = YES;
    }
    
    if (_faceReply == NO) {
        _isReply=TRUE;
        _faceReply =YES;
    }
    
    NSLog(@"出代理了");
}

- (void)changePage:(id)sender {
    int page = _pageControl.currentPage;//获取当前pagecontroll的值
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}


#pragma mark -- Event Response

- (void)didClickMessageButtonAction
{
    NSLog(@"消息页面");
    MZMessageViewController *messageVC = [[MZMessageViewController alloc]init];
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

#pragma mark ----- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + 1 + _commentListsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return _height+70.0f+20.0f;
    }else if (indexPath.row == 1){
        return _goodHeight;
    }else{
        return [[_commentHeightArray objectAtIndex:indexPath.row -2]floatValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        MZDynamicDetailTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:dynamicDetailCellIdentifier forIndexPath:indexPath];
        detailCell.detailModel = _photoDetailModel;
        detailCell.detailPhotoModel = _model;
        detailCell.album_id = _album_id;
        detailCell.album_name = _album_name;
        detailCell.delegate = self;
        if (self.albumType == DynamicDetailViewControllerTypePublicAlbum) {
            detailCell.albumType = MZDynamicDetailTableViewCellTypePublicAlbum;
        }else{
            detailCell.albumType = MZDynamicDetailTableViewCellTypeNormal;
        }
        return detailCell;
    }else if (indexPath.row == 1){
        MZPraisePersonTableViewCell *praisePersonCell =[tableView dequeueReusableCellWithIdentifier:praisePersonTableViewCellIdentifier forIndexPath:indexPath];
      
        praisePersonCell.goodListsArray = _goodListsArray;
        praisePersonCell.praisePersonView.frame = rect(15, 0, SCREEN_WIDTH-40.0f, 35*(_goodListsArray.count/7+1));
//        praisePersonCell.praisePersonView.frame = rect(15, 0, SCREEN_WIDTH-40.0f, 35*(21/7+1));
        
//        UIView *segmentLine = [[UIView alloc]initWithFrame:rect(27.0f,0.0f,SCREEN_WIDTH-27,0.5)];
//        segmentLine.backgroundColor = RGBA(240, 240, 240, 0.8);
//        [praisePersonCell addSubview:segmentLine];
        return praisePersonCell;
    }else{
        MZMainCommentListsModel *commentListsModel=[_commentListsArray objectAtIndex:indexPath.row-2];
        DynamicCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:dynamicCommentTableViewCellIdentifier forIndexPath:indexPath];
        commentCell.delegate = self;
//        commentCell.iuiuh = [_modelarray objectAtIndex:indexPath.row-2];
        commentCell.model = commentListsModel;
        
        UIView *segmentLine = [[UIView alloc]initWithFrame:rect(27.0f,0.0f,SCREEN_WIDTH-27,0.5)];
        segmentLine.backgroundColor = RGBA(240, 240, 240, 0.8);
        [commentCell addSubview:segmentLine];
        
        return commentCell;
    }
}

- (void)scrollViewWillBeginDragging:(UITableView *)scrollView
{
    if (scrollView.tag == 30000) {
        [self hiddenKeyboard];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 30001) {
        int page = _scrollView.contentOffset.x / SCREEN_WIDTH;//通过滚动的偏移量来判断目前页面所对应的小白点
        _pageControl.currentPage = page;//pagecontroll响应值的变化
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenKeyboard];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWasShown:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        _tabBar.frame = CGRectMake(0, SCREEN_HEIGHT - keyboardF.size.height - toolBarHeight-64, SCREEN_WIDTH, toolBarHeight);
         NSLog(@"oooo = %f",keyboardF.size.height);
    }];
//    [_faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
//    _keyboardIsShow=YES;
//    [_pageControl setHidden:YES];
      NSLog(@"_tabBar1111 = %@",_tabBar);
}

- (void)keyboardWasHide:(NSNotification *)notification{
    if (![_placeholder.text isEqualToString:@""] || ![_placeholder.text isKindOfClass:[NSNull class]]) {
          _isReply=FALSE;
    }
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
//        _tabBar.frame =CGRectMake(0.0f, self.view.frame.size.height-toolBarHeight, self.view.frame.size.width, toolBarHeight);
//         _tabBar.frame =CGRectMake(0.0f, SCREEN_HEIGHT-toolBarHeight, self.view.frame.size.width, toolBarHeight);
        _tabBar.frame=CGRectMake(0.0f, SCREEN_HEIGHT-toolBarHeight-64.0f, self.view.frame.size.width, toolBarHeight);
    }];
//    [_pageControl setHidden:YES];
//    [_input resignFirstResponder];
//    [_faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
//    [_faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
//    _keyboardIsShow=NO;
}

#pragma mark ------ MZDynamicListDelegate
- (void)didClickPhotoDetailButtonWithTag:(NSInteger)tag photoId:(NSString *)photoId userId:(NSString *)userId detailPhotoModel:(MZModel *)detailPhotoModel row:(NSUInteger)row path_img:(NSString *)path_img
{
    switch (tag) {
        case 10000:
        {
            NSLog(@"点赞");
            MZPhotoGoodParam *photoGoodParam = [[MZPhotoGoodParam alloc]init];
            photoGoodParam.album_id = self.album_id;
            photoGoodParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
            photoGoodParam.issue_user_id = userId;
            photoGoodParam.issue_id = photoId;
            [MZRequestManger photoGoodRequest:photoGoodParam success:^(NSDictionary *object) {
                MZModel *model = [MZModel objectWithKeyValues:object];
                if (model.errCode == 10002) {
                    UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"已赞过了哦" message:nil delegate:nil
                                                              cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alterView show];
                }else if(model.errCode == 0){
                    detailPhotoModel.goodNum= detailPhotoModel.goodNum+1;
                    detailPhotoModel.is_good = 1;
                    [self initData];
                    _oldHeight = _totalHeight;
                }else{
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"请稍后再试" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alerView show];
                    
                }
            } failure:^(NSString *errMsg, NSString *errCode) {
                
            }];
        }
            break;
        case 10002:
        {
            NSLog(@"分享");
            
            [[BaiduMobStat defaultStat] logEvent:@"share" eventLabel:@"所有-分享入口"];
            if(!_eventShare) {
                _eventShare = YES;
                [[BaiduMobStat defaultStat] eventStart:@"share" eventLabel:@"所有-分享入口"];
            } else {
                _eventShare = NO;
                [[BaiduMobStat defaultStat] eventEnd:@"share" eventLabel:@"所有-分享入口"];
            }
            [[BaiduMobStat defaultStat] logEventWithDurationTime:@"share" eventLabel:@"所有-分享入口" durationTime:1000];
            
            MZShareView *shareView =[[MZShareView alloc]init];
            shareView.frame = [UIScreen mainScreen].bounds;
            _path_img = path_img;
            _img_id = photoId;
            shareView.delegate = self;
            [shareView show];
        }
            break;
        case 10003:
        {
            NSLog(@"举报或者删除图片");
            [[BaiduMobStat defaultStat] logEvent:@"more" eventLabel:@"所有-更多入口"];
            if(!_eventMore) {
                _eventMore = YES;
                [[BaiduMobStat defaultStat] eventStart:@"more" eventLabel:@"所有-更多入口"];
            } else {
                _eventMore = NO;
                [[BaiduMobStat defaultStat] eventEnd:@"more" eventLabel:@"所有-更多入口"];
            }
            [[BaiduMobStat defaultStat] logEventWithDurationTime:@"more" eventLabel:@"所有-更多入口" durationTime:1000];
            
            
//            MZMoreView *moreView =[[MZMoreView alloc]init];
//            moreView.frame = [UIScreen mainScreen].bounds;
//            if (detailPhotoModel.is_bos == 0) {
//                if (![[userdefaultsDefine objectForKey:@"user_id"] isEqualToString:userId]) {
//                    moreView.removeButton.hidden = YES;
//                    moreView.removeLabel.hidden = YES;
//                }
//            }
//            _path_img = path_img;
//            _img_id = photoId;
//            _photoListOfTheUserId = userId;
//            _row = row;
//            moreView.delegate = self;
//            [moreView show];
            
            
            //自己是不是群主
            if (detailPhotoModel.is_bos == 0) {
                MZOneMoreView *oneMoreView =[[MZOneMoreView alloc]init];
                oneMoreView.frame = [UIScreen mainScreen].bounds;
                //删除自己 不能举报自己   B
                if ([[userdefaultsDefine objectForKey:@"user_id"] isEqualToString:userId]) {
                    oneMoreView.oneButton.tag = 50000;
//                    [oneMoreView.oneButton setImage:[UIImage imageNamed:@"mian_remove@2x"] forState:UIControlStateNormal];
                    [oneMoreView.oneButton setTitle:@"删除" forState:UIControlStateNormal];
                    //自己不能删除别人 自己能举报别人   B
                }else{
                    oneMoreView.oneButton.tag = 50001;
//                    [oneMoreView.oneButton setImage:[UIImage imageNamed:@"mian_report@2x"] forState:UIControlStateNormal];
                     [oneMoreView.oneButton setTitle:@"举报" forState:UIControlStateNormal];
                }
                oneMoreView.delegate = self;
                [oneMoreView show];
                //自己是群主
            }else{
                //删除一定在
                //举报不一定在
                //1 删除  自己不能举报自己 B
                if ([[userdefaultsDefine objectForKey:@"user_id"] isEqualToString:userId]) {
                    MZOneMoreView *oneMoreView =[[MZOneMoreView alloc]init];
                    oneMoreView.frame = [UIScreen mainScreen].bounds;
                    oneMoreView.oneButton.tag = 50000;
//                    [oneMoreView.oneButton setImage:[UIImage imageNamed:@"mian_remove@2x"] forState:UIControlStateNormal];
                    [oneMoreView.oneButton setTitle:@"删除" forState:UIControlStateNormal];
                    oneMoreView.delegate = self;
                    [oneMoreView show];
                    //2 删除  自己可以举报别人  A
                }else{
                    MZMoreView *moreView =[[MZMoreView alloc]init];
                    moreView.frame = [UIScreen mainScreen].bounds;
                    moreView.delegate = self;
                    [moreView show];
                }
            }
            _path_img = path_img;
            _img_id = photoId;
            _photoListOfTheUserId = userId;
            _row = row;
        }
            break;
        default:
            break;
    }
}

#pragma mark ---- MZShareViewDelegate

- (void)clickWechatButtonAction
{
    [[BaiduMobStat defaultStat] logEvent:@"wechatShare" eventLabel:@"微信好友分享"];
    if(!_eventWechatShare) {
        _eventWechatShare = YES;
        [[BaiduMobStat defaultStat] eventStart:@"wechatShare" eventLabel:@"微信好友分享"];
    } else {
        _eventWechatShare = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"wechatShare" eventLabel:@"微信好友分享"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"wechatShare" eventLabel:@"微信好友分享" durationTime:1000];
    [self shareImageWithSocialPlatformWithName:UMShareToWechatSession];
}

- (void)shareImageWithSocialPlatformWithName:(NSString *)name
{
//    __weak typeof(self) weakSelf = self;
//    UIImageView *sharImage = [[UIImageView alloc] init];
//    [sharImage sd_setImageWithURL:[NSURL URLWithString:_path_img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
//        UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
//        [socialControllerService setShareText:@"和你的朋友一起玩的相册" shareImage:UIImagePNGRepresentation(sharImage.image) socialUIDelegate:nil];
//        [UMSocialSnsPlatformManager getSocialPlatformWithName:name].snsClickHandler(weakSelf,socialControllerService,YES);
//    }];
    __weak typeof(self) weakSelf = self;
    MZShareParam *shareParam = [[MZShareParam alloc]init];
    shareParam.issue_id = _issue_id;
    shareParam.album_id = _album_id;
    shareParam.code = @"PhotoDetail";
    shareParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    [self showHoldView];
    [MZRequestManger shareRequest:shareParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
        UIImageView *sharImage = [[UIImageView alloc] init];
        [sharImage sd_setImageWithURL:[NSURL URLWithString:_path_img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = [NSString stringWithFormat:@"《%@》",_album_name];
            UMSocialControllerService *socialControllerService =[UMSocialControllerService defaultControllerService];
            [socialControllerService setShareText:[NSString stringWithFormat:@"%@和您分享ta的精彩时刻",_photoDetailModel.uname] shareImage:UIImagePNGRepresentation(sharImage.image) socialUIDelegate:nil];
            NSLog(@"url == %@",[object objectForKey:@"url"]);
            [UMSocialData defaultData].extConfig.wechatSessionData.url = [object objectForKey:@"url"];
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = [object objectForKey:@"url"];
            [UMSocialSnsPlatformManager getSocialPlatformWithName:name].snsClickHandler(weakSelf,socialControllerService,YES);
        }];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];
}


- (void)clickWechatFriendButtonAction
{
    [[BaiduMobStat defaultStat] logEvent:@"momentsShare" eventLabel:@"朋友圈分享"];
    if(!_eventMomentsShare) {
        _eventMomentsShare = YES;
        [[BaiduMobStat defaultStat] eventStart:@"momentsShare" eventLabel:@"朋友圈分享"];
    } else {
        _eventMomentsShare = NO;
        [[BaiduMobStat defaultStat] eventEnd:@"momentsShare" eventLabel:@"朋友圈分享"];
    }
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"momentsShare" eventLabel:@"朋友圈分享" durationTime:1000];
    [self shareImageWithSocialPlatformWithName:UMShareToWechatTimeline];
}


#pragma mark ------MZMoreViewDelegate
//举报
- (void)clickReportButtonAction
{
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    
//    [manager downloadImageWithURL:[NSURL URLWithString:_path_img] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        NSLog(@"显示当前进度");
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
//        NSLog(@"下载完成");
//        //下载图片到相册
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"小图提示" message:@"下载成功了" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//        [alerView show];
//    }];
    
    __weak typeof(self) weakSelf = self;
    MZReportUserParam *reportUserParam = [[MZReportUserParam alloc]init];
    reportUserParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    reportUserParam.album_memId = _photoListOfTheUserId;
    reportUserParam.album_id = self.album_id;
    [self showHoldView];
    [MZRequestManger reportUserRequest:reportUserParam success:^(NSDictionary *object) {
        [weakSelf hideHUD];
        MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
        if ([response.errMsg isEqualToString:@"账号冻结"]) {
            return ;
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"举报成功了!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [weakSelf hideHUD];
    }];
}
//- (void)clickCoverButtonAction
//{
//    MZResetAlbumImg *resetAlbumImg = [[MZResetAlbumImg alloc]init];
//    resetAlbumImg.img_id = _img_id;
//    resetAlbumImg.album_id = self.album_id;
//    [MZRequestManger resetAlbumImgRequest:resetAlbumImg success:^(NSDictionary *object) {
//        
//    } failure:^(NSString *errMsg, NSString *errCode) {
//        
//    }];
//    
//}
- (void)clickRemoveButtonAction
{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请问您要删除这条动态吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

    
    
}

#pragma mark ---- UIAlerViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
         __weak typeof(self) weakSelf = self;
        MZPhoneDelParam *phoneParam = [[MZPhoneDelParam alloc]init];
        phoneParam.issue_id =_issue_id;
        phoneParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
        [self showHoldView];
        [MZRequestManger phoneDelRequest:phoneParam success:^(NSDictionary *object) {
            [weakSelf hideHUD];
            MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
            NSLog(@"response.errMsg == %@",response.errMsg);
            if ([response.errMsg isEqualToString:@"账号冻结"]) {
                return ;
            }

            //        [_photoDetailModel removeAllObjects];//移除数据源的数据
            [_goodListsArray removeAllObjects];
            [_commentListsArray removeAllObjects];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString *errMsg, NSString *errCode) {
              [weakSelf hideHUD];
        }];
    }
}

- (void)clickOneButtonAction:(UIButton *)button;
{
    if (button.tag == 50000) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请问您要删除这条动态吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
//        MZPhoneDelParam *phoneParam = [[MZPhoneDelParam alloc]init];
//        phoneParam.issue_id =_issue_id;
//        NSLog(@"phoneParam.issue_id == %@",phoneParam.issue_id);
//        [MZRequestManger phoneDelRequest:phoneParam success:^(NSDictionary *object) {
//            //        [_photoDetailModel removeAllObjects];//移除数据源的数据
//            [_goodListsArray removeAllObjects];
//            [_commentListsArray removeAllObjects];
//            [self.navigationController popViewControllerAnimated:YES];
//        } failure:^(NSString *errMsg, NSString *errCode) {
//            
//        }];
    }else{
        __weak typeof(self) weakSelf = self;
        MZReportUserParam *reportUserParam = [[MZReportUserParam alloc]init];
        reportUserParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
        reportUserParam.album_id = self.album_id;
        reportUserParam.album_memId = _photoListOfTheUserId;
        [self showHoldView];
        [MZRequestManger reportUserRequest:reportUserParam success:^(NSDictionary *object) {
            [weakSelf hideHUD];
            MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
            if ([response.errMsg isEqualToString:@"账号冻结"]) {
                return ;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"举报成功了!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } failure:^(NSString *errMsg, NSString *errCode) {
            [weakSelf hideHUD];
        }];
    }
}



-(void)sendAction{
   
        NSString *text=_input.text;
        if (![text isEqualToString:@""]&&text!=nil&&([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length!=0)){
             __weak typeof(self) weakSelf = self;
            if (_isReply==TRUE) {
                MZReplyCommentParam *replyCommentParam = [[MZReplyCommentParam alloc]init];
                replyCommentParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
                replyCommentParam.comment_id = self.comment_id;
                replyCommentParam.issue_id = self.issue_id;
                replyCommentParam.discuss = text;
                replyCommentParam.group_id = self.group_id;
                replyCommentParam.comment_user_id = self.comment_user_id;
                replyCommentParam.album_id = self.album_id;
                
                NSLog(@"replyCommentParam.user_id = %@",replyCommentParam.user_id);
                NSLog(@"replyCommentParam.comment_id = %@",replyCommentParam.comment_id);
//                NSLog(@"replyCommentParam.photo_id = %@",replyCommentParam.photo_id);
//                NSLog(@"replyCommentParam.discuss = %@",replyCommentParam.discuss);
                NSLog(@"replyCommentParam.group_id = %@",replyCommentParam.group_id);
                NSLog(@"replyCommentParam.comment_user_id = %@",replyCommentParam.comment_user_id);
                
                [self showHoldView];
                [MZRequestManger replyCommentRequest:replyCommentParam success:^(NSDictionary *object) {
                    [weakSelf hideHUD];
                    MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
                    if ([response.errMsg isEqualToString:@"账号冻结"]) {
                        return ;
                    }
                    _isReply=FALSE;
                    _isFirst = NO;
                    _faceReply = YES;
                    _tableView.frame = CGRectZero;
                    _oldHeight = _totalHeight;
                    [self hiddenKeyboard];
                    [self initData];
                } failure:^(NSString *errMsg, NSString *errCode) {
                    [weakSelf hideHUD];
                }];
            }else{
                MZAddCommentParam *addCommen = [[MZAddCommentParam alloc]init];
                addCommen.user_id = [userdefaultsDefine objectForKey:@"user_id"];
                addCommen.issue_id = self.issue_id;
                addCommen.discuss = text;
                addCommen.issue_user_id = _photoDetailModel.issue_user_id;
                addCommen.album_id = self.album_id;
                [self showHoldView];
                [MZRequestManger addCommentRequest:addCommen success:^(NSDictionary *object) {
                    [weakSelf hideHUD];
                    MZBaseResponse *response = [[MZBaseResponse alloc] initWithDictionary:object];
                    if ([response.errMsg isEqualToString:@"账号冻结"]) {
                        return ;
                    }
                    _isFirst = NO;
                    _tableView.frame = CGRectZero;
                    _oldHeight = _totalHeight;
                    [self hiddenKeyboard];
                    [self initData];
                } failure:^(NSString *errMsg, NSString *errCode) {
                    [weakSelf hideHUD];
                }];

            }
    //        ((MDWCommentListViewDataSource *)self.dataSource).listModel.commentListModelDelegate = self;
    //        //        [((MDWCommentListViewDataSource *)self.dataSource).listModel sendCommentData:self.statusid comment:inputString];
    //        [((MDWCommentListViewDataSource *)self.dataSource).listModel sendCommentData:self.statusid type:self.type touserid:self.touserid text:text];
    //        _input.text=@"";
    //        [self dismissKeyboard];
    //        //        [self loadFirstPage];
    //        [self reloadDataAndView];
         

        }
}

-(void)hiddenKeyboard{
    //    _isReply=FALSE;
    //    self.touserid=@"";
    //    self.type=@"0";
    _placeholder.hidden=YES;
    _input.text=@"";
    [_input resignFirstResponder];
    
    [UIView animateWithDuration:Time animations:^{
        _tabBar.frame = CGRectMake(0.0f, SCREEN_HEIGHT-toolBarHeight-64.0f, self.view.frame.size.width, toolBarHeight);
        [_scrollView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, keyboardHeight)];
    }];
    [_pageControl setHidden:YES];
    _keyboardIsShow = YES;
    [_faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];

}


#pragma mark ----- UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"_placeholder == %@",_placeholder.text);
    if (textView.text.length == 0&&_isReply==TRUE) {
        _placeholder.text = @"回复";
        _placeholder.hidden=NO;
    }else{
        _placeholder.text = @"";
        _placeholder.hidden=YES;
    }
}


#pragma mark ------ DynamicCommentTableViewCellDelegate

//- (void)setNickName:(NSString *)nickname toUserid:(NSString *)toUserid
//{
//    _isReply=TRUE;
//    self.touserid=toUserid;
//    self.tonick = nickname;
//    self.type=@"2";
//    _placeholder.text=[@"回复 " stringByAppendingString:nickname];
//    _placeholder.hidden=NO;
//    [_input becomeFirstResponder];
//}



- (void)replyWithNickName:(NSString *)nickname comment_id:(NSString *)comment_id group_id:(NSString *)group_id comment_user_id:(NSString *)comment_user_id
{
    _isReply=TRUE;
    _faceReply = NO;
    self.comment_id=comment_id;
    self.group_id = group_id;
    self.comment_user_id = comment_user_id;
    self.tonick = nickname;
    self.type=@"2";
    _placeholder.text=[@"回复 " stringByAppendingString:nickname];
    _placeholder.hidden=NO;
    [_input becomeFirstResponder];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"照片详情页"];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self hiddenKeyboard];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"照片详情页"];
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
