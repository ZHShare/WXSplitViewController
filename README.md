![image](https://github.com/ZHShare/WXSplitViewController/blob/master/WXSplitViewController/splitVC.gi)

使用注意：
1. LeftVC 点击响应后事件是直接由主控制器MasterVC执行的
    //MARK: - 侧边栏跳转功能1 如果你的Master跳转的是用segue跳转的请用此方式
    - func wxPerformSegue(withIdentifier identifier: String, sender: Any?)
    //MARK: - 侧边栏跳转功能2
    - func LeftViewController(didSelectController view: UIViewController)
2.  masterLeftIsLoadFromStoryboard  默认true 如果master and left viewcontroller 是用代码直接添加的需要设为false
3. storyboard 设置master and left
    连线设置为"wx_master"表示：master vc "wx_left": 表示leftVC
    class 选custom 并设置为WXMasterSegue
    
// 比较粗糙 欢迎提意见修改
