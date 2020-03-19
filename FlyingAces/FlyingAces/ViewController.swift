//
//  ViewController.swift
//  FlyingAces
//
//  Created by Benjamin Simpson on 1/23/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation
import UIKit

class ScrolleExampleVC: UIViewController, UIScrollViewDelegate {
    

    @IBOutlet weak var scrollView: UIScrollView!
    
override func viewDidLoad(){
    super.viewDidLoad()
    scrollView.delegate = self
}
}
