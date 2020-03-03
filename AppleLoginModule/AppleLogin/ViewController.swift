//
//  ViewController.swift
//  AppleLogin
//
//  Created by Jinnify on 2020/03/03.
//  Copyright © 2020 Jinnify. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    @IBOutlet weak var loginStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupProviderLoginView()
    }
    
    func setupProviderLoginView() {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        button.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginStackView.addArrangedSubview(button)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
}

extension ViewController: ASAuthorizationControllerDelegate {
    
    // 성공시 인증 정보를 반환 받는다.
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            print("#1", userIdentifier)
            print("#2", fullName)
            print("#3", email)
            
        case let passwordCredential as ASPasswordCredential:
            let userName = passwordCredential.user
            let password = passwordCredential.password
            
            print("#4", userName)
            print("#5", password)
            
        default:
            break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print("#6", error)
    }
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    
    // presentation context를 어디에 띄울지 UI에 가장 적합한 뷰 앵커를 반환한다.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
