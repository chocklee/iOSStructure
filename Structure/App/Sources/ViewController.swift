//
//  ViewController.swift
//  Structure
//
//  Created by Changhao Li on 2023/3/6.
//

import UIKit
import PillarDependencyBase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print(PillarRootContainer.aPillar.openA.pillarName())
    }
}

