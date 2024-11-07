//
//  Untitled.swift
//  catGenerator
//
//  Created by Иван Тарасюк on 07.11.2024.
//

import UIKit

class UICatViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBAction func didTapButton(_ sender: UIButton) {
        print("cat generate")
        downloadButton.isEnabled = false
        activityIndicator.startAnimating()
        statusLabel.text = "Start downloading the cat!"
        downloadCat(with: textField.text!)
    }
    
    
    // Переменная для хранения ссылки на активное поле ввода
    private var activeTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.text = "Ready to download!"
        activityIndicator.hidesWhenStopped = true
        
        // Настройка делегата для textField, чтобы скрывать клавиатуру при нажатии Return
        textField.delegate = self
        
        // Подписка на уведомления о появлении и скрытии клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Добавляем распознаватель нажатий для скрытия клавиатуры при касании экрана
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // Метод для скрытия клавиатуры
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Обработка появления клавиатуры
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            scrollView.scrollIndicatorInsets = scrollView.contentInset
        }
    }
        
    // Обработка скрытия клавиатуры
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = .zero
        scrollView.scrollIndicatorInsets.bottom = .zero
    }
        
    // Скрытие клавиатуры при нажатии кнопки Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func downloadCat(with text: String) {
        guard let url = URL(string: "https://cataas.com/cat/says/\(text)?FontSize=50&fontColor=white") else {
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
