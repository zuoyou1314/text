//
//  MZWeChatViewController.m
//  MZTuShenMa
//
//  Created by zuo on 15/10/20.
//  Copyright (c) 2015年 killer. All rights reserved.
//

#import "MZWeChatViewController.h"
#import "MZCommentTableViewCell.h"
#import "MZReplyTableViewCell.h"
#import "MZJoinAlbumTableViewCell.h"
#import "MZGoodTableViewCell.h"
#import "MZAboutMeReplyTableViewCell.h"
#import "MJRefresh.h"
#import "MZGroupListParam.h"
#import "MZGroupListModel.h"

#import "FaceToolBar.h"
#import "MZReplyCommentParam.h"

#import "MZAddGroupParam.h"
#import "MZReplyGroupParam.h"

#import "MZGroupReplyModel.h"
#import "MZDynamicDetailViewController.h"
#import "MZDynamicViewController.h"
//#import "UITableView+FDTemplateLayoutCell.h"
@interface MZWeChatViewController ()<UITableViewDelegate,UITableViewDataSource,facialViewDelegate,UITextViewDelegate,MZReplyTableViewCellDelegate,MZCommentTableViewCellDelegate>
{
    UITableView *_tableView;
    NSInteger _page;
    NSMutableArray *_modelArray;

    UIView *_tabBar;
    UITextView *_input;
    UILabel *_placeholder;
    UIButton *_sendButton;
    
    BOOL _keyboardIsShow;//键盘是否显示
    UIButton *_faceButton;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    
    BOOL _isReply; //是否为回复
    BOOL _faceReply;//判断添加表情后,是否还是回复
    NSUInteger _lastPosition;//检测TableView的滚动方向
}
@end

@implementation MZWeChatViewController

static NSString * const commentCellIdentifier = @"commentCell";
static NSString * const replyCellIdentifier = @"replyCell";
static NSString * const joinAlbumCellIdentifier = @"joinAlbumCell";
static NSString * const goodCellIdentifier = @"goodCell";
static NSString * const aboutMeReplyCellIdentifier = @"aboutMeReplyCell";

- (instancetype)initWithAlbum_id:(NSString *)album_id album_name:(NSString *)album_name
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.album_id = album_id;
        self.album_name = album_name;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initData];
    [self createTabbarView];
    _faceReply = YES;
}

- (void)initUI
{
//    self.view.backgroundColor = UIColorFromRGB(0xf4f4f4);
//    self.view.backgroundColor = [UIColor redColor];
    _tableView = [[UITableView alloc]initWithFrame:rect(0, 64+40, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f-toolBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(244, 244, 244);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 40000;
//    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册标识
    [_tableView registerNib:[UINib nibWithNibName:@"MZCommentTableViewCell" bundle:nil] forCellReuseIdentifier:commentCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"MZReplyTableViewCell" bundle:nil] forCellReuseIdentifier:replyCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"MZJoinAlbumTableViewCell" bundle:nil] forCellReuseIdentifier:joinAlbumCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"MZGoodTableViewCell" bundle:nil] forCellReuseIdentifier:goodCellIdentifier];
    [_tableView registerNib:[UINib nibWithNibName:@"MZAboutMeReplyTableViewCell" bundle:nil] forCellReuseIdentifier:aboutMeReplyCellIdentifier];
    [self.view addSubview:_tableView];
    
}


//创建底部的Tabbar
- (void)createTabbarView
{
    _keyboardIsShow = YES;
    
    _tabBar=[[UIView alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height-toolBarHeight, self.view.frame.size.width, toolBarHeight)];
    _tabBar.backgroundColor=RGB(235, 236, 237);
    [self.view addSubview:_tabBar];
    
    UIView *lineView = [[UIView alloc]initWithFrame:rect(0, 0, SCREEN_WIDTH, 0.5)];
    lineView.backgroundColor = RGB(206, 206, 206);
    [_tabBar addSubview:lineView];
    
    
    _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _faceButton.frame = rect(10.0f, 0.0f, 30.0f, toolBarHeight);
    [_faceButton setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    [_faceButton addTarget:self action:@selector(didClickFaceButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_tabBar addSubview:_faceButton];
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, keyboardHeight)];
    [_scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
    for (int i=0; i<9; i++) {
        FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*i, 15, SCREEN_WIDTH, facialViewHeight)];
        if (iPhone6P) {
            [fview loadFacialView:i size:CGSizeMake(43, 43)];
        }else if (iPhone6){
            [fview loadFacialView:i size:CGSizeMake(38, 43)];
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
    _scrollView.tag = 40001;
    [self.view addSubview:_scrollView];
    
    _pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(_scrollView.center.x-75.0f, self.view.frame.size.height-30, 150, 30)];
    [_pageControl setCurrentPage:0];
    _pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
    _pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    _pageControl.numberOfPages = 9;//指定页面个数
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    [_pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    _pageControl.hidden=YES;
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
    
    _placeholder=[[UILabel alloc] initWithFrame:CGRectMake(48.0f, 0.0f, self.view.frame.size.width-110.0f, toolBarHeight)];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShownOfWeChat:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHideOfWeChat:) name:UIKeyboardWillHideNotification object:nil];
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


