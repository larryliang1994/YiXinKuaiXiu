////
////  SearchTextField.m
////  LocationDemo
////
////  Created by City--Online on 15/11/30.
////  Copyright © 2015年 City--Online. All rights reserved.
////
//
//#import "SearchTextField.h"
//
//@interface SearchTextField ()
//
//@property (nonatomic,strong) UIButton *leftBtn;
//
//@property (nonatomic,strong) UIImageView *leftImgView;
//
//@property (nonatomic,strong) UIImageView *searchImgView;
//
//@property (nonatomic,assign) BOOL isNoLeftTitle;
//@end
//
//@implementation SearchTextField
//-(instancetype)initNoLeftTitleWithFrame:(CGRect)frame
//{
//    _isNoLeftTitle=YES;
//    return [self initWithFrame:frame];
//}
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        self.layer.cornerRadius=5;
//        self.layer.borderWidth=0.5;
//        self.layer.borderColor=C;
//        self.leftViewMode=UITextFieldViewModeAlways;
//        self.clearButtonMode=UITextFieldViewModeWhileEditing;
//        self.backgroundColor=[UIColor whiteColor];
//        
//        self.leftView=[[UIView alloc]init];
//        
//        _leftBtn =[UIButton buttonWithType:UIButtonTypeSystem];
//        [_leftBtn addTarget:self action:@selector(btnClickHandle:) forControlEvents:UIControlEventTouchUpInside];
//        [_leftBtn setTitleColor:XQBColorTextMostLight forState:UIControlStateNormal];
//        [_leftBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//        
//        _leftImgView=[[UIImageView alloc]init];
//        _leftImgView.image=[UIImage imageNamed:@"login_location_down.png"];
//        [_leftBtn addSubview:_leftImgView];
//        
//        [self.leftView addSubview:_leftBtn];
//        
//        _searchImgView=[[UIImageView alloc]init];
//        _searchImgView.image=[UIImage imageNamed:@"login_location_search.png"];
//        [self.leftView addSubview:_searchImgView];
//        
//    }
//    return self;
//}
//
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    if (_isNoLeftTitle) {
//        self.leftView.frame=CGRectMake(0, 0, 35, self.frame.size.height);
//        _leftBtn.frame=CGRectMake(0, 0, 0, 0);
//        
//        _leftImgView.frame=CGRectMake(0, 0, 0, 0);
//        _searchImgView.frame=CGRectMake(10, (self.frame.size.height-15)/2, 15, 15);
//    }
//    else{
//        NSDictionary *attributes=@{NSFontAttributeName: XQBFontMiddle};
//        CGRect titleFrame=[_leftTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
//        
//        
//        self.leftView.frame=CGRectMake(0, 0, 62+titleFrame.size.width, self.frame.size.height);
//        
//        _leftBtn.frame=CGRectMake(10, 0, titleFrame.size.width+22, self.frame.size.height);
//        
//        [_leftBtn setTitle:_leftTitle forState:UIControlStateNormal];
//        
//        _leftImgView.frame=CGRectMake(titleFrame.size.width+10, (self.frame.size.height-5)/2, 10, 5);
//        
//        _searchImgView.frame=CGRectMake(titleFrame.size.width+37, (self.frame.size.height-15)/2, 15, 15);
//    }
//    
//}
//
//-(void)btnClickHandle:(id)sender
//{
//    _btnClickBlock();
//}
//
//-(void)setLeftTitle:(NSString *)leftTitle
//{
//    _leftTitle=leftTitle;
//    _isNoLeftTitle=NO;
//    [self setNeedsLayout];
//}
//@end
//
