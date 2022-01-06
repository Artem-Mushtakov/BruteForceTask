//
//  ViewController.swift
//  BruteForceTask
//
//  Created by Artem Mushtakov on 06.01.2022.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlet

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    //MARK: - Properties

    var isSearchPassword = true

    var isBlack: Bool = false {
        didSet {
            if isBlack {
                changeColorElements(isBlack: isBlack)
            } else {
                changeColorElements(isBlack: isBlack)
            }
        }
    }

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.isSecureTextEntry.toggle()
        activityIndicator.hidesWhenStopped = true
    }

    //MARK: - Actions

    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }

    @IBAction func generateRandomPassword(_ sender: Any) {

        if isSearchPassword {
            changingStatesElements(passwordSelectionState: .start)
        } else {
            changingStatesElements(passwordSelectionState: .search)

            let bruteForcePassword = BruteForcePassword(password: textField.text ?? "Error")
            let queue = OperationQueue()
            let mainQueue = OperationQueue.main

            queue.addOperation(bruteForcePassword)

            let operationBlock = BlockOperation {
                self.changingStatesElements(passwordSelectionState: .complete)
            }

            bruteForcePassword.completionBlock = {
                mainQueue.addOperation(operationBlock)
            }
        }
    }

    //MARK: - Setup elements

    func changeColorElements(isBlack: Bool) {
        if isBlack {
            view.backgroundColor = .black
            label.textColor = .white
            button.backgroundColor = .white
            button.tintColor = .black
            buttonStart.backgroundColor = .white
            buttonStart.tintColor = .black
        } else {
            view.backgroundColor = .white
            label.textColor = .black
            button.backgroundColor = .black
            button.tintColor = .white
            buttonStart.backgroundColor = .black
            buttonStart.tintColor = .white
        }
    }

    //MARK: - Password selection status

    func changingStatesElements(passwordSelectionState: PasswordSelectionState) {
        
        switch passwordSelectionState {
        case .start:
            label.text = "Пароль сгенерирован! \n Нажмите Start для запуска подбора пароля!"
            textField.text = "zzz" //String.random() // Для рандомной генерации раскомментировать String.random()
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

extension String {

    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }

    static func random(length: Int = 4) -> String {
        let base = "abcdefghijklmnopqrstuvw<=>?@[\\]^_`MNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}