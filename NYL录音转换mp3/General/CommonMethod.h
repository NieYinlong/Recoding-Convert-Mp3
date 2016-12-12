//
//  CommonMethod.h
//  LaiYiShou
//
//  Created by necsthz on 15-4-7.
//  Copyright (c) 2015年 yinlongNie. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface  CommonMethod : NSObject

//设备类型
typedef enum {
    iPhone4or4S = 0,
    iPhone5or5S,
    iPhone6,
    iPhone6Plus,
}DEVICETYPE;





+(void)showAlterMessage:(NSString*)text;

#pragma mark - 封装的创建label
+ (UILabel *)createLabel:(UILabel *)label whoViewAdd:(UIView *)view text:(NSString *)text fontSize:(CGFloat)fontSize frame:(CGRect)frame;
#pragma mark - 封装的创建textField
+ (UITextField *)createTextField:(UITextField *)textField whoViewAdd:(UIView *)view frame:(CGRect)frame  placehold:(NSString *)placehold;

#pragma mark - 封装的button
+ (UIButton *)createButtonWithButton:(UIButton *)btn whoViewAdd:(UIView *)view title:(NSString *)title imageStr:(NSString *)imageStr fontSize:(CGFloat)fontSize frame:(CGRect)frame;

+ (UIImageView *)createImageView:(UIImageView *)imageView whoViewAdd:(UIView *)view  frame:(CGRect)frame imageName:(NSString *)imageName;

+ (UITextView *)createTextView:(UITextView *)textView whoViewAdd:(UIView *)view frame:(CGRect)frame  placehold:(NSString *)placehold;

+ (UIButton *)ycreateButtonWithButton:(UIButton *)btn whoViewAdd:(UIView *)view title:(NSString *)title imageStr:(UIImage *)image fontSize:(CGFloat)fontSize frame:(CGRect)frame;

+ (UIView *)createView:(UIView *)view whoViewAdd:(UIView *)superView frame:(CGRect)frame;


/**
 *  objective-C不支持16进制的颜色表示，需要转换成rgb表示法
 *
 *  @param hexColor 十六进制字符串
 *
 *  @return UIColor对象
 */
+( UIColor *) getColor:( NSString *)hexColor;




@end
