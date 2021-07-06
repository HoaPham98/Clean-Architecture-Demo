//
//  ViewController.swift
//  Example
//
//  Created by Admin on 21/06/2021.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onTap(_ sender: Any) {
        let vc = ListProductViewController()
        vc.viewModel = .init(networkServiceProvider: Application.shared, coordinator: vc.coordinator)
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
    }
    
}

