//
//  ViewController.swift
//  BruteForceTask
//
//  Created by Artem Mushtakov on 06.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var buttonColorView: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var isSearchPassword = true
    
    private var isBlack: Bool = false {
        didSet {
            if isBlack {
                changeColorElements(isBlack: isBlack)
            } else {
                changeColorElements(isBlack: isBlack)
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.isSecureTextEntry.toggle()
        activityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Actions
    
    @IBAction func changeColorView(_ sender: Any) {
        isBlack.toggle()
    }
    
    /**
     Функция генерации и подбора пароля.

     Данная функция разбивает пароль на массив символов (которые вызываются в функции подбора пароля) и создает из них операции которые выполняются в асинхронном потоке,  при завершении всех этих операций вызывается асинхронно функция на main потоке для изменения Ui интерфейса.

     - passwordText входящий пароль который нужно подобрать.
     - character константа для разбития пароля на массив String.
     - queue очередь для выполнения подбора пароля.
     - arrayBruteForce массив для выполнения посимвольного подбора пароля.

     - Authors: Mushtakov Artem, email: a.vladimirovich@internet.ru
     */
    
    @IBAction func generateRandomPassword(_ sender: Any) {
        
        if isSearchPassword {
            changingStatesElements(passwordSelectionState: .start)
        } else {
            changingStatesElements(passwordSelectionState: .search)

            let passwordText = textField.text ?? "Error"
            let character =  passwordText.split(by: Metric.characterCount)
            let queue = OperationQueue()
            var arrayBruteForce: [BruteForcePassword] = []

            for i in character {
                arrayBruteForce.append(BruteForcePassword(password: i))
            }

            for i in arrayBruteForce {
                queue.addOperation(i)
            }

            queue.addBarrierBlock {
                DispatchQueue.main.async {
                    self.changingStatesElements(passwordSelectionState: .complete)
                }
            }
        }
    }
    
    // MARK: - Setup elements
    
    /**
     Функция используется для изменения цвета Ui элементов в зависимости от флага isBlack.
     - parameters:
     - isBlack: Параметр bool для выбора флага при нажатии на кнопку.
     - Authors: Mushtakov Artem, email: a.vladimirovich@internet.ru
     */
    
    private func changeColorElements(isBlack: Bool) {
        if isBlack {
            view.backgroundColor = .black
            label.textColor = .white
            buttonColorView.backgroundColor = .white
            buttonColorView.tintColor = .black
            buttonStart.backgroundColor = .white
            buttonStart.tintColor = .black
        } else {
            view.backgroundColor = .white
            label.textColor = .black
            buttonColorView.backgroundColor = .black
            buttonColorView.tintColor = .white
            buttonStart.backgroundColor = .black
            buttonStart.tintColor = .white
        }
    }
    
    // MARK: - Password selection status
    
    /**
     Функция используется для настройки Ui элементов в зависимости от состояния подбора пароля.
     - parameters:
     - passwordSelectionState: Параметр enum PasswordSelectionState для выбора состояния относительно которого будет изменен Ui.
     - Authors: Mushtakov Artem, email: a.vladimirovich@internet.ru
     */
    
    private func changingStatesElements(passwordSelectionState: PasswordSelectionState) {
        
        switch passwordSelectionState {
        case .start:
            label.text = "Пароль сгенерирован! \n Нажмите Start для запуска подбора пароля!"
            textField.text = Metric.stringRandom
            textField.isSecureTextEntry = true
            isSearchPassword = false
            activityIndicator.stopAnimating()
            buttonStart.backgroundColor = .green
        case .search:
            label.text = "Здесь отобразится пароль!"
            textField.isUserInteractionEnabled = false
            buttonStart.isUserInteractionEnabled = false
            buttonStart.setTitle("Идет подбор пароля...", for: .normal)
            buttonStart.titleLabel?.textAlignment = .center
            changeColorElements(isBlack: isBlack)
            isSearchPassword = true
            activityIndicator.startAnimating()
        case .complete:
            label.text = "Ваш пароль подобран: \(self.textField.text ?? "Error") \n Нажмите Start для повторной генерации!"
            textField.isSecureTextEntry = false
            textField.isUserInteractionEnabled = true
            buttonStart.isUserInteractionEnabled = true
            buttonStart.setTitle("Start", for: .normal)
            activityIndicator.stopAnimating()
        }
    }
}

extension ViewController {

    enum Metric {
        static let characterCount = 2
        static let stringRandom = String.random(length: 10)
    }
}
