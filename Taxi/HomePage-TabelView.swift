//
//  HomePage-TabelView.swift
//  Taxi
//
//  Created by Vincent on 2016/11/1.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import Foundation
extension HomePage : UITableViewDelegate,UITableViewDataSource{
    
    func configTabelView(){
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "addressCell")
        self.tableView?.isHidden = true
        self.tableView?.rowHeight = 40
        self.view.bringSubview(toFront: self.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView!.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath)
        let poi = self.dataSources[indexPath.row]
        cell.textLabel?.text = poi.name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.endCoordinate != nil{
            let annotations = self.mapView?.annotations as! [BMKPointAnnotation]
            for annotation in annotations{
                if annotation.title.contains("目的地"){
                    self.mapView?.removeAnnotation(annotation)
                }
            }
        }
        let poi = self.dataSources[indexPath.row]
        self.endAddress = poi.name
        self.endCoordinate = poi.pt
        self.searchTextField.text = self.endAddress
        let annotation = BMKPointAnnotation.init()
        annotation.coordinate = self.endCoordinate!
        annotation.title = "目的地:\(self.endAddress)"
        self.mapView?.addAnnotation(annotation)
        self.mapView?.showAnnotations([annotation], animated: true)
//        }
        self.searchTextField.resignFirstResponder()
        self.tableView.isHidden = true
    }
}








