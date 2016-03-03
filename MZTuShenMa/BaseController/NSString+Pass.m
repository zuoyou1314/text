//
//  NSString+Pass.m
//  XinYongBao
//
//  Created by wangkang on 1/20/14.
//  Copyright (c) 2014 我爱卡. All rights reserved.
//

#import "NSString+Pass.h"

@implementation NSString (Pass)

- (BOOL)isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidPhoneNumber
{
    NSString *numberRegex = @"13[0-9]{9}|15[0-9]{9}|18[0-9]{9}|145[0-9]{8}|147[0-9]{8}|17[0-9]{9}";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    return [numberTest evaluateWithObject:self];
}

- (BOOL)isValidCreditCardNumber
{
    NSUInteger len = self.length;
    
    if (len < 13 || len > 19)
        return  NO;
    
    int sum = 0;
    
    /* 信用卡卡号规则验证
     * Issuer Identifier    Card Number                            Length
     * Diner’s Club         300xxx-305xxx, 3095xx,36xxxx, 38xxxx   14
     * American Express     34xxxx, 37xxxx                         15
     * VISA                 4xxxxx                                 13, 16
     * MasterCard           51xxxx-55xxxx                          16
     * JCB                  3528xx-358xxx                          16
     * Discover             6011xx                                 16
     * 银联                  622126-622925                          16
     * 算法
     * 1.偶数位卡号奇数位上数字*2，奇数位卡号偶数位上数字*2。
     * 2.大于等于10的位数减9。
     * 3.全部数字加起来。
     * 4.结果不是10的倍数的卡号非法。
     */
    for (int i = 0; i < len; i++) {
        NSRange range = NSMakeRange(i, 1);
        long multiResult = 0;
        NSInteger number = [[self substringWithRange:range] integerValue];
        
        if (len % 2 == 0) {
            if (i % 2 == 0) {
                multiResult = number * 2;
                
                if (multiResult >= 10) multiResult -= 9;
                
                sum += multiResult;
            } else {
                sum += number;
            }
        } else {
            if (i % 2 == 1) {
                multiResult = number * 2;
                if (multiResult >= 10) multiResult -= 9;
                
                sum += multiResult;
            } else {
                sum += number;
            }
        }
    }
    if (sum % 10 == 0)
        return YES;
    
    return NO;
}

/*
 *  密码介于6-10位之间
 */
- (BOOL)isValidPassword
{
    NSString *passwordRegex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,10}$";
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordTest evaluateWithObject:self];
}

- (BOOL)isValidPassCode
{
    NSString *passCodeRegex = @"[0-9]{6}";
    NSPredicate *passCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passCodeRegex];
    return [passCodeTest evaluateWithObject:self];
}

- (BOOL)isValidChineseName
{
    NSString *nameRegex = @"^[\u4e00-\u9fa5]{2,8}$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:self];
}

- (BOOL)isValidCard4
{
    NSString *card4Regex = @"[0-9]{3}[0-9Xx]{1}";
    
    NSPredicate *card4Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", card4Regex];
    
    return [card4Test evaluateWithObject:self];
}

- (BOOL)isAllNumber
{
    NSString *passCodeRegex = @"[0-9]+";
    NSPredicate *passCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passCodeRegex];
    return [passCodeTest evaluateWithObject:self];
}

- (BOOL)isAllCharacter
{
    NSString *passCodeRegex = @"[a-zA-Z]+";
    NSPredicate *passCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passCodeRegex];
    return [passCodeTest evaluateWithObject:self];
}

- (BOOL)isNumberAndCharacter
{
    NSString *passCodeRegex = @"[a-zA-Z0-9]+";
    NSPredicate *passCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passCodeRegex];
    return [passCodeTest evaluateWithObject:self];
}

- (BOOL)hasChineseCharacter
{
    NSString *nameRegex = @"^[\u4e00-\u9fa5]{2,4}";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:self];
}

