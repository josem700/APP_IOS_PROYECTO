//
//  RegistroViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 25/4/22.
//

import UIKit

class RegistroViewController: UIViewController {

    //Outlets
    @IBOutlet weak var nombreText: UITextField!
    @IBOutlet weak var ApellidosText: UITextField!
    @IBOutlet weak var telefonoText: UITextField!
    
    @IBOutlet weak var OtroBtn: UIButton!
    @IBOutlet weak var MujerBtn: UIButton!
    @IBOutlet weak var HombreBtn: UIButton!
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var PasswdText: UITextField!
    @IBOutlet weak var RepeatPasswdText: UITextField!
    
    var sexo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action:     #selector(tapGestureHandler))
              view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureHandler() {
        nombreText.endEditing(true)
        ApellidosText.endEditing(true)
        telefonoText.endEditing(true)
        emailText.endEditing(true)
        PasswdText.endEditing(true)
        RepeatPasswdText.endEditing(true)
      }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    @IBAction func registroBtn(_ sender: Any) {
        
        //Compruebo si los campos estan vacios y lanzo un alert
        if nombreText.text!.isEmpty || ApellidosText.text!.isEmpty || telefonoText.text!.isEmpty || emailText.text!.isEmpty || PasswdText.text!.isEmpty || RepeatPasswdText.text!.isEmpty {
            
            let alert = UIAlertController(title: "Error", message: "Error, completa todos los campos antes de continuar", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        //Compruebo si los campos de contraseña y repetir contraseña son iguales
        else if RepeatPasswdText.text != PasswdText.text{
            let alert = UIAlertController(title: "Error", message: "Error, las contraseñas no coinciden", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        //Compruebo si el cliente ha elegido su sexo (Esto se hace con fines puramente estadisticos)
        else if sexo == ""{
            let alert = UIAlertController(title: "Error", message: "Por favor, especifica tu sexo, si prefieres no especificar, selecciona otro", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        //Se comprueba si el email es valido
        else if !isValidEmail(string: emailText.text!){
            let alert = UIAlertController(title: "Error", message: "¡Vaya!, Ese no parece un email valido", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        //Si todo esta en su sitio se lanza la peticion de registro
        else{
            registrar(nombre: nombreText.text!, apellidos: ApellidosText.text!, telefono: telefonoText.text!, email: emailText.text!, passwd: PasswdText.text!, sexo: sexo)
        }
       
    }
    
    func registrar(nombre: String, apellidos: String, telefono:String, email: String, passwd:String, sexo:String){
        
    //URL del servidor
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/auth/register"
       
                       guard let url = URL(string: urlString) else {return}
       
                       var request = URLRequest(url: url)
       
                       request.httpMethod = "POST"
                   
                        //Parametros de la peticion
                       let bodyData = "first_name=\(nombre)&last_name=\(apellidos)&email=\(email)&telephone=\(telefono)&gender=\(sexo)&password=\(passwd)&password_confirmation=\(passwd)"
        
                       request.setValue(String(bodyData.lengthOfBytes(using: .utf8)), forHTTPHeaderField: "Content-Length")
        
                       request.httpBody = bodyData.data(using: String.Encoding.utf8)
       
                       URLSession.shared.dataTask(with: request){(data,response,error) in

                           var code = 0
                           //Si el error no es nulo que nos diga que está pasando
                           if error != nil {
                               print ("Error: \(error!.localizedDescription)")
                           }
                           //Si la respuesta es nula,que nos digo que no hay respuesta
                           if response != nil {
                               print (response ?? "No se ha obtenido respuesta")
                           }
                           if let res = response as? HTTPURLResponse {
                               print("Status code: \(res.statusCode)")
                               code = res.statusCode
                           }
                           guard let datos = data else {return}
                           
                           DispatchQueue.main.async {
                               //Aqui no hay mensajes del json, le paso el codigo a la funcion con las alertas
                               self.ErrorOrSuccess(code: code)
                           }
       
                           do{
                               let cosas = try JSONSerialization.jsonObject(with: datos, options: .fragmentsAllowed)
                               
                               print(cosas)
                               
                               
                           }
                           catch{
                               print("Error: \(error )")
                           }
                           
                       }.resume()
    }
    
    func ErrorOrSuccess(code: Int){
        //En esta funcion detecto si hay algun error
        
        //Si el codigo es 200 quiere decir que todo guay
        if code == 200{
            let alert = UIAlertController(title: "Usuario registrado", message: "Te has registrado en OH CAKE!, ¡Disfruta! :D", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "¡Genial!", style: .default, handler: {_ in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
                //Instancio la pantalla de login (En la pantalla de login escondo la barra en el viewWillLoad por que si no aparece el boton de back)
                self.navigationController?.pushViewController(vc, animated: true)
            })
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        //Si el code es 422 quiere decir que alguna validacion no le ha gustado y le da ansiedad al servidor
        else if code == 422 {
            
            let alert = UIAlertController(title: "Error", message: "¡Vaya!, Algo ha salido mal, comprueba que los datos introducidos tengan el formato correcto", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        else{
            //Otro codigo significa que al servidor le ha dado aun mas ansiedad y se ha muerto fuerte
            let alert = UIAlertController(title: "Error", message: "Error desconcido, prueba a intentarlo más tarde", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    //Estos 3 botones son para seleccionar el sexo, se cambian de color al pulsar cada uno
    @IBAction func ManBtn(_ sender: Any) {
        sexo = "Male"
        if #available(iOS 15.0, *) {
            HombreBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#EBD3DA")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            MujerBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            OtroBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
        
        //EBD3DA rosa
        //77CBCC azul
    }
    
    @IBAction func WomanBtn(_ sender: Any) {
        sexo = "Female"
        if #available(iOS 15.0, *) {
            HombreBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            MujerBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#EBD3DA")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            OtroBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func OtherBtn(_ sender: Any) {
        sexo = "Other"
        if #available(iOS 15.0, *) {
            HombreBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            MujerBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#BEE2E0")
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 15.0, *) {
            OtroBtn.configuration?.background.backgroundColor = hexStringToUIColor(hex: "#EBD3DA")
        } else {
            // Fallback on earlier versions
        }
    }
    
    //Esta funcion transforma un codigo hexadecimal a UIColor ya que swift no lo admite por defecto
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
    
    func isValidEmail(string: String) -> Bool {
        //Funcion con expresion regular para comprobar si el email es valido
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: string)
    }
}
