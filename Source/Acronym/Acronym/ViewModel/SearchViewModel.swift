//
//  SearchViewModel.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import UIKit
typealias Validation = (isValid:Bool, error:String?)
class SearchViewModel {
    var strSearch:String?
    var items:[Acronym] = []
    
    func isValidedTextInput(entered text:String?)->Validation {
        var isValided:Bool = false
        var error:String? = nil
        
        if let t = text, !t.isEmpty {
            if (Int(t) ?? 0) == 0 {
                isValided = true
                error = nil
            }else { error = UIAlertController.Message.invalidSearchText.rawValue }
        }else { error = UIAlertController.Message.emptySearchText.rawValue }
        
        return (isValided, error)
    }
    
    
    func fetchAnronymDetails(of acronym:String, completion:@escaping((_ isSuccess:Bool, _ error:ServerError?)->Void)) {
        guard let appDelegate:AppDelegate = UIApplication.shared.delegate as? AppDelegate, appDelegate.network.isAvailable else {
            completion(false, ServerError.noInternet); return }
        guard !acronym.isEmpty else { return }
        
        let endPoint = APIEndPoint.acromine.endPoint().replacingOccurrences(of: APIQueryParam.sf.rawValue, with: acronym)
        
        APIManager.load(APIResource(url: endPoint, httpMethod: .get), parameter: nil, codableType: [AcronymDetails].self) { [weak self](response, jsonDecodeModel) in
            let strongSelf = self
            if let items = jsonDecodeModel as? [AcronymDetails] {
                strongSelf?.items = items.first?.lfs ?? []
                completion(true, nil); return;
            }
            completion(false, ServerError.invalidResponse); return;
        } onFailure: { [weak self](sError) in
            _ = self
            print(sError?.code ?? "code is nil", sError?.message ?? "message is nil")
            completion(false, sError); return;
        }
    }
}
