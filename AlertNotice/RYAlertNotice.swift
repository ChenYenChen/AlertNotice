//
//  RYAlertNotice.swift
//  CutImageProportion
//
//  Created by Ray on 2017/5/4.
//  Copyright © 2017年 Ray. All rights reserved.
//

import UIKit
import AudioToolbox

var RYAlertNumber: Int = 0

struct RYAlertStyle {
    /// 圖片
    var image: UIImage?
    /// 標題背景顏色
    var titleBackgroundColor: UIColor = UIColor.white
    /// 標題顏色
    var titleColor: UIColor = UIColor.black
    /// 標題大小
    var titleFont: Int = 16
    /// 內容背景顏色
    var messageBackgroundColor: UIColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 0.9)
    /// 內容顏色
    var messageColor: UIColor = UIColor.black
    /// 內容大小
    var messageFont: Int = 16
    /// 四角的弧度
    var cornerRadius: Int = 15
    /// 音檔路徑
    var voicePath: String?
    /// 系統音檔編號 1000 ~ 2000
    var systemID: Int = 1200 {
        didSet {
            if systemID < 1000 {
                systemID = 1000
            }
            
            if systemID > 2000 {
                systemID = 2000
            }
        }
    }
    /// 停留時間
    var stayTime: TimeInterval = 3
}

class RYAlertNotice: NSObject {
    
    private var alertWin: UIWindow?
    private let winRect: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 130)
    private let viewRect: CGRect = CGRect(x: 15, y: -90, width: UIScreen.main.bounds.width - 30, height: 90)
    private let winTag: Int = 1000
    private var style: RYAlertStyle = RYAlertStyle()
    private var clearTimer: Timer?
    private var endTag: Int = 0
    private var complite: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    func show(_ title: String, message: String, style: RYAlertStyle?, tap: (() -> Void)?) {
        self.complite = tap
        if let newStyle = style {
            self.style = newStyle
        }
        
        if self.checkExist() {
            self.creatNotice(title: title, message: message)
        } else {
            self.creatWindow()
            RYAlertNumber = 0
            self.creatNotice(title: title, message: message)
        }
    }
    
    private func creatWindow() {
        self.alertWin = UIWindow(frame: self.winRect)
        guard let win = self.alertWin else {
            return
        }
        win.tag = self.winTag
        win.windowLevel = UIWindowLevelAlert
        win.makeKeyAndVisible()
    }
    
    private func creatNotice(title: String, message: String) {
        RYAlertNumber = RYAlertNumber + 1
        self.endTag = RYAlertNumber
        let thisTag = RYAlertNumber
        let alertView = UIView(frame: self.viewRect)
        alertView.backgroundColor = UIColor.clear
        alertView.layer.cornerRadius = CGFloat(self.style.cornerRadius)
        alertView.layer.masksToBounds = true
        alertView.tag = RYAlertNumber
        
        let titleRect = CGRect(x: 0, y: 0, width: alertView.bounds.width, height: alertView.bounds.height / 2)
        let titleView = UIView(frame: titleRect)
        titleView.backgroundColor = self.style.titleBackgroundColor
        
        var titleX: CGFloat = 15
        if let image = self.style.image {
            let imageRect = CGRect(x: titleX, y: 5, width: 30, height: 30)
            let alertImage: UIImageView = UIImageView(frame: imageRect)
            alertImage.image = image
            titleX = titleX + 40
            titleView.addSubview(alertImage)
        }
        let titleLabelRect = CGRect(x: titleX, y: 5, width: titleView.bounds.width - titleX - 15, height: 40)
        let alertTitleLabel: UILabel = UILabel(frame: titleLabelRect)
        alertTitleLabel.text = title
        alertTitleLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(self.style.titleFont))
        titleView.addSubview(alertTitleLabel)
        alertView.addSubview(titleView)
        
        let messageRect = CGRect(x: 0, y: alertView.bounds.height / 2, width: alertView.bounds.width, height: alertView.bounds.height / 2)
        let messageView = UIView(frame: messageRect)
        messageView.backgroundColor = self.style.messageBackgroundColor
        
        let messageLabelRect = CGRect(x: 15, y: 0, width: titleView.bounds.width - 30, height: 40)
        let alertMessageLabel: UILabel = UILabel(frame: messageLabelRect)
        alertMessageLabel.text = message
        alertMessageLabel.font = UIFont.systemFont(ofSize: CGFloat(self.style.messageFont))
        messageView.addSubview(alertMessageLabel)
        alertView.addSubview(messageView)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(moveView(_:)))
        alertView.addGestureRecognizer(swipe)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchView(_:)))
        alertView.addGestureRecognizer(tap)
        self.alertWin?.addSubview(alertView)
        
        self.alertVoice()
        
        UIView.animate(withDuration: 0.5, animations: {
            alertView.frame.origin = CGPoint(x: 15, y: 25)
        }) { (finished) in
            
            for view in self.alertWin!.subviews {
                if view.tag < thisTag {
                    view.removeFromSuperview()
                }
            }
            
            guard self.endTag == RYAlertNumber else {
                return
            }
            
            self.clearTimer?.invalidate()
            self.clearTimer = nil
            
            self.clearTimer = Timer.scheduledTimer(timeInterval: self.style.stayTime, target: self, selector: #selector(self.clearView), userInfo: nil, repeats: false)
        }
    }
    
    @objc private func touchView(_ sender: UITapGestureRecognizer) {
        print("ss")
        if let com = self.complite {
            com()
        }
    }
    
    @objc private func moveView(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .up {
            self.clearView()
        }
    }
    
    @objc private func clearView() {
        for view in self.alertWin!.subviews {
            if view.tag == self.endTag {
                UIView.animate(withDuration: 0.5, animations: {
                    view.frame.origin = CGPoint(x: 15, y: -90)
                }, completion: { (finished) in
                    guard self.endTag == RYAlertNumber else {
                        return
                    }
                    self.clearWin()
                })
            }
        }
    }
    
    @objc private func clearWin() {
        
        for win in UIApplication.shared.windows {
            if win.tag == self.winTag {
                win.removeFromSuperview()
            }
        }
    }
    
    // 播放聲音
    private func alertVoice() {
        var soundID: SystemSoundID = UInt32(exactly: self.style.systemID)!
        
        if let path = self.style.voicePath {
            //地址转换
            let baseURL = URL(fileURLWithPath: path) as CFURL
            //赋值
            AudioServicesCreateSystemSoundID(baseURL, &soundID)
        }
        
        AudioServicesPlayAlertSound(soundID)
    }
    // 確認是否存在
    private func checkExist() -> Bool {
        for win in UIApplication.shared.windows {
            if win.tag == self.winTag {
                self.alertWin = win
                return true
            }
        }
        return false
    }
}
