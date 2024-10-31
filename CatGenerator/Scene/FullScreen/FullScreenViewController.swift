//
//  FullScreenViewController.swift
//  CatGenerator
//
//  Created by Maxim Makarenkov on 31.10.2024.
//

import UIKit

struct Input {
    let imageData: Data
}

class FullScreenViewController: UIViewController {

    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var input: Input?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scrollView.delegate = self
        
        if let input = input {
            catImage.image = UIImage(data: input.imageData)
        }
    }
    
    func setInput(with input: Input) {
        self.input = input
    }

}

extension FullScreenViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return catImage
    }
}
