//
//  NSString+ExtendMethod.h
//  YuanXin_Project
//
//  Created by Yuanin on 16/6/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

typedef NS_ENUM(NSInteger, HideStringPartPosition) {
    
    kHideStringCenter,
    kHideStringLeft,
    kHideStringRight,
};

@interface NSString (ExtendMethod)

/**
 *  将 string 进行 32位MD5加密
 *
 *
 *  @return 加密过的String
 */
- (NSString *)MD5Encryption;


/**
 AES解密

 @param key key
 @param text value
 @return 解密结果
 */
+(NSString *) aes256_decrypt:(NSString *)key Decrypttext:(NSString *)text;

/**
 AES加密

 @param key 78b35638f28b49b10006b1cb5b0412b6
 @param text value
 @return 加密结果
 */
+(NSString *) aes256_encrypt:(NSString *)key Encrypttext:(NSString *)text;


/**
 *  用@"*"隐藏需要隐藏的部分
 *
 *  @param type   隐藏的位置, 中间，左边， 右边
 *  @param length 需要隐藏的长度
 *
 *  @return 返回 隐藏了数据的 新的字符串
 */
- (NSString *)hidePosition:(HideStringPartPosition)type length:(NSUInteger)length;

-(NSAttributedString *)changeAttributeStringWithAttribute:(NSDictionary<NSString *, id> *)attrs  Range:(NSRange)ranges;
/**
 *
 *  @param limitsize   限制宽，高
 *  @param fontsize lab的字体大小
 *
 *  @return 返回 字符串的大小
 */
-(CGSize)calculateStingSizeWithlimitSizeMake:(CGSize)limitsize andLabFontsize:(CGFloat)fontsize;



-(NSAttributedString *)changeAttributeStringWithImageIcon:(NSString *)imageName andAtIndex:(NSInteger)index;


+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key;

+(NSString*)decryptAES:(NSString*)content key:(NSString*)key;


-(NSString *)delacalculateDecimalNumberWithString:(NSString *)dycimal;


/**
 计算时间差

 @param startTime 开始时间
 @param endTime 介绍时间
 @param type 精确度1天2时3分4秒
 @return 返回字符串
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime andaccuracy:(NSInteger)type;

@end
