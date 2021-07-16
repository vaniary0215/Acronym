//
//  APIConstants.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import Foundation

enum APIBaseURL:String {
    case prod = "http://www.nactem.ac.uk/software/"
}

enum APIEndPoint : String {
    case acromine = "acromine/dictionary.py?sf=@@sf@@"
    
    func endPoint(base url:String = APIBaseURL.prod.rawValue) -> String {
        return url + self.rawValue
    }
}

enum APIMethod: String {
    case get  = "GET"    
}

struct APIResource {
    let url: String
    let httpMethod: APIMethod
}

typealias SuccessCallBlock = ((Data, Any)->Void)
typealias FailureCallBlock = ((ServerError?)->Void)


struct ServerError: Codable {
    var message: String
    var code: String?
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
        case code = "code"
    }
    
    static let invalidResponse = ServerError(message: APIError.invalidResponse.message ?? "", code: APIError.invalidResponse.rawValue)
    static let noInternet = ServerError(message: APIError.noInternet.message ?? "", code: APIError.noInternet.rawValue)
    static let invalidRequest = ServerError(message: APIError.invalidRequest.message ?? "", code: APIError.invalidRequest.rawValue)
}

enum APIError:String {
    case none = "none"
    case noInternet = "no_internet"
    case somethingWentWrong = "something_went_wrong"
    case invalidResponse = "invalid_response"
    case invalidRequest = "invalid_request"

    var message:String? {
        switch self {
        case .somethingWentWrong: return "Something Went Wrong!"
        case .noInternet: return "There is no Internet connectivity, Please check you network and try again!"
        case .invalidResponse: return "Invalid resopnse!"
        case .invalidRequest: return "Invalid request!"
        default: return nil
        }
    }
}

enum APIQueryParam: String {
    case sf = "@@sf@@"
}
