//
//  NSString+ExtendMethod.m
//  YuanXin_Project
//
//  Created by Yuanin on 16/6/1.
//  Copyright © 2016年 yuanxin. All rights reserved.
//

#import "NSString+ExtendMethod.h"


#import <CommonCrypto/CommonDigest.h>

@implementation NSString (ExtendMethod)


- (NSString *)MD5Encryption {
    
    const char *cStr = [self UTF8String];
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); //这里的用法明显是错误的，但是不知道为什么依然可以在网络上得以流传。当srcString中包含空字符（\0）时
    //CC_MD5( cStr, (CC_LONG)string.length, digest );  //////对中文加密不正确，因为中文的字节长度不一样，上面方面正确计算了中文的字节长度
    NSMutableString *result = [NSMutableString stringWithCapacity:2 * CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}


- (NSString *)hidePosition:(HideStringPartPosition)type length:(NSUInteger)length {
    
    if (self.length <= length) return self;
    
    NSMutableString *result = [NSMutableString stringWithString:self];
    
    //default
    NSInteger startPosition = 0;
    NSInteger endPosition = length;
    if (kHideStringRight == type) { //right
        startPosition = result.length - length;
        endPosition = result.length;
    } else if (kHideStringCenter == type) { //center
        startPosition = (result.length - length)/2;
        endPosition = startPosition + length;
    }
    
    for (; startPosition < endPosition; ++startPosition) {
        [result replaceCharactersInRange:NSMakeRange(startPosition, 1) withString:@"*"];
    }
    return result;
}

-(NSAttributedString *)changeAttributeStringWithAttribute:(NSDictionary<NSString *, id> *)attrs Range:(NSRange)ranges{
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:self];
    //设置颜色不同
    [string addAttributes:attrs range:ranges];
    return string;
    
}
-(CGSize)calculateStingSizeWithlimitSizeMake:(CGSize)limitsize andLabFontsize:(CGFloat)fontsize{
    CGSize NewSize = [self boundingRectWithSize:limitsize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    return NewSize;
}
-(NSAttributedString *)changeAttributeStringWithImageIcon:(NSString *)imageName andAtIndex:(NSInteger)index{
    
    NSMutableAttributedString *attri =[[NSMutableAttributedString alloc] initWithString:self];
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = [UIImage imageNamed:imageName];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -3, 25, 15);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:index];
    return [attri copy];
}

+(NSData *)AES256ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text  //加密
{
//    char keyPtr[kCCKeySizeAES256+1];
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [text length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [text bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    NSString *const kInitVector = @"16-Bytes--String";
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    
    // 为结束符'\\0' +1
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding
                                          keyPtr,
                                          kCCKeySizeAES128,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    free(encryptedBytes);
    return nil;
}
+(NSString*)decryptAES:(NSString*)content key:(NSString*)key{
    
    NSString *const kInitVector = @"16-Bytes--String";
    //把 base64 String 转换成 Data
    NSData*contentData=[[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger dataLength=contentData.length;
    
   char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr,0,sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    size_t decryptSize=dataLength+kCCBlockSizeAES128;
    void *decryptedBytes=malloc(decryptSize);
    size_t actualOutSize=0;
    NSData *initVector=[kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    
    
    CCCryptorStatus cryptStatus=CCCrypt(kCCDecrypt,
                                        kCCAlgorithmAES,
                                        kCCOptionPKCS7Padding,keyPtr,kCCKeySizeAES128,initVector.bytes,contentData.bytes,dataLength, decryptedBytes,decryptSize,&actualOutSize);
    if(cryptStatus==kCCSuccess){
        return [[NSString alloc]initWithData:[NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
    }
    free(decryptedBytes);
    return
    nil;
}

+(NSString *) aes256_encrypt:(NSString *)key Encrypttext:(NSString *)text
{
    const char *cstr = [text cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:text.length];
    //对数据进行加密
    NSData *result = [self AES256ParmEncryptWithKey:key Encrypttext:data];
    
    //转换为2进制字符串
    if (result && result.length > 0) {
        
//        Byte *datas = (Byte*)[result bytes];
        NSMutableString *output = [NSMutableString stringWithCapacity:result.length];
//        for(int i = 0; i < result.length; i++){
//            [output appendFormat:@"%02x", datas[i]];
//        }
        [result enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
            unsigned char *dataBytes = (unsigned char*)bytes;
            for (NSInteger i = 0; i < byteRange.length; i++) {
                NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
                if ([hexStr length] == 2) {
                    [output appendString:hexStr];
                } else {
                    [output appendFormat:@"0%@", hexStr];
                }
            }  
        }];
        return output;
    }
    return nil;
}

+ (NSData *)AES256ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text  //解密
{
//    char keyPtr[kCCKeySizeAES256+1];
    char keyPtr[kCCKeySizeAES128+1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [text length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [text bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}
+(NSString *) aes256_decrypt:(NSString *)key Decrypttext:(NSString *)text
{
    //转换为2进制Data
    NSMutableData *data = [NSMutableData dataWithCapacity:text.length / 2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [text length] / 2; i++) {
        byte_chars[0] = [text characterAtIndex:i*2];
        byte_chars[1] = [text characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    //对数据进行解密
    NSData* result = [self  AES256ParmDecryptWithKey:key Decrypttext:data];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}
-(NSString *)delacalculateDecimalNumberWithString:(NSString *)dycimal{
    if (![self isEqualToString:@""]&&self&&![dycimal isEqualToString:@""]&&dycimal) {
        NSDecimalNumber *addendNumber = [NSDecimalNumber decimalNumberWithString:self];
        NSDecimalNumber *augendNumber = [NSDecimalNumber decimalNumberWithString:dycimal];
        return  [NSString stringWithFormat:@"%.2lf",[[addendNumber decimalNumberByMultiplyingBy:augendNumber] floatValue]];
    }
    return @"0.00";
}
+ (NSString *)dateTimeDifferenceWithStartTime:(NSDate *)startTime endTime:(NSDate *)endTime andaccuracy:(NSInteger)type{
   
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *compas = [calendar components:unit fromDate:startTime toDate:endTime options:0];

    NSString *str;
    if (type==1) {//天
        str = [NSString stringWithFormat:@"%ld",compas.day];
    }else if (type==2){//小时
        str = [NSString stringWithFormat:@"%ld-%ld",compas.day,compas.hour];
    }else if (type==3){//分
        str = [NSString stringWithFormat:@"%ld-%2ld-%02ld",compas.day,compas.hour,compas.minute];
    }else if (type==4){//秒
        str = [NSString stringWithFormat:@"%ld-%ld-%02ld-%02ld",compas.day,compas.hour,compas.minute,compas.minute];
    }
    return str;
    
}
@end
