//
//  ViewController.swift
//  BREDR
//
//  Created by EZen on 2021/3/12.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        BLEManager.shared.scan()
    }
}

