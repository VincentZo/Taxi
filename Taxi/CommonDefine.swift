//
//  CommonDefine.swift
//  Taxi
//
//  Created by Vincent on 16/10/14.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//  通用宏定义文件,定义一些常用字段,日志函数,系统版本,系统类型,设备信息等

import Foundation
import UIKit

let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height
let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width

// swift3.0 中 : __FUNCTION__ 替换为#function
// MARK:日志输出函数
func Log(messageType : String, message:String ,  function:String = #function,line : Int = #line , fileName :String = #file){
    // 预处理来判断是否是 debug 版本,debug 版本则输入日志
    #if DEBUG
        let file = fileName.components(separatedBy: "/").last!
        print("日志打印---messageInfo : \(messageType)__\(message); transferInfo : inFile:\(file)__onLine:\(line)__withFunction:\(function)")
    #else
    #endif
}

// MARK:设备判断
func isiPhone5() -> Bool{
    if ScreenHeight == 568.0{
        return true
    }
    return false
}

func isiPhone6AndiPhone7() -> Bool{
    if ScreenHeight == 667.0{
        return true
    }
    return false
}

func isIphonePlus() ->Bool{
    if ScreenHeight == 736.0{
        return true
    }
    return false
}

// MARK: 系统类型判断 os(OSX),os(iOS)等
func judgeiOSSystem() -> Bool{
    #if os(iOS)
        return true
    #else
        return false
    #endif
}

func judgeSystemVersion8()->Bool{
    if UIDevice.current.systemVersion >= "8.0.0" && UIDevice.current.systemVersion < "9.0.0"{
        return true
    }
    return false
}

func judgeSystemVersion9() -> Bool{
    let processInfo = ProcessInfo.init()
    if processInfo.operatingSystemVersion.majorVersion >= 9 && processInfo.operatingSystemVersion.majorVersion < 10{
        return true
    }
    return false
}

func judgeSystemVersion10()->Bool{
    let processInfo = ProcessInfo.init()
    if processInfo.operatingSystemVersion.majorVersion >= 10{
        return true
    }
    return false
}

// MARK: 判断系统版本是否在某个版本以上
func judgeSystemVersion7Top()->Bool{
    let processInfo = ProcessInfo.init()
    if processInfo.operatingSystemVersion.majorVersion > 7 {
        return true
    }
    return false
}

func judgeSystemVersion8Top()->Bool{
    let processInfo = ProcessInfo.init()
    if processInfo.operatingSystemVersion.majorVersion > 8 {
        return true
    }
    return false
}
func judgeSystemVersion9Top()->Bool{
    let processInfo = ProcessInfo.init()
    if processInfo.operatingSystemVersion.majorVersion > 9 {
        return true
    }
    return false
}






















