//
//  HomePage.swift
//  Taxi
//
//  Created by Vincent on 16/10/20.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class HomePage: BasePage{

    var userCenterInfoPage : UserCenterInfoPage?
    var backControl : UIControl?
    var mapView : BMKMapView?
    var localService : BMKLocationService = BMKLocationService.init()
    var updateCarTimer : Timer?
    var carsArriveTimes : Array<Double> = []
    var currentCoordinate : CLLocationCoordinate2D = CLLocationCoordinate2D.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationItem()
        self.addMapView()
        self.startLocation()
    }
    
    
}










