//
//  MasterViewController.swift
//  WXSplitViewController
//
//  Created by 梦烙时光 on 2018/1/11.
//  Copyright © 2018年 StarHoa. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    
    @IBAction func popMenu() {
        
        self.splitVC()?.openLeftMenu()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func pop() {
        self.splitVC()?.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
