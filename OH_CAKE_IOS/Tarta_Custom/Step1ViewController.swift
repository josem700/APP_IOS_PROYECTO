//
//  Step1ViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 25/4/22.
//

import UIKit

class Step1ViewController: UIViewController {

    //Outlets
    @IBOutlet weak var bigbtn: UIButton!
    @IBOutlet weak var mediumbtn: UIButton!
    @IBOutlet weak var smallbtn: UIButton!
    let defaults = UserDefaults.standard
    //Tamanio de la tarta
    var size = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    ///Botones para seleccionar el tamanio
    @IBAction func Small(_ sender: Any) {
        size = "small"
        if #available(iOS 15.0, *) {
            smallbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            mediumbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#FCF5F1")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            bigbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#FCF5F1")
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func Medium(_ sender: Any) {
        size = "medium"
        if #available(iOS 15.0, *) {
            smallbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#FCF5F1")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            mediumbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            bigbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#FCF5F1")
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func Big(_ sender: Any) {
        size = "xl"
        if #available(iOS 15.0, *) {
            smallbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#FCF5F1")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            mediumbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#FCF5F1")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            bigbtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    @IBAction func step2Btn(_ sender: Any){
        
        //Si el usuario no ha seleccionado el tamanio, lanza un error
        if !defaults.bool(forKey: "logued"){
            let alert = UIAlertController(title: "¿Quieres más?", message: "¡Registrate para personalizar tu propia tarta!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                
                self.tabBarController?.selectedIndex = 4
            })
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        else if size == ""{
            let alert = UIAlertController(title: "Error", message: "¡Necesitas decir el tamaño antes de continuar!", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        else{
            //Si lo ha seleccionado todo y no hay nada que se queje, instancia el siguiente controlador
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "paso2") as! Step2ViewController
            
            vc.size = size
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
