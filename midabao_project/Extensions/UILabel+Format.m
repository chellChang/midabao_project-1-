//
//  UILabel+Format.m
//  midabao_project
//
//  Created by 杨路 on 2017/9/4.
//  Copyright © 2017年 xiangbibi. All rights reserved.
//

#import "UILabel+Format.h"

@implementation UILabel (Format)
-(void)formatNumber:(NSString *)number andsubText:(NSString *)subText{
    if (number.length>0) {
        NSString *str=[NSString stringWithFormat:@"%@", number];
        NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
        formatter.numberStyle=NSNumberFormatterDecimalStyle;
        [formatter setPositiveFormat:@"###,##0"];
        self.text=[NSString stringWithFormat:@"%@%@",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]],subText];
    }
}
-(void)formatNumber:(NSString *)number andsubText:(NSString *)subText andAttribute:(NSDictionary<NSString *, id> *)attrs{
    if (number.length>0) {
        NSString *str=[NSString stringWithFormat:@"%@", number];
        NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
        formatter.numberStyle=NSNumberFormatterDecimalStyle;
        [formatter setPositiveFormat:@"###,##0"];
        NSString *modifyStr=[NSString stringWithFormat:@"%@%@",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]],subText];
        
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:modifyStr];
        //设置颜色不同
        [string addAttributes:attrs range:NSMakeRange(modifyStr.length-subText.length, subText.length)];
        self.attributedText=string;
    }
}
-(void)floatformatNumber:(NSString *)number andSubText:(NSString *)subText{
    if (number.length>0) {
        NSString *str=[NSString stringWithFormat:@"%.2f", [number doubleValue]];
        NSNumberFormatter *formatter=[[NSNumberFormatter alloc]init];
        [formatter setPositiveFormat:@"###,##0.00"];
        formatter.numberStyle=NSNumberFormatterDecimalStyle;
        self.text=[NSString stringWithFormat:@"%@%@",[formatter stringFromNumber:[NSNumber numberWithDouble:[str doubleValue]]],subText];
    }
}
@end
