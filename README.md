# 仿通知
仿通知  在APP內顯現

- 在 AppDelegate 中，攔截通知
```
func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        // App在執行的情況下收到推播
        if application.applicationState == .active {
            if let backgroundMessage = (userInfo["aps"] as! [String: Any])["alert"] as? String {
                let alert = RYAlertNotice()
                alert.show("通知", message: backgroundMessage, style: nil, tap: {
                    print("點擊")
                })
            }
        }
    }
```
