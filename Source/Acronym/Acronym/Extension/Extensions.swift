//
//  Extensions.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import UIKit

extension UIAlertController {
    
    enum Action:String {
        case ok = "Ok"
        case cancel = "Cancel"
        case retry = "Retry"
    }
    
    enum Title:String {
        case app = "Acronym App"
        case warning = "Warning"
        case error = "Error"
    }
    
    enum Message:String  {
        case emptySearchText = "Please enter search text"
        case invalidSearchText = "Please enter valid search text"
    }
}

extension UIViewController {
    func showAlert(title strTitle:String = UIAlertController.Title.app.rawValue, message strMessage:String = "", actionDefault strDefault:String = UIAlertController.Action.ok.rawValue) {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: strDefault, style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}

extension Data {
    func convertDataIntoCodable<T: Codable>(codableType: T.Type) -> T? {
        guard let responseData = self as? Data else { return nil }
        do {
            let resModel = try JSONDecoder().decode(T.self, from: responseData)
            return resModel
        } catch DecodingError.typeMismatch( _, let context) {
            for i in 0..<context.codingPath.count { print("  [\(i)] = \(context.codingPath[i])") }
            return nil
        } catch let err {
            print(err.localizedDescription)
            return nil
        }
    }
}

extension UIStoryboard {
    enum Name:String {
        case main = "Main"
        
        func board()->UIStoryboard {
            if let sb:UIStoryboard = UIStoryboard(name: self.rawValue, bundle: nil) as? UIStoryboard {
                return sb
            }
            return UIStoryboard(name: UIStoryboard.Name.main.rawValue, bundle: nil)
        }
    }
}

extension UITableViewCell {
    enum Identifier:String {
        case acronymDetail = "AcronymDetailTableViewCell" 
    }
}
