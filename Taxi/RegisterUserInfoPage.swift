//
//  RegisterUserInfoPage.swift
//  Taxi
//
//  Created by Vincent on 16/10/19.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit

class RegisterUserInfoPage: BasePage,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    @IBOutlet weak var userInfoBackView: UIView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initNavigationItem()
        self.configSubViews()
        self.title = "新用户信息"
        
    }
    
    func initNavigationItem(){
        self.setNavigationItem(title:"下一步", selector: #selector(doNext(sender:)), isLeft: false)
        
    }
    override func doNext(sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let payPage = storyBoard.instantiateViewController(withIdentifier: PayPageIndentifier) as! PayPage
        self.navigationController?.pushViewController(payPage, animated: true)
        
    }
    
    func configSubViews(){
        self.userAvatarImageView.layer.cornerRadius = 5
        self.userAvatarImageView.layer.masksToBounds = true
        self.userAvatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(chooseImageToAvatar(sender:)))
        self.userAvatarImageView.addGestureRecognizer(tap)
        
        
        self.userInfoBackView.layer.cornerRadius = 5
        self.userInfoBackView.layer.masksToBounds = true
    }
    // MARK: 弹出选择头像图片视图,照片库
    func chooseImageToAvatar(sender:UITapGestureRecognizer){

        let alertController = UIAlertController.init(title: "选择图片来源", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        let photoAction = UIAlertAction.init(title: "照片库", style: UIAlertActionStyle.default) { (action) in
            alertController.dismiss(animated: true, completion: nil)
            let imagePicker = UIImagePickerController.init()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction.init(title: "照相机", style: UIAlertActionStyle.default) { (action) in
             alertController.dismiss(animated: true, completion: nil)
            let imagePicker = UIImagePickerController.init()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(photoAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: 实现UIImagePickerControllerDelegate代理方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: nil)
        self.userAvatarImageView.image = image
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.firstNameTextField.resignFirstResponder()
        self.lastNameTextField.resignFirstResponder()
    }
    
    
}
