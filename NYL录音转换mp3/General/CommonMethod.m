//
//  CommonMethod.m
//  LaiYiShou
//
//  Created by necsthz on 15-4-7.
//  Copyright (c) 2015年 yinlongNie. All rights reserved.
//

#import "CommonMethod.h"
#import "sys/utsname.h"
#import <UIKit/UIKit.h>

#import <CommonCrypto/CommonDigest.h>

#import "AppDelegate.h"
#import <UIKit/UIKit.h>

//#import "LoginVC.h"
#import "UIView+WLFrame.h"

#define MAIN_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define MAIN_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


@interface CommonMethod ()<UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIView *dismissView;

@end

@implementation CommonMethod

//***************************

//***************************





// *  objective-C不支持16进制的颜色表示，需要转换成rgb表示法
+( UIColor *) getColor:( NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range. length = 2 ;
    range. location = 0 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&red];
    range. location = 2 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
    range. location = 4 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&blue];
    
    return [ UIColor colorWithRed :( float )(red/ 255.0f ) green :( float )(green/ 255.0f ) blue :( float )(blue/ 255.0f ) alpha : 1.0f ];
}



+ (void)alterWhithString:(NSString *)str
{
    UIAlertController *alterVC = [[UIAlertController alloc] init];
    UIAlertAction *action = [UIAlertAction actionWithTitle:str style:(UIAlertActionStyleDefault) handler:nil];
    [alterVC addAction:action];
    
}






#pragma mark -  自动消失提示框的 弹框
+ (void)showAlertAutoDismiss:(UIViewController *)mySelf msg:(NSString *)msg
{
    
        UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:msg  preferredStyle:(UIAlertControllerStyleAlert)];
        
        [mySelf presentViewController:alterVC animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alterVC dismissViewControllerAnimated:YES completion:nil];
        });

}


#pragma mark - 封装的创建label
+ (UILabel *)createLabel:(UILabel *)label whoViewAdd:(UIView *)view text:(NSString *)text fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
    label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = text;
    label.font = [UIFont systemFontOfSize:fontSize];
   
//    label.backgroundColor = kMainColor;
//    label.alpha = 0.6;
    
    if (label) {
        
        if (view) {
            [view addSubview:label];
        }
        
        
    }
   //label.backgroundColor = [UIColor colorWithRed:0.181 green:1.000 blue:0.669 alpha:0.323];

    return label;
}

#pragma mark - 封装的创建textField
+ (UITextField *)createTextField:(UITextField *)textField whoViewAdd:(UIView *)view frame:(CGRect)frame  placehold:(NSString *)placehold
{
    textField = [[UITextField alloc] init];
    textField.placeholder = placehold;
    textField.frame = frame;
    textField.layer.borderColor = [UIColor colorWithRed:0.860 green:0.862 blue:0.895 alpha:1.000].CGColor;
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    [view addSubview:textField];
   // textField.backgroundColor = [UIColor colorWithRed:0.537 green:1.000 blue:0.061 alpha:1.000];
    return textField;
}

#pragma mark - 封装的button
+ (UIButton *)createButtonWithButton:(UIButton *)btn whoViewAdd:(UIView *)view title:(NSString *)title imageStr:(NSString *)imageStr fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
    
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    [btn setBackgroundImage:[UIImage imageNamed:imageStr] forState:(UIControlStateNormal)];
    [btn setTitle:title forState:(UIControlStateNormal)];

    [btn setBackgroundImage:[UIImage imageNamed:imageStr] forState:(UIControlStateNormal)];
  
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [view addSubview:btn];
    
    //btn.backgroundColor = kMainColor;
    
    return btn;
}

+ (UIButton *)ycreateButtonWithButton:(UIButton *)btn whoViewAdd:(UIView *)view title:(NSString *)title imageStr:(UIImage *)image fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
    btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = frame;
    [btn setBackgroundImage:image forState:(UIControlStateNormal)];
    [btn setTitle:title forState:(UIControlStateNormal)];
    
    [btn setBackgroundImage:image forState:(UIControlStateNormal)];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [view addSubview:btn];
    return btn;
    
}
#pragma mark - UIImageView
+ (UIImageView *)createImageView:(UIImageView *)imageView whoViewAdd:(UIView *)view  frame:(CGRect)frame imageName:(NSString *)imageName
{
    imageView = [[UIImageView alloc] init];
    imageView.frame = frame;
    imageView.image = [UIImage imageNamed:imageName];
    [view addSubview:imageView];
    return imageView;
}


+ (UITextView *)createTextView:(UITextView *)textView whoViewAdd:(UIView *)view frame:(CGRect)frame  placehold:(NSString *)placehold
{
    textView = [[UITextView alloc] initWithFrame:frame];
    
    textView.layer.borderWidth = 1;
    //textView.layer.borderColor = kBorderColor_E8.CGColor;
    
    [view addSubview:textView];
    
    return textView;
}


+ (UIView *)createView:(UIView *)view whoViewAdd:(UIView *)superView frame:(CGRect)frame {
    view = [[UIView alloc] initWithFrame:frame];
    [superView addSubview:view];
    return view;
}






@end
