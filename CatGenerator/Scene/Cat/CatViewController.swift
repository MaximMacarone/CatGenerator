//
//  CatViewController.swift
//  ConcerteApp
//
//  Created by Konstantin Kulakov on 27.10.2024.
//

import UIKit

class CatViewController: UIViewController {

    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var generateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Cat Generator"
        
        statusLabel.text = "Готов к загрузке!"
        activityIndicator.hidesWhenStopped = true
    }
    
    private func downloadCat() {
        guard let url = URL(string: "https://cataas.com/cat") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImageView.image = UIImage(data: data)
                self?.statusLabel.text = "Загрузка кота закончена"
                self?.activityIndicator.stopAnimating()
                self?.generateButton.isEnabled = true
            }
        }
        
        task.resume()
    }

    
    @IBAction func didTapButton(_ sender: Any) {
        catImageView.image = UIImage(systemName: "cat")
        generateButton.isEnabled = false
        activityIndicator.startAnimating()
        statusLabel.text = "Начинаю загрузку кота!"
        downloadCat()
    }
}

