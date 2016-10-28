//
//  LocationAnnotationView.swift
//  Taxi
//
//  Created by Vincent on 2016/10/28.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class LocationAnnotationView: BMKAnnotationView {
    var imageView : UIImageView!
    override init!(annotation: BMKAnnotation!, reuseIdentifier: String!){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.bounds = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        self.backgroundColor = UIColor.clear
        imageView = UIImageView.init(image: UIImage.init(named: "location1"))
        imageView.layer.shadowColor = UIColor.darkGray.cgColor
        imageView.layer.shadowOffset = CGSize.init(width: -1, height: -1)
        imageView.layer.shadowOpacity = 0.8
        imageView.frame = self.bounds
        self.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
