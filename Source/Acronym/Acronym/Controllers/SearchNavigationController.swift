//
//  SearchNavigationController.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import UIKit

class SearchNavigationController: UINavigationController {
    
    static var controller:SearchNavigationController {
        let sb = UIStoryboard.Name.main.board()
        let vc:SearchNavigationController = sb.instantiateViewController(withIdentifier: "\(SearchNavigationController.self)") as! SearchNavigationController
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
