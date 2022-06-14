//
//  SelectionViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 17/5/22.
//

import UIKit
import FittedSheets

class SelectionViewController: UIViewController, UITabBarControllerDelegate {

    //Este controlador es un medio camino en la pantalla de login.
    let def = UserDefaults.standard
    
    let options = SheetOptions(
        useInlineMode: true
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Se comprueba si el bool de "logued" esta a true, en cuyo caso el usuario esta logueado e instancia el modal de usuario, si no esta logueado, instancia el inicio de sesion.
         if !def.bool(forKey: "logued"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
            self.navigationController?.pushViewController(vc, animated: true)
             
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "user") as! LogedUserViewController
            tabBarController?.present(vc, animated: true)
           
        }

    }
    
    
    
   
}
