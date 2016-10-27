//
//  UserCenterInfo.swift
//  Taxi
//
//  Created by Vincent on 16/10/20.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class UserCenterInfo: NSObject {
    var icon : String!
    var title : String!

    init(title : String , icon :String){
        super.init()
        self.icon = icon
        self.title = title
    }
}
