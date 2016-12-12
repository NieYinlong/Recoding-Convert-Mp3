//
//  CommonMethod.h
//  LaiYiShou
//
//  Created by necsthz on 15-4-7.
//  Copyright (c) 2015年 liuxiaolong. All rights reserved.
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

//获取当前ios版本
+ (float)getIOSVersion;

//判断设备类型
+ (DEVICETYPE)deviceType;

//取设备的UUID
+ (void)setUUID;

// 正则判断手机号码地址格式
+(BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)validateEmail:(NSString *)email;

//判断是否为纯数字
+(BOOL)isPureNumandCharacters:(NSString *)string;
//判断是否为空字符串
+(BOOL)isBlankString:(NSString *)string;
//判断如果字符串时空则转化成空字符串（防止出现空指针异常）
+(NSString *)changeStringNullToBlank:(NSString *)string;

//md5加密
+(NSString *)md5:(NSString *)str;
//保存图片
+(BOOL)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
//获取Documents
+(NSString *)documentFolderPath;

// 移除字符串首尾空格
+ (NSString *)removeHeadAndFootSpaceWithString:(NSString *)string;


+(id)changeType:(id)myObj;



+(void)reLoad:(UIViewController*)viewController;

#pragma mark - 点击图片放大预览图片
+ (void)showImage:(NSString *)imageUrl;
+ (void)hideImage:(UITapGestureRecognizer*)tap;
+(void)showAlterMessage:(NSString*)text;

//输入框设置左间隔
+ (void) setLeftViewInTextField: (UITextField *)textField;
//压缩图片
+ (UIImage *)reduceImage:(UIImage *)image percent:(float)percent;
//通过尺寸压缩图片
+ (UIImage*)imageWithImageSimpleBySize:(UIImage*)image scaledToSize:(CGSize)newSize;
//图片安指定尺寸比率压缩图片 最小尺寸为100(宽或长的其中一个)
+ (UIImage*)imageWithImageSimpleByPercent:(UIImage*)image percent:(float)percent;

// 提醒框
+ (void)alterWhithString:(NSString *)str;




//// 判断字符串非空, 如果为空就转成 @""
+ (NSString *)judgeStringNull:(NSString *)str;

// 生成uuid
+ (NSString*) getUUIDString;


#pragma mark - 价格字符串保留两位小数
+ (NSString *)priceKeepTwoDecimalPlacesWithPrice:(NSString *)price;


//设备网络状态检查
+(BOOL)isNetworkConnectState;

#pragma mark - 自定义导航条
//+ (void)addDIYNavgationBarWithTitle:(NSString *)title mySelf:(UIViewController *)mySelf;

#pragma mark - 旋转图片
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;


#pragma mark -  自动消失提示框的 弹框
+ (void)showAlertAutoDismiss:(UIViewController *)mySelf msg:(NSString *)msg;




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






/// 先来个autoSize, 让控制器里面的cell去调用
+ (void)autoSizeFontSize:(CGFloat)fontSize lable:(UILabel *)label ;




// 给我一个字符串 我还你一个高度
+ (CGFloat)cellWithStr:(NSString *)str fontSize:(CGFloat)fontSize width:(CGFloat)width;




/**
 *  给一个时间戳, 返回一个距离现在的时间
 *
 *  @param shijianCuo model里面的时间戳
 *
 *  @return 返回一个距离现在的时间
 */
+ (NSString *)timeIntervalStr:(NSString *)shijianCuo;


/*!
 
 * @brief 把格式化的JSON格式的字符串转换成字典
 
 * @param jsonString JSON格式的字符串
 
 * @return 返回字典
 
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 *  objective-C不支持16进制的颜色表示，需要转换成rgb表示法
 *
 *  @param hexColor 十六进制字符串
 *
 *  @return UIColor对象
 */
+( UIColor *) getColor:( NSString *)hexColor;


/**
 *  键盘添加完成按钮
 *
 *  @param view <#view description#>
 */
- (void)addToolBarForKeyBoard:(id)view;



/**
 *  打开相机
 *
 *  @param VC 传过来的控制器
 */
+ (void)openCameraWithVC:(id)VC;
/**
 *  选取本地照片
 */
+ (void)selectLocalPhotoWithVC:(id)VC;

/**
 *  时间戳转日期字符串
 *  @param timeStamp 时间戳字符串
 *  @return 日期字符串
 */
+ (NSString *)dataStrFromTimeStamp:(NSString *)timeStamp;

/**
 *  比较两个日期的先后顺序
 *
 *  @param oneDay     时间1
 *  @param anotherDay 时间2
 *
 *  @return 1: 时间1是未来的时间;  返回-1:时间1是过去的时间;  返回0:两个时间相等
 */
+(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


/**
 *  比较两个日期的先后顺序
 *  @param oneDateStr     时间1字符串
 *  @param anotherDateStr 时间2字符串
 *
 *  @return 1: 时间1是未来的时间;  返回-1:时间1是过去的时间;  返回0:两个时间相等
 */
+ (int)compareOneDateStr:(NSString *)oneDateStr withAnotherDateStr:(NSString *)anotherDateStr;



/*
 *分隔字符窜返回一个数组
 *
 */
+ (NSArray *)stringWithArray:(NSString *)string;


//#pragma 正则匹配用户身份证号15或18位
+ (BOOL)validateIdentityCard: (NSString *)identityCard;
// 验证电话号码或者手机号
+ (BOOL)validPhoneNumOrTelphoneNum:(NSString *)phoneNum;


//控制桌面角标提醒
+ (void)changeBadgeNumber:(BOOL)isChat badgeNumber:(NSInteger)number;

// 调整行间距
+ (void)autoSpaceMarginLabel:(UILabel *)contentLabel margin:(CGFloat)margin;
// 高度
+ (CGFloat)getSpaceLabelHeightWithStr:(NSString*)str withFontSize:(CGFloat)fontSize margin:(CGFloat)margin withWidth:(CGFloat)width;

// 清除document
+ (void)removeDocumentItemAtPath:(NSString *)path;

@end
