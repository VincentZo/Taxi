//
//  HundleTools.swift
//  Taxi
//
//  Created by Vincent on 16/10/18.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

/*
 + (NSString *)firstCharactor:(NSString *)aString
 {
 //转成了可变字符串
 NSMutableString *str = [NSMutableString stringWithString:aString];
 //先转换为带声调的拼音
 CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
 //再转换为不带声调的拼音
 CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
 //转化为大写拼音
 NSString *pinYin = [str capitalizedString];
 //获取并返回首字母
 return [pinYin substringToIndex:1];
 }
 
 */

class HundleTools: NSObject {
    // MARK : 获取拼音
    class func switchIntoSyllables(chinese : String) -> String{
        // 先转换为 NSMutableString
        let string = (chinese as NSString).mutableCopy() as! NSMutableString

        // 转换为带声调的拼音
        CFStringTransform(string as CFMutableString, nil, kCFStringTransformMandarinLatin, false)
        // 转换为不带声调的拼音
        CFStringTransform(string as CFMutableString, nil, kCFStringTransformStripDiacritics, false)
        // 转换为大写
        let pinYin = string.capitalized
        // 返回第一个
        let index = pinYin.index(pinYin.startIndex, offsetBy: 1)
        return pinYin.substring(to: index)
    }
    
    // MARK: 获取国家的区号
    class func getCountryDiallingCode(countryName:String)-> String{
        var diallingCode = ""
        let path = Bundle.main.path(forResource: "Phone", ofType: "plist")
        let dictionary = NSDictionary.init(contentsOfFile: path!)
        let pinYin = HundleTools.switchIntoSyllables(chinese: countryName)
        let array = dictionary?.object(forKey: pinYin) as! NSArray
        for item in array{
            let dic = item as! NSDictionary
            if countryName == dic["country"] as! String{
                diallingCode = dic["code"] as! String
            }
        }
        return diallingCode
    }
}




