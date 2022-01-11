//
//  PasswordSelectionState.swift
//  BruteForceTask
//
//  Created by Artem Mushtakov on 06.01.2022.
//

import Foundation

/**
 Этот enum используется для различной настройки Ui элементов в зависимости от состояния подбора пароля.
 - start: этот кейс используется при генерации пароля.
 - search: этот кейс используется при подборе пароля.
 - complete: этот кейс используется при успешном подборе пароля.
 - Authors: Mushtakov Artem, email: a.vladimirovich@internet.ru
 */

enum PasswordSelectionState {
    case start
    case search
    case complete
}