-(void)sendAction{
    
    NSString *text=_input.text;
    if (![text isEqualToString:@""]&&text!=nil&&([text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length!=0)){
        __weak typeof(self) weakSelf = self;
        if (_isReply==TRUE) {
            MZReplyGroupParam *replyGroupParam = [[MZReplyGroupParam alloc]init];
            replyGroupParam.album_id = self.album_id;
            replyGroupParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
            replyGroupParam.discuss = text;
            replyGroupParam.group_id = self.group_id;
            
            
            NSLog(@"replyGroupParam.album_id == %@",replyGroupParam.album_id);
            NSLog(@"replyGroupParam.user_id == %@",replyGroupParam.user_id);
            NSLog(@"replyGroupParam.discuss == %@",replyGroupParam.discuss);
            NSLog(@"replyGroupParam.group_id == %@",replyGroupParam.group_id);
            
            [self showHoldView];
            [MZRequestManger replyGroupRequest:replyGroupParam success:^(NSDictionary *object) {
                [weakSelf hideHUD];
                _isReply=FALSE;
                _faceReply = YES;
                [self hiddenKeyboard];
                [self initData];
            } failure:^(NSString *errMsg, NSString *errCode) {
                [weakSelf hideHUD];
            }];
        }else{
            
            MZAddGroupParam *addGroupParam = [[MZAddGroupParam alloc]init];
            addGroupParam.album_id = self.album_id;
            addGroupParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
            addGroupParam.discuss = text;
            [self showHoldView];
            [MZRequestManger addGroupRequest:addGroupParam success:^(NSDictionary *object) {
                [weakSelf hideHUD];
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

- (void)keyboardWasShownOfWeChat:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        _tabBar.frame = CGRectMake(0, SCREEN_HEIGHT-keyboardF.size.height-toolBarHeight, SCREEN_WIDTH, toolBarHeight);
        NSLog(@"oooo = %f",keyboardF.size.height);
    }];
    NSLog(@"_tabBar1111 = %@",_tabBar);
}

- (void)keyboardWasHideOfWeChat:(NSNotification *)notification{
    if (![_placeholder.text isEqualToString:@""] || ![_placeholder.text isKindOfClass:[NSNull class]]) {
        _isReply=FALSE;
    }
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        _tabBar.frame =CGRectMake(0.0f, SCREEN_HEIGHT-toolBarHeight, self.view.frame.size.width, toolBarHeight);
        NSLog(@"dsvmlnvsnv");
    }];
}


-(void)hiddenKeyboard{
    //    _isReply=FALSE;
    //    self.touserid=@"";
    //    self.type=@"0";
    _placeholder.hidden=YES;
    _input.text=@"";
    [_input resignFirstResponder];
    
    [UIView animateWithDuration:Time animations:^{
//        _tabBar.frame = CGRectMake(0.0f, self.view.frame.size.height-toolBarHeight, self.view.frame.size.width, toolBarHeight);
        _tabBar.frame = CGRectMake(0.0f, self.view.frame.size.height-toolBarHeight, self.view.frame.size.width, toolBarHeight);
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



- (void)initData
{
    __weak __typeof(self) weakSelf = self;
    _page =1;
    // 下拉刷新
    _tableView.header = [MJChiBaoZiHeader headerWithRefreshingBlock:^{
        _page =1;
        [weakSelf initDataWithPage:_page];
    }];
    // 马上进入刷新状态
    [_tableView.header beginRefreshing];
    // 上拉加载更多
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakSelf initDataWithPage:_page];
    }];

}

- (void)initDataWithPage:(NSInteger)page
{
    MZGroupListParam *groupListParam = [[MZGroupListParam alloc]init];
    groupListParam.album_id = self.album_id;
    groupListParam.user_id = [userdefaultsDefine objectForKey:@"user_id"];
    groupListParam.page = page;
    NSLog(@"self.album_id == %@, user_id == %@",self.album_id,[userdefaultsDefine objectForKey:@"user_id"]);
    [MZRequestManger groupListRequest:groupListParam success:^(NSArray *groupChatLists) {
        if (_page == 1) {
            [_modelArray removeAllObjects];
            _modelArray = [NSMutableArray arrayWithCapacity:groupChatLists.count];
        }
        for (NSDictionary *dic in groupChatLists) {
            MZGroupListModel *groupListModel = [MZGroupListModel objectWithKeyValues:dic];
            //            if (page == 1) {
            //                [_modelArray insertObject:dataModel atIndex:0];
            //            }else{
            [_modelArray addObject:groupListModel];
            //            }
            //            for (MZImageListsModel *imageListsModel in dataModel.img_lists) {
            //                [_imageArray addObject:imageListsModel];
            //            }
        }
        [self endRefreshing];
    } failure:^(NSString *errMsg, NSString *errCode) {
        [self endRefreshing];
    }];
}

- (void)endRefreshing
{
    // 刷新表格
    [_tableView reloadData];
    
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}


#pragma mark -----UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZGroupListModel *groupListModel = [_modelArray objectAtIndex:indexPath.row];
    if ([groupListModel.type isEqualToString:@"1"]) {
        if ([groupListModel.desc isEqualToString:@"回复"]) {
            if ([MZReplyTableViewCell getDiscussHeightWith:groupListModel]>14.31) {
                return 142.0f+([MZReplyTableViewCell getDiscussHeightWith:groupListModel]-14.31);
            }else{
                 return 142.0f;
            }
        }else{
            if ([MZCommentTableViewCell getDiscussHeightWith:groupListModel]>14.31) {
                return 70.0f+([MZCommentTableViewCell getDiscussHeightWith:groupListModel]-14.31);
            }else{
                return 70.0f;
            }
        }
    }else if([groupListModel.type isEqualToString:@"4"]) {
        return 30.0f;
    }else{
        return 90.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZGroupListModel *groupListModel = [_modelArray objectAtIndex:indexPath.row];
    if ([groupListModel.type isEqualToString:@"1"]) {
        if ([groupListModel.desc isEqualToString:@"回复"]) {
            MZReplyTableViewCell *replyCell = [tableView dequeueReusableCellWithIdentifier:replyCellIdentifier forIndexPath:indexPath];
            replyCell.delegate = self;
            replyCell.album_id = _album_id;
            replyCell.album_name = _album_name;
            if ([groupListModel.user_id isEqualToString:[userdefaultsDefine objectForKey:@"user_id"]] && replyCell.replyButton.tag == 60001) {
                replyCell.replyButton.hidden = YES;
            }else{
                replyCell.replyButton.hidden = NO;
            }
            replyCell.groupListModel = groupListModel;
           
//            replyCell.selectedBackgroundView = [[UIView alloc] initWithFrame:replyCell.frame];
//            replyCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
            return replyCell;
        }else{
            MZCommentTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:commentCellIdentifier forIndexPath:indexPath];
            commentCell.groupListModel = groupListModel;
            commentCell.delegate = self;
            commentCell.album_id = _album_id;
            commentCell.album_name = _album_name;
            if ([[userdefaultsDefine objectForKey:@"user_id"] isEqualToString:groupListModel.user_id] && commentCell.replyButton.tag == 60000) {
                commentCell.replyButton.hidden = YES;
            }else{
                commentCell.replyButton.hidden = NO;
            }
//            commentCell.selectedBackgroundView = [[UIView alloc] initWithFrame:commentCell.frame];
//            commentCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
            return commentCell;
        }
    }else if ([groupListModel.type isEqualToString:@"2"]){
        MZGoodTableViewCell *goodCell = [tableView dequeueReusableCellWithIdentifier:goodCellIdentifier forIndexPath:indexPath];
        goodCell.groupListModel = groupListModel;
//    [self configureCell:goodCell atIndexPath:indexPath];
         if (indexPath.row+1<_modelArray.count) {
             MZGroupListModel *nextGroupListModel = [_modelArray objectAtIndex:indexPath.row+1];
             if ([nextGroupListModel.type isEqualToString:@"2"]) {
                 goodCell.lineView.hidden = YES;
             }

         }
//        goodCell.selectedBackgroundView = [[UIView alloc] initWithFrame:goodCell.frame];
//        goodCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
             return goodCell;
    }else if ([groupListModel.type isEqualToString:@"3"]){
        MZAboutMeReplyTableViewCell *aboutMeReplyCell = [tableView dequeueReusableCellWithIdentifier:aboutMeReplyCellIdentifier forIndexPath:indexPath];
        aboutMeReplyCell.groupListModel = groupListModel;
        if (indexPath.row+1<_modelArray.count) {
            MZGroupListModel *nextGroupListModel = [_modelArray objectAtIndex:indexPath.row+1];
            if ([nextGroupListModel.type isEqualToString:@"2"] || [nextGroupListModel.type isEqualToString:@"3"]) {
                aboutMeReplyCell.lineView.hidden = YES;
            }
        }
       
//        [self configureCell:aboutMeReplyCell atIndexPath:indexPath];
//        aboutMeReplyCell.selectedBackgroundView = [[UIView alloc] initWithFrame:aboutMeReplyCell.frame];
//        aboutMeReplyCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        return aboutMeReplyCell;
    }else{
        MZJoinAlbumTableViewCell *joinAlbumCell = [tableView dequeueReusableCellWithIdentifier:joinAlbumCellIdentifier forIndexPath:indexPath];
        joinAlbumCell.groupListModel = groupListModel;
//        joinAlbumCell.selectedBackgroundView = [[UIView alloc] initWithFrame:joinAlbumCell.frame];
//        joinAlbumCell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:244/255.0f green:244.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        
        return joinAlbumCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self hiddenKeyboard];
    
    //当手指离开某行时，就让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MZGroupListModel *groupListModel = [_modelArray objectAtIndex:indexPath.row];
    if ([groupListModel.type isEqualToString:@"3"] || [groupListModel.type isEqualToString:@"2"]) {
        MZDynamicDetailViewController *dynamicDetailVC = [[MZDynamicDetailViewController alloc]init];
        dynamicDetailVC.album_id = self.album_id;
        dynamicDetailVC.album_name = _album_name;
        dynamicDetailVC.issue_id = groupListModel.issue_id;
        dynamicDetailVC.albumType = DynamicDetailViewControllerTypeNormal;
        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    }
}


