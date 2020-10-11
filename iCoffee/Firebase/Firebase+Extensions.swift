//
//  Firebase+Extensions.swift
//  iCoffee
//

import Foundation
import Firebase
import CodableFirebase

extension QuerySnapshot {
    func decode<T: Codable>() -> [T] {
        documents.compactMap { try? FirebaseDecoder().decode(T.self, from: $0.data()) }
    }
}

extension DocumentSnapshot {
    func decode<T: Codable>() -> T? {
        try? FirebaseDecoder().decode(T.self, from: data())
    }
}

extension AuthErrorCode {
    var description: String? {
        switch self {
        case .emailAlreadyInUse:
            return "Этот адрес электронной почты уже используется другим пользователем"
        case .userDisabled:
            return "Этот пользователь отключен"
        case .operationNotAllowed:
            return "Операция запрещена"
        case .invalidEmail:
            return "Неверный адрес электронной почты"
        case .wrongPassword:
            return "Неверный пароль"
        case .userNotFound:
            return "Аккаунт пользователя с указанным адресом электронной почты не найден"
        case .networkError:
            return "Проблема с подключением к серверу"
        case .weakPassword:
            return "Очень слабый или неверный пароль"
        case .missingEmail:
            return "Вам необходимо зарегистрировать электронную почту"
        case .internalError:
            return "Внутренняя ошибка"
        case .invalidCustomToken:
            return "Недействительный пользовательский токен"
        case .tooManyRequests:
            return "Слишком много запросов отправлено на сервер"
        default:
            return nil
        }
    }
}

extension FirestoreErrorCode {
    var description: String? {
        switch self {
        case .cancelled:
            return "Операция отменена"
        case .unknown:
            return "Неизвестная ошибка"
        case .invalidArgument:
            return "Недопустимый аргумент"
        case .notFound:
            return "Документ не найден"
        case .alreadyExists:
            return "Документ, который будет создан, уже существует"
        case .permissionDenied:
            return "У вас нет прав на выполнение этой операции"
        case .aborted:
            return "Операция прервана"
        case .outOfRange:
            return "Запрашиваемые данные отсутствуют"
        case .unimplemented:
            return "Эта операция не реализована или еще не поддерживается"
        case .internal:
            return "Внутренняя ошибка"
        case .unavailable:
            return "В данный момент услуга недоступна, попробуйте позже"
        case .unauthenticated:
            return "Неаутентифицированный пользователь"
        default:
            return nil
        }
    } }

extension StorageErrorCode {
    var description: String? {
        switch self {
        case .unknown:
            return "Неизвестная ошибка"
        case .quotaExceeded:
            return "Недостаточно места для сохранения"
        case .unauthenticated:
            return "Неаутентифицированный пользователь"
        case .unauthorized:
            return "Пользователь не авторизован для выполнения этой операции"
        case .retryLimitExceeded:
            return "Превышено количество попыток"
        case .downloadSizeExceeded:
            return "Размер загружаемого файла превышает превышает допустимый"
        case .cancelled:
            return "Операция отменена"
        default:
            return nil
        }
    } }

extension Error {
    var localizedDescription: String {
        let error = self as NSError
        if error.domain == AuthErrorDomain {
            if let code = AuthErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
        } else if error.domain == FirestoreErrorDomain {
            if let code = FirestoreErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
        } else if error.domain == StorageErrorDomain {
            if let code = StorageErrorCode(rawValue: error.code) {
                if let errorString = code.description {
                    return errorString
                }
            }
        }
        return error.localizedDescription
    } }
