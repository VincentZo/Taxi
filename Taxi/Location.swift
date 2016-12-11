//
//  Location.swift
//  Taxi
//
//  Created by Vincent on 16/10/17.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit
import CoreLocation


class Location: NSObject,CLLocationManagerDelegate {
    var location : CLLocation?
    var locationManager : CLLocationManager?
    var geoCoder : CLGeocoder?
    var locationInfo: String = ""
    override init() {
        super.init()
        self.initProperty()
    }
    
    func initProperty(){
        self.location = CLLocation.init()
        self.locationManager = CLLocationManager.init()
        self.locationManager?.delegate = self
        self.geoCoder = CLGeocoder.init()
    }
    
    // 开启定位
    func startLocation(){
        // 判断是否支持定位功能
        if CLLocationManager.locationServicesEnabled(){
            // 定位精确度
            self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            // 设置移动多少距离后开始自动更新定位
            self.locationManager?.distanceFilter = 500
            
            if judgeSystemVersion7Top(){
                self.locationManager?.requestWhenInUseAuthorization()
            }else{
                self.locationManager?.requestAlwaysAuthorization()
            }
            // 开启定位
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    // 定位成功的代理方法
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.last
        // 这个方法是异步调用,所以会直接执行下面的语句
        self.getAddressInfo(self.location!)
        
    }
    // 定位失败的代理方法
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         Log("Error", message: "\(error)")
    }
    
    // 获取定位信息
    func getAddressInfo(_ location: CLLocation){

        self.geoCoder?.reverseGeocodeLocation(location, completionHandler: { (placeMarks, error) in
            if placeMarks!.count > 0{
                let placeMark = placeMarks!.last
                self.locationInfo = (placeMark!.name)!
                Log("infomation", message: self.locationInfo)
            }
            if error != nil{
                Log("Error", message: "\(error)")
            }
        })
    }
    
}









