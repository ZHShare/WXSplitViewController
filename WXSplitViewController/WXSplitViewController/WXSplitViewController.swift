//
//  ViewController.swift
//  WXSplitViewController
//
//  Created by 梦烙时光 on 2018/1/11.
//  Copyright © 2018年 StarHoa. All rights reserved.
//

import UIKit

extension UIStoryboard
{
    static func controller<T>(type: T.Type = T.self) -> T {
        let className = String(describing: type)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let ty = storyBoard.instantiateViewController(withIdentifier: className) as? T
        if let ty = ty { return ty }
        fatalError("can not load nib of \(type)")
    }
}

class WXMasterSegue: UIStoryboardSegue
{
    override func perform() {}
}

extension UIViewController
{
    
    func splitVC() -> WXSplitViewController! {
        
        var newParent: UIViewController? = parent
        if parent != nil {
            if let nav = parent as? UINavigationController {
                newParent = nav.parent
            }
            while !newParent!.isKind(of: WXSplitViewController.classForCoder()) {}
        }
        
        return newParent as? WXSplitViewController
    }
}

class WXSplitViewController: UIViewController
{
    
    @IBInspectable var maxWidth: CGFloat = 200 {
        didSet { updateVC() }
    }

    fileprivate let screenW: CGFloat = UIScreen.main.bounds.size.width
    fileprivate struct Identifier {
        static let master = "wx_master"
        static let left = "wx_left"
    }
    var masterVC: UIViewController! { didSet { updateVC() } }
    var leftVC: UIViewController! { didSet { updateVC() } }
    var masterLeftIsLoadFromStoryboard: Bool = true // 默认从SB加载
    fileprivate var identfiers = [Identifier.master, Identifier.left]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateVC()
        if masterLeftIsLoadFromStoryboard {
            _ = identfiers.map { self.performSegue(withIdentifier: $0, sender: nil) }
        }
    }
    
    fileprivate func updateVC() {
        
        if let leftVC = leftVC {
            if !self.view.subviews.contains(leftVC.view) {
                self.view.addSubview(leftVC.view)
            }
            if !self.childViewControllers.contains(leftVC) {
                self.addChildViewController(leftVC)
            }
        }
        
        if let masterVC = masterVC {
            if !self.view.subviews.contains(masterVC.view) {
                self.view.addSubview(masterVC.view)
            }
            if !self.childViewControllers.contains(masterVC) {
                self.addChildViewController(masterVC)
            }
        }
        
        
        leftVC?.view.transform = CGAffineTransform(translationX: -maxWidth , y: 0)
        leftVC?.view.frame.size.width = maxWidth
        leftVC?.view.layoutIfNeeded()
        
        if visibleViewController != nil {
           
            addScreenEdgePanGestureRecognizerToView(view: visibleViewController!.view)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination
        let identifier = segue.identifier

        if identifier == Identifier.master {
            masterVC = vc
        }
        else if identifier == Identifier.left {
            leftVC = vc
        }
        
        updateVC()
    }
    
    fileprivate var visibleViewController: UIViewController? {
        
        var sourcesVC: UIViewController?
        if let tabbarVC = masterVC as? UITabBarController {
            
            sourcesVC = tabbarVC.selectedViewController as? UINavigationController ?? tabbarVC.selectedViewController
        }
        else if let nav = masterVC as? UINavigationController {
            sourcesVC = nav.visibleViewController
        }
        else {
            sourcesVC = masterVC
        }
        return sourcesVC
    }
    
    //MARK: - 侧边栏跳转功能1
    func wxPerformSegue(withIdentifier identifier: String, sender: Any?) {
        
        visibleViewController?.performSegue(withIdentifier: identifier, sender: sender)
        closeLeftMenu()
    }
    
    //MARK: - 侧边栏跳转功能2
    func LeftViewController(didSelectController view: UIViewController) {
        
        var nav: UINavigationController?
        if let tabbarVC = masterVC as? UITabBarController {
            nav = tabbarVC.selectedViewController as? UINavigationController
            view.hidesBottomBarWhenPushed = true
        }
        else if let viewController = masterVC.navigationController {
            nav = viewController
        }
        else {
            nav = masterVC as? UINavigationController
        }
        
        if nav == nil {
            masterVC.present(view, animated: true)
        }
        else {
            nav?.pushViewController(view, animated: false)
        }
        closeLeftMenu()
    }
    
    //MARK: - 添加屏幕边缘手势
    private func addScreenEdgePanGestureRecognizerToView(view: UIView) {
        
        if view.gestureRecognizers == nil {
            let pan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgPanGesture(_:)))
            if view.gestureRecognizers != nil {
                if view.gestureRecognizers!.contains(pan) { return }
            }
            pan.edges = UIRectEdge.left
            view.addGestureRecognizer(pan)
        }
       
    }

    //MARK: - 屏幕左边缘手势
    @objc func edgPanGesture(_ pan: UIScreenEdgePanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        print(offsetX)
        if pan.state == UIGestureRecognizerState.changed && offsetX <= maxWidth {
            
            masterVC?.view.transform = CGAffineTransform(translationX: max(offsetX, 0), y: 0)
            leftVC?.view.transform = CGAffineTransform(translationX: -maxWidth + offsetX, y: 0)
            
        } else if pan.state == UIGestureRecognizerState.ended || pan.state == UIGestureRecognizerState.cancelled || pan.state == UIGestureRecognizerState.failed {
            
            if offsetX > screenW * 0.5 {
                
                openLeftMenu()
                
            } else {
                
                closeLeftMenu()
            }
            
        }
        
    }
    
    //MARK: - 遮盖按钮手势
    @objc func panCloseLeftMenu(_ pan: UIPanGestureRecognizer) {
        
        let offsetX = pan.translation(in: pan.view).x
        
        print(offsetX)
        if offsetX > 0 {return}
        
        if pan.state == UIGestureRecognizerState.changed && offsetX >= -maxWidth {
            
            let distace = maxWidth + offsetX
            
            masterVC?.view.transform = CGAffineTransform(translationX: distace, y: 0)
            leftVC?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
            
        } else if pan.state == UIGestureRecognizerState.ended || pan.state == UIGestureRecognizerState.cancelled || pan.state == UIGestureRecognizerState.failed {
            
            if offsetX > -screenW * 0.5 {
                
                openLeftMenu()
                
            } else {
                
                closeLeftMenu()
            }
            
        }
        
    }
    
    //MARK: - 打开左侧菜单
    func openLeftMenu() {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            self.leftVC?.view.transform = CGAffineTransform.identity
            self.masterVC?.view.transform = CGAffineTransform(translationX: self.maxWidth, y: 0)
            
            
        }, completion: {
            
            (finish: Bool) -> () in
            
            self.masterVC?.view.addSubview(self.coverBtn)
            
        })
        
    }
    
    //MARK: - 关闭左侧菜单
    @objc func closeLeftMenu() {
        
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            self.leftVC?.view.transform = CGAffineTransform(translationX: -self.maxWidth, y: 0)
            self.masterVC?.view.transform = CGAffineTransform.identity
            
            
        }, completion: {
            
            (finish: Bool) -> () in
            
            self.coverBtn.removeFromSuperview()
            
        })
    }
    
    //MARK: - 灰色背景按钮
    private lazy var coverBtn: UIButton = {
        
        let btn = UIButton(frame: (self.masterVC?.view.bounds)!)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(closeLeftMenu), for: .touchUpInside)
        btn.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panCloseLeftMenu(_:))))
        
        return btn
        
    }()
   
    
}