/*
 *  身份证合法性校验
 *  15位身份证号码：第7、8位为出生年份(两位数)，第9、10位为出生月份，
 *  第11、12位代表出生日期，第15位代表性别，奇数为男，偶数为女。
 *  -------
 *  -------
 *  18位身份证号码：第7、8、9、10位为出生年份(四位数)，第11、第12位为出生月份，
 *  第13、14位代表出生日期，第17位代表性别，奇数为男，偶数为女。
 *  -------
 *  - 省，直辖市代码表
 *  -------
 *  11:"北京",12:"天津",13:"河北",14:"山西",15:"内蒙古",
 *  21:"辽宁",22:"吉林",23:"黑龙江",31:"上海",32:"江苏",
 *  33:"浙江",34:"安徽",35:"福建",36:"江西",37:"山东",41:"河南",
 *  42:"湖北",43:"湖南",44:"广东",45:"广西",46:"海南",50:"重庆",
 *  51:"四川",52:"贵州",53:"云南",54:"西藏",61:"陕西",62:"甘肃",
 *  63:"青海",64:"宁夏",65:"新疆",71:"台湾",81:"香港",82:"澳门",91:"国外"
 */
- (BOOL)isValidIdentityCardNumber
{
    
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

-(BOOL)isValidateBankCardNumber
{
//    BOOL flag;
//    if (self.length <= 0) {
//        flag = NO;
//        return flag;
//    }
    NSString *regex2 = @"^(\\d{16,19})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:self];
}
//银行卡后四位
- (BOOL) validateBankCardLastNumber
{
//    BOOL flag;
//    if (bankCardNumber.length != 4) {
//        flag = NO;
//        return flag;
//    }
    NSString *regex2 = @"^(\\d{4})";
    NSPredicate *bankCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [bankCardPredicate evaluateWithObject:self];
}
//+ (BOOL) isValidNumber:(NSString*)value{
//    const char *cvalue = [value UTF8String];
//    int len = strlen(cvalue);
//    for (int i = 0; i < len; i++) {
//        if(!isNumber(cvalue[i])){
//            return FALSE;
//        }
//    }
//    return TRUE;
//}


//+ (BOOL) isValidCreditNumber:(NSString*)value
//{
//    BOOL result = TRUE;
//    NSInteger length = [value length];
//    if (length >= 13)
//    {
//        result = [NSString isValidNumber:value];
//        if (result)
//        {
//            NSInteger twoDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 2)] integerValue];
//            NSInteger threeDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 3)] integerValue];
//            NSInteger fourDigitBeginValue = [[value substringWithRange:NSMakeRange(0, 4)] integerValue];
//            //Diner's Club
//            if (((threeDigitBeginValue >= 300 && threeDigitBeginValue <= 305)||
//                 fourDigitBeginValue == 3095||twoDigitBeginValue==36||twoDigitBeginValue==38) && (14 != length))
//            {
//                result = FALSE;
//            }
//            
//            //VISA
//            else if([value isStartWithString:@"4"] && !(13 == length||16 == length))
//            {
//                result = FALSE;
//            }
//            //MasterCard
//            else if((twoDigitBeginValue >= 51||twoDigitBeginValue <= 55) && (16 != length))
//            {
//                result = FALSE;
//            }
//            //American Express
//            else if(([value isStartWithString:@"34"]||[value isStartWithString:@"37"]) && (15 != length))
//            {
//                result = FALSE;
//            }
//            //Discover
//            else if([value isStartWithString:@"6011"] && (16 != length))
//            {
//                result = FALSE;
//            }
//            else
//            {
//                NSInteger begin = [[value substringWithRange:NSMakeRange(0, 6)] integerValue];
//                //CUP
//                if ((begin >= 622126 && begin <= 622925) && (16 != length))
//                {
//                    result = FALSE;
//                }
//                //other
//                else
//                {
//                    result = TRUE;
//                }
//            }
//        }
//        if (result)
//        {
//            NSInteger digitValue;
//            NSInteger checkSum = 0;
//            NSInteger index = 0;
//            NSInteger leftIndex;
//            //even length, odd index
//            if (0 == length%2)
//            {
//                index = 0;
//                leftIndex = 1;
//            }
//            //odd length, even index
//            else
//            {
//                index = 1;
//                leftIndex = 0;
//            }
//            while (index < length)
//            {
//                digitValue = [[value substringWithRange:NSMakeRange(index, 1)] integerValue];
//                digitValue = digitValue*2;
//                if (digitValue >= 10)
//                {
//                    checkSum += digitValue/10 + digitValue%10;
//                }
//                else
//                {
//                    checkSum += digitValue;
//                }
//                digitValue = [[value substringWithRange:NSMakeRange(leftIndex, 1)] integerValue];
//                checkSum += digitValue;
//                index += 2;
//                leftIndex += 2;
//            }
//            result = (0 == checkSum%10) ? TRUE:FALSE;
//        }
//    }
//    else
//    {
//        result = FALSE;
//    }
//    return result;
//}

@end
