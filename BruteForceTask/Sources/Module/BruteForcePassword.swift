//
//  BruteForcePassword.swift
//  BruteForceTask
//
//  Created by Артем on 06.01.2022.
//

import Foundation

/**
 Этот класс используется для запуска выполнения функции (bruteForce) асинхронно с потоком main.
 - Authors: Mushtakov Artem, email: a.vladimirovich@internet.ru
 */

class BruteForcePassword: Operation {
    
    // MARK: - Properties
    
    private var password: String
    
    // MARK: - Initial
    
    init(password: String) {
        self.password = password
    }
    
    // MARK: - Setup operation
    
    override func main() {
        if self.isCancelled {
            return
        }
        bruteForce(passwordToUnlock: password)
    }
    
    // MARK: - Setup password selection
    
    /**
     Функция подбора пароля.
     - parameters:
       - passwordToUnlock: Входящий параметр пароля который нужно подобрать.
     */
    
    private func bruteForce(passwordToUnlock: String) {
        let allowedCharacters: [String] = String().printable.map { String($0) }
        
        var password = ""
        while password != passwordToUnlock {
            password = generateBruteForce(password, fromArray: allowedCharacters)
            print(password)
        }
        print(password)
    }
    
    /**
     Функция перебора символов для пароля.
     - parameters:
       - passwordToUnlock: Входящий параметр пароля который нужно подобрать.
       - array: Массив строк состоящих из символов.
     */
    
    private func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str = string
        
        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        } else {
            str.replace(at: str.count - 1,
                        with: characterAt(
                            index: (indexOf(
                                character: str.last ?? " ", array) + 1) % array.count, array))
            
            if indexOf(character: str.last ?? " ", array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last ?? " ")
            }
        }
        return str
    }
    
    /**
     Функция генерации символов пароля.
     - parameters:
       - passwordToUnlock: Входящий параметр пароля который нужно подобрать.
     */
    
    private func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character)) ?? Int()
    }
    
    /**
     Функция возвращает символ из строки по заданному индексу **index**
     - parameters:
       - index: Входящий параметр пароля который нужно подобрать.
       - array: Массив строк состоящих из символов.
     */
    
    private func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index]) : Character("")
    }
}
