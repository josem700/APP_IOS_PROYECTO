//
//  ContactoViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 24/5/22.
//

import UIKit
import MessageUI
class ContactoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var NombreText: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var TlfnText: UITextField!
    @IBOutlet weak var DireccionText: UITextField!
    @IBOutlet weak var MensajeText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action:     #selector(tapGestureHandler))
              view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tapGestureHandler() {
        NombreText.endEditing(true)
        EmailText.endEditing(true)
        TlfnText.endEditing(true)
        DireccionText.endEditing(true)
        MensajeText.endEditing(true)
      }
    
    @IBAction func EnviarBtn(_ sender: Any) {
        if NombreText.text == "" {
            let alert = UIAlertController(title: "Error", message: "Error, el campo nombre no puede estar vacio", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        }
        
        else if EmailText.text == ""{
            let alert = UIAlertController(title: "Error", message: "Error, el campo email no puede estar vacio", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        else if !isValidEmail(string: EmailText.text!){
            let alert = UIAlertController(title: "Error", message: "¡Vaya!, Ese no parece un email válido", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        else if TlfnText.text == ""{
            let alert = UIAlertController(title: "Error", message: "Error, el campo telefono no puede estar vacío", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        else if !isValidPhone(string: TlfnText.text!){
            let alert = UIAlertController(title: "Error", message: "Error, el número de telefono no tiene un formato válido", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        else if DireccionText.text == "" {
            let alert = UIAlertController(title: "Error", message: "Error, el campo direccion no puede estar vacio", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        else if MensajeText.text == "" {
            let alert = UIAlertController(title: "Error", message: "Error, el campo mensaje no puede estar vacio", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        else{
            
            let mailURL = URL(string: "message://Datos cliente: Nombre: \(String(describing: NombreText.text)) \n Email: \(String(describing: EmailText.text)) \n Telefono: \(String(describing: TlfnText.text)) \n Direccion: \(String(describing: DireccionText.text)) \n Mensaje: \(String(describing: MensajeText.text))")
            
                if let mailURL = mailURL {
                    if UIApplication.shared.canOpenURL(mailURL) {
                        UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
                    }
                }
        }
    }
    
    func isValidEmail(string: String) -> Bool {
        //Funcion con expresion regular para comprobar si el email es valido
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: string)
    }
    
    func isValidPhone(string: String) -> Bool {
        //Funcion con expresion regular para comprobar si el email es valido
        let emailReg = "(\\+34|0034|34)?[ -]*(6|7)[ -]*([0-9][ -]*){8}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: string)
    }

    @IBAction func CloseBtn(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
