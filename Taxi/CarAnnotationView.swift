//
//  CarAnnotationView.swift
//  Taxi
//
//  Created by Vincent on 2016/10/26.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class CarAnnotationView: BMKAnnotationView {
    var imageView : UIImageView!
    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        self.backgroundColor = UIColor.clear
        imageView = UIImageView.init(image: UIImage.init(named: "map-uberx"))
        //imageView.contentMode = .center
        imageView.frame = self.bounds
        self.addSubview(imageView)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
