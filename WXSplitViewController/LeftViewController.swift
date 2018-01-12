//
//  LeftViewController.swift
//  WXSplitViewController
//
//  Created by 梦烙时光 on 2018/1/11.
//  Copyright © 2018年 StarHoa. All rights reserved.
//

import UIKit

class LeftViewController: UITableViewController {
    
    @IBAction func act() {
        self.splitVC()?.wxPerformSegue(withIdentifier: "ooo", sender: nil)
    }
    @IBAction func pushMainPage() {
        
        self.splitVC()?.closeLeftMenu()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.splitVC()?.wxPerformSegue(withIdentifier: "ICB \(indexPath.row)", sender: nil)
    }

}