//- (void)configureCell:(MZGoodTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.fd_enforceFrameLayout = NO;
//    MZGroupListModel *groupListModel = [_modelArray objectAtIndex:indexPath.row];
////    if ([groupListModel.type isEqualToString:@"3"]) {
//        cell.groupListModel = groupListModel;
////    }
//    
//}


#pragma mark ----- UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UITableView *)scrollView
{
    if (scrollView.tag == 40000) {
         [self hiddenKeyboard];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 40001) {
        int page = _scrollView.contentOffset.x / SCREEN_WIDTH;//通过滚动的偏移量来判断目前页面所对应的小白点
        _pageControl.currentPage = page;//pagecontroll响应值的变化
    }
    
    int currentPostion = _tableView.contentOffset.y;
    NSLog(@"currentPostion == %d",currentPostion);
    MZDynamicViewController *dynamicVC = (MZDynamicViewController *)self.parentViewController;
    if (currentPostion - _lastPosition > 25) {
        _lastPosition = currentPostion;
        
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.frame = rect(0,40+64, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f);
            dynamicVC.segmentedControl.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
            dynamicVC.lineLabel.frame = rect(0, 64+40, SCREEN_WIDTH, 0.5);
        }];
        NSLog(@"ScrollUp now  向上滑");
    }
    else if (_lastPosition - currentPostion > 25)
    {
        _lastPosition = currentPostion;
        
        NSLog(@"ndvnlvn == %f",_tableView.contentSize.height);
        if (currentPostion > 100 && currentPostion< _tableView.contentSize.height-SCREEN_HEIGHT-64) {
            [UIView animateWithDuration:0.5 animations:^{
                _tableView.frame = rect(0,40+64-40, SCREEN_WIDTH, SCREEN_HEIGHT-64.0f);
                dynamicVC.segmentedControl.frame = CGRectMake(0, 64-64, SCREEN_WIDTH, 40);
                dynamicVC.lineLabel.frame = rect(0, 64+40-64, SCREEN_WIDTH, 0.5);
            }];
        }
        NSLog(@"ScrollDown now  向下滑");
    }

}



- (void)clickReplyButtonAction:(UIButton *)button group_id:(NSString *)group_id nickname:(NSString *)nickname;
{
    _isReply=TRUE;
    _faceReply = NO;
    self.group_id = group_id;
    self.tonick = nickname;
    _placeholder.text=[@"回复 " stringByAppendingString:nickname];
    _placeholder.hidden=NO;
    [_input becomeFirstResponder];
}

- (void)clickCommentButtonAction:(UIButton *)button group_id:(NSString *)group_id nickname:(NSString *)nickname
{
    _isReply=TRUE;
    _faceReply = NO;
    self.group_id = group_id;
    self.tonick = nickname;
    _placeholder.text=[@"回复 " stringByAppendingString:nickname];
    _placeholder.hidden=NO;
    [_input becomeFirstResponder];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
        [self hiddenKeyboard];
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
