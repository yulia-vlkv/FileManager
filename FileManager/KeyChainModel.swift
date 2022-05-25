//
//  KeyChainModel.swift
//  FileManager
//
//  Created by Iuliia Volkova on 21.05.2022.
//

import Foundation

struct Credentials {
    var password: String?
    let serviceName = "UserCredentials"
}

class KeyChainModel {
    
    static var credentials = Credentials()
    
    static var sortSettings: SortType =  .ascending
    
//    static var sortSettings: SortType = SortType(rawValue: UserDefaults.standard.string(forKey: "sortType")!) ?? .ascending
//    UserDefaults.standard.string(forKey: "sortType")
//    if let sortSettings = sortSettings {
//        KeyChainModel.sortType = .init(rawValue: sortSettings)
//    }
//    static var sortSettings: SortType = .ascending
//
    func setPassword(with credentials: Credentials) {
        // Переводим пароль в объект класс Data
        guard let passData = credentials.password?.data(using: .utf8) else {
            print("Невозможно получить Data из пароля")
            return
        }

        // Создаем атрибуты для хранения файла
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecValueData: passData,
            kSecAttrService: credentials.serviceName,
        ] as CFDictionary

        // Добавляем новую запись в Keychain
        let status = SecItemAdd(attributes, nil)

        guard status == errSecDuplicateItem || status == errSecSuccess else {
            print("Невозможно добавить пароль, ошибка номер: \(status)")
            return
        }

        print("Новый пароль добавлен успешно")
    }

    func retrievePassword(with credentials: Credentials) -> String? {
        // Создаем поисковые атрибуты
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.serviceName,
            kSecReturnData: true
        ] as CFDictionary

        // Объявляем ссылку на объект, которая в будущем будет указывать на полученную запись Keychain
        var extractedData: AnyObject?
        // Запрашиваем запись в keychain
        let status = SecItemCopyMatching(query, &extractedData)

        guard status == errSecItemNotFound || status == errSecSuccess else {
            print("Невозможно получить пароль, ошибка номер: \(status)")
            return nil
        }

        guard status != errSecItemNotFound else {
            print("Пароль не найден в Keychain")
            return nil
        }

        guard let passData = extractedData as? Data,
              let password = String(data: passData, encoding: .utf8) else {
            print("невозможно преобразовать data в пароль")
            return nil
        }

        return password
    }

    func updatePassword(with credentials: Credentials) {
        // Переводим пароль в объект класс Data
        guard let passData = credentials.password?.data(using: .utf8) else {
            print("Невозможно получить Data из пароля")
            return
        }

        // Создаем поисковые атрибуты
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.serviceName,
            kSecReturnData: false // не обязательно, false по- умолчанию
        ] as CFDictionary

        let attributesToUpdate = [
            kSecValueData: passData,
        ] as CFDictionary

        let status = SecItemUpdate(query, attributesToUpdate)

        guard status == errSecSuccess else {
            print("Невозможно обновить пароль, ошибка номер: \(status)")
            return
        }

        print("Новый пароль обновлен успешно")
    }

    func deletePassword(with credentials: Credentials) {
        // Создаем поисковые атрибуты
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: credentials.serviceName,
            kSecReturnData: false  // не обязательно, false по- умолчанию
        ] as CFDictionary

        let status = SecItemDelete(query)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Невозможно удалить пароль, ошибка номер: \(status)")
            return
        }

        print("Пароль удален успешно")
    }
}
