//
//  ListTableViewController.swift
//  WXSplitViewController
//
//  Created by 梦烙时光 on 2018/1/12.
//  Copyright © 2018年 StarHoa. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController
{

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = WXSplitViewController()
            vc.masterLeftIsLoadFromStoryboard = false
            vc.maxWidth = 100
            vc.masterVC = UINavigationController(rootViewController: UIStoryboard.controller(type: MasterViewController.self))
            vc.leftVC = UIStoryboard.controller(type: LeftViewController.self)
            vc.view.backgroundColor = .red
            navigationController?.pushViewController(vc, animated: true)
        }
    }
   

}
