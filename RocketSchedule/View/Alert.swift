//
//  Alert.swift
//  RocketSchedule
//
//  Created by Gabriela Bezerra on 04/07/18.
//  Copyright © 2018 Peteleco. All rights reserved.
//

import Foundation
import UIKit


extension UIWindow {
    // Retorna a view controller visível atual, se ela estiver no contexto da UIWindow.
    @objc public var visibleViewController: UIViewController? {
        return UIWindow.visibleViewController(from: rootViewController)
        
    }
    
    /*
     * Recursivamente segue as navigation controller, tab bar controllers e modal presented view controllers começando
     * da view controller fornecida para encontrar a view controller visível atual.
     *
     * - Parametros:
     *   - viewController: a view controller que servirá como ponto de partida da busca.
     * - Retorno:
     *   - A view controller visível atual mais provável.
     */
    @objc public static func visibleViewController(from viewController: UIViewController?) -> UIViewController? {
        switch viewController {
        case let navigationController as UINavigationController:
            return UIWindow.visibleViewController(from: navigationController.visibleViewController ?? navigationController.topViewController)
            
        case let tabBarController as UITabBarController:
            return UIWindow.visibleViewController(from: tabBarController.selectedViewController)
            
        case let presentingViewController where viewController?.presentedViewController != nil:
            return UIWindow.visibleViewController(from: presentingViewController?.presentedViewController)
            
        default:
            return viewController
        }
    }
    
}




class Alert {
    
    static var isBeingPresented: Bool = false
    
    /*   - Parametros:
     *     - title    :   O título do Alert. Por padrão será mostrado em negrito e com letra maior.
     *     - msg      :   A mensagem do Alert. Por padrão será mostrado com fonte regular, e letra menor.
     *     - view     :   View controller na qual o Alert será exibido. Se o parametro for nulo, ou se a chamada do método for feita sem ele, o valor dele será o da view controller visível atual (extensão da UIWindow).
     *     - function :   Uma função ou bloco de código que será executado após o usuário selecionar o botao "Sim". Se a chamada de método for feita sem esse parâmetro, a função é vazia.
     *
     *   - Retorno:
     *    - Nulo. O comportamento esperado é a exibição de um Alert com o texto inserido em "title" e em "msg", com botões de "Sim" e "Não". Após o botão sim seja selecionado, executa o código de "function".
     */
    static func showYesOrNo(title: String, msg: String, view: UIViewController? = nil, function: @escaping (()->()) = { } ) {
        if !isBeingPresented {
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            
            let noAction  = UIAlertAction(title: "Cancelar", style: .cancel) { UIAlertAction in isBeingPresented = false }
            let yesAction = UIAlertAction(title: "Sim", style: .default) { UIAlertAction in
                function()
                isBeingPresented = false
            }
            
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            
            if let view = view {
                view.present(alertController, animated: true, completion: nil)
            } else if let view = UIApplication.shared.keyWindow?.visibleViewController {
                view.present(alertController, animated: true, completion: nil)
            }
            isBeingPresented = true
        }
    }
    
    
    
    /*   - Parametros:
     *     - title    :   O título do Alert. Por padrão será mostrado em negrito e com letra maior.
     *     - msg      :   A mensagem do Alert. Por padrão será mostrado com fonte regular, e letra menor.
     *     - view     :   View controller na qual o Alert será exibido. Se o parametro for nulo, ou se a chamada do método for feita sem ele, o valor dele será o da view controller visível atual (extensão da UIWindow).
     *     - function :   Uma função ou bloco de código que será executado após o usuário selecionar o botao "OK". Se a chamada de método for feita sem esse parâmetro, a função é vazia.
     *
     *   - Retorno:
     *    - Nulo. O comportamento esperado é a exibição de um Alert com o texto inserido em "title" e em "msg", com botão "OK". Após o botão "OK" seja selecionado, executa o código de "function".
     */
    static func show(title: String, msg: String, view: UIViewController? = nil, function: @escaping (()->()) = { }) {
        if !isBeingPresented {
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
                function()
                isBeingPresented = false
            }
            alertController.addAction(okAction)
            
            if let view = view {
                view.present(alertController, animated: true, completion: nil)
            } else if let view = UIApplication.shared.keyWindow?.visibleViewController {
                view.present(alertController, animated: true, completion: nil)
            }
            isBeingPresented = true
        }
    }
}
