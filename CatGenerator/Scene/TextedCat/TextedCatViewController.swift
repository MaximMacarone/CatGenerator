//
//  TextedCatViewController.swift
//  ConcerteApp
//
//  Created by Maxim Makarenkov on 30.10.2024.
//

import UIKit

class TextedCatViewController: UIViewController {

    @IBOutlet weak var fullScreenButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        
        view.addGestureRecognizer(gestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object:nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object:nil)
        
        title = "Texted Cat"
        textField.placeholder = "Enter text"
        
        statusLabel.text = "Введите текст!"
        activityIndicator.hidesWhenStopped = true
        
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        generateButton.isEnabled = false
        fullScreenButton.isEnabled = false
    }
    

    @IBAction func didTapButton(_ sender: Any) {
        catImageView.image = UIImage(systemName: "cat")
        generateButton.isEnabled = false
        fullScreenButton.isEnabled = false
        textField.isEnabled = false
        activityIndicator.startAnimating()
        statusLabel.text = "Начинаю загрузку кота!"
        downloadCat(textField.text ?? "")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        generateButton.isEnabled = !textField.text!.isEmpty
        statusLabel.text = !textField.text!.isEmpty ? "Готово к загрузке!" : "Введите текст!"
    }
    
    
    private func downloadCat(_ text: String) {
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImageView.image = UIImage(data: data)
                self?.imgData = data
                self?.statusLabel.text = "Загрузка кота закончена"
                self?.activityIndicator.stopAnimating()
                self?.generateButton.isEnabled = true
                self?.fullScreenButton.isEnabled = true
                self?.textField.isEnabled = true
            }
        }
        
        task.resume()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
       let keyboardHeight = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.height
       
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc
    private func didTapView() {
        view.endEditing(true)
    }
    
    private var imgData: Data?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showFullScreen" {
            guard
                let viewController: FullScreenViewController = segue.destination as? FullScreenViewController,
                let imgData = imgData
            else {
                return
            }
            
            viewController.setInput(with: Input(imageData: imgData))
        }
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
