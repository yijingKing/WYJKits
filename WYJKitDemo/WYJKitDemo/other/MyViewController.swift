//
//  MyViewController.swift
//  QYKitDemo
//
//  Created by 祎 on 2020/8/28.
//  Copyright © 2020 祎. All rights reserved.
//

import UIKit

class MyViewController: QYBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        yi_barStyle = .lightContent
        // Do any additional setup after loading the view.
        view.backgroundColor = .yi_random()
//        yi_addTableView()
//        mainTableView?.yi_cellForRowAtIndexPath({ (tab, inde) -> UITableViewCell in
//            return UITableViewCell()
//            }).yi_numberRows(100)
//        mainTableView?.yi_heightRows(50)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        QYHUD.yi_loading("oooolplpl")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
