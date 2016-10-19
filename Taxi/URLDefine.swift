//
//  URLDefine.swift
//  Taxi
//
//  Created by Vincent on 16/10/14.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//  定义项目相关的 URL 信息,如:测试地址,网络请求地址,服务器地址等

import Foundation

//MARK: 获取项目测试,服务器地址
func getProjectAddress()->String{
    #if AppStore
        return "https://www.baidu.com"
    #elseif DEBUG
        return "https://github.com/VincentZo/Taxi"
    #else
        return "https://developer.apple.com/reference/"
    #endif
}

// MARK: 下面定义项目调试阶段和发布后的网络请求地址
func getProjectRequestAddress() ->String{
    #if AppStore
        return "https://www.baidu.com"
    #elseif DEBUG
        return "https://github.com/VincentZo/Taxi"
    #else
        return "https://developer.apple.com/reference/"
    #endif

}
