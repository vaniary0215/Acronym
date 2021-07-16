//
//  SearchViewController.swift
//  Acronym
//
//  Created by Ashish Vani on 16/07/21.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK:- Static Properties
    static var controller:SearchViewController {
        let sb = UIStoryboard.Name.main.board()
        let vc:SearchViewController = sb.instantiateViewController(withIdentifier: "\(SearchViewController.self)") as! SearchViewController
        return vc
    }
    
    //MARK:- Properties
    var vmSearch:SearchViewModel = SearchViewModel()
    
    //MARK:- IBOutlet
    @IBOutlet var tfSearch: UITextField!
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        tfSearch.resignFirstResponder()
        super.viewWillDisappear(animated)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        tfSearch.resignFirstResponder()
    }
    
    //MARK:- Private
    func navigateToDetails(search text:String) {
        let vcAcronymies = AcronymiesViewController.controller
        vcAcronymies.vmSearch.strSearch = text
        navigationController?.pushViewController(vcAcronymies, animated: true)
    }
    
    //MARK:- IBAction
    
    @IBAction func btnSearchTapped(_ sender: Any?) {
        let valid:Validation = vmSearch.isValidedTextInput(entered: tfSearch.text)
        if  valid.isValid, let strSearch = tfSearch.text {
            navigateToDetails(search: strSearch)
        }else {
            showAlert(title: UIAlertController.Title.error.rawValue, message: valid.error ?? UIAlertController.Message.emptySearchText.rawValue)
        }
    }
}

extension SearchViewController:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        btnSearchTapped(nil)
        textField.resignFirstResponder()
        return true
    }
}
