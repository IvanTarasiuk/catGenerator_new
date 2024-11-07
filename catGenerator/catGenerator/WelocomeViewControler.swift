//
//  WelocomeViewControler.swift
//  catGenerator
//
//  Created by Иван Тарасюк on 01.11.2024.
//

import UIKit

class WelcomeViewController: UIViewController, UITextViewDelegate {
    

    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBAction func didTapButton(_ sender: UIButton) {
        print("cat generate")
        downloadButton.isEnabled = false
        activityIndicator.startAnimating()
        statusLabel.text = "Start downloading the cat!"
        downloadCat()
    }
    
    // Переменная для хранения ссылки на активное поле ввода
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = "Ready to download!"
        activityIndicator.hidesWhenStopped = true
    }
    
    private func downloadCat() {
        guard let url = URL(string: "https://cataas.com/cat") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async { [weak self] in
                    // В случае ошибки снова разблокируем кнопку и обновим статус
                    self?.statusLabel.text = "Download error"
                    self?.activityIndicator.stopAnimating()
                    self?.downloadButton.isEnabled = true
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImageView.image = UIImage(data: data)
                self?.statusLabel.text = "Downloading is succesfull!"
                self?.activityIndicator.stopAnimating()
                self?.downloadButton.isEnabled = true
            }
        }
        task.resume()
    }
}
