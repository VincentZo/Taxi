//
//  GuidePage.swift
//  Taxi
//
//  Created by Vincent on 16/10/14.
//  Copyright © 2016年 com.vincent.study. All rights reserved.
//

import UIKit
import AVFoundation
import MBProgressHUD
class GuidePage: BasePage {

    @IBOutlet weak var animateImageView: UIImageView!

    @IBOutlet weak var videoView: UIView!
    
    var playerItem : AVPlayerItem?
    var player : AVPlayer?
    var location : Location = Location.init()
    
    //var mbHub : MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 初始化视频播放层
        self.initVideoPlayer()
        // 执行开场动画
        self.doAminateWithGuide()
    }

    // MARK: 启动时执行动画
    func doAminateWithGuide(){
        var images = [UIImage]()
        for index in 0...67{
            let image = UIImage.init(named: "logo-\(index)")
            images.append(image!)
        }
        //self.animateImageView.backgroundColor = UIColor.clear
        // 将动画图片设置到 imageView 中,
        self.animateImageView.animationImages = images
        self.animateImageView.animationDuration = 5
        // 设置只执行一次
        self.animateImageView.animationRepeatCount = 1
        self.animateImageView.startAnimating()
        
        // 设置视频在动画结束后开始播放
        UIView.animate(withDuration: 1, delay: 5, options: .curveEaseInOut, animations: {
            self.videoView.alpha = 1
            // 动画结束后开始播放视频
            self.player!.play()
            }) { (finished) in
                //Log(messageType: "结束调用", message: "启动动画播放结束")
        }
        
    }
    
    // MARK: 创建视频播放
    func initVideoPlayer(){
        let path = Bundle.main.path(forResource: "welcome_video", ofType: "mp4")
        let url = URL.init(fileURLWithPath: path!)
        self.playerItem = AVPlayerItem.init(url: url)
        self.player = AVPlayer.init(playerItem: self.playerItem)
        
        // 创建播放层
        let playerLayer = AVPlayerLayer.init(player: self.player)
        // 这里要传 self.view.bounds ,不然显示会错
        playerLayer.frame = self.view.bounds
        //print("\(self.view.bounds)--\(self.videoView.bounds)")
        // 设置播放层的适配原则
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        // 添加播放层到 videoView, 0:代表最底层
        self.videoView.layer.insertSublayer(playerLayer, at: 0)
        // 隐藏视频videoView
        self.videoView.alpha = 0
        
        // 循环播放视频
        NotificationCenter.default.addObserver(self, selector: #selector(repeatPlayVideo(sender:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerItem)
    }
    
    // MARK: 设置视频重复播放
    func repeatPlayVideo(sender : Notification){
        // 获取 playerItem
//        let playItem = sender.object as! AVPlayerItem
//        playItem.seek(to: kCMTimeZero)
        self.playerItem?.seek(to: kCMTimeZero)
        self.player?.play()
    }
    
    
    // 登录按钮
    @IBAction func signOn(sender: AnyObject) {
        let loginPage = MainStoryBoard.instantiateViewController(withIdentifier: "loginPage") as! LoginPage
        let navigation = UINavigationController.init(rootViewController: loginPage)
        self.present(navigation, animated: true) { 
            //self.location.startLocation()
        }
    }
    
    // 注册按钮
    @IBAction func singIn(sender: AnyObject) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let registerPage = storyBoard.instantiateViewController(withIdentifier: RegisterPageIndentifier) as! RegisterPage
        //let registerPage = RegisterPage()
        let navigation = UINavigationController.init(rootViewController: registerPage)
        self.present(navigation, animated: true, completion: nil)
    }
    
    @IBOutlet weak var signIn: UIButton!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }

}
