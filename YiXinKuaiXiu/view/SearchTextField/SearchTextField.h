//
//  SearchTextField.h
//  LocationDemo
//
//  Created by City--Online on 15/11/30.
//  Copyright © 2015年 City--Online. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  void(^LeftBtnClickBlock)();

@interface SearchTextField : UITextField

@property (nonatomic,strong) NSString *leftTitle;

@property (nonatomic,copy)   LeftBtnClickBlock btnClickBlock;

-(instancetype)initNoLeftTitleWithFrame:(CGRect)frame;
@end


