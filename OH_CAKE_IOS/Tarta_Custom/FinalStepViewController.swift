//
//  FinalStepViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 16/5/22.
//

import UIKit
import Alamofire
class FinalStepViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagepicker: UIImagePickerController = UIImagePickerController()
    lazy var imageview = UIImageView(frame: view.frame)
    let defaults = UserDefaults.standard
    //Aqui llega los datos de todo el proceso anterior
    var size = ""
    var shape = ""
    var base = ""
    var relleno = ""
    var ingredientes:[[Int:Int]] = [[:]]
    
    
    @IBOutlet weak var foto_personalizada: UIImageView!
    @IBOutlet weak var dedicatoriaText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action:     #selector(tapGestureHandler))
              view.addGestureRecognizer(tapGesture)
        
        imagepicker.delegate = self
        imagepicker.sourceType = .photoLibrary
        
        imageview.contentMode = .scaleAspectFit
        view.addSubview(imageview)
    }
    
    @objc func tapGestureHandler() {
        dedicatoriaText.endEditing(true)
      }
    
    @IBAction func pickImage(_ sender: Any) {
        present(imagepicker, animated: true)
    }
    
    @IBAction func LIstoBtn(_ sender: Any) {

        self.PedirTartaCustom(Size: size, Shape: shape, Base: base, Relleno: relleno, Ingredients: ingredientes, Dedicatoria: dedicatoriaText.text, Image: foto_personalizada)
    }
    
    
    
    func PedirTartaCustom(Size:String, Shape:String, Base:String, Relleno:String, Ingredients:[[Int:Int]], Dedicatoria:String?, Image:UIImageView?){
        
        var ingr:[String:[String:Any]] = [:]
        
        print(Ingredients[0])
        
        for i in 0...Ingredients.count - 1{
            let a = Ingredients[i]
            let id = Ingredients[i].keys
            let quant = Ingredients[i].values
            
            print(type(of: id))
                ingr["ingredient\(i)"] =
                [
                    "id":"\(id.first ?? 0)",
                    "ingredient_quantity":"\(quant.first ?? 0)"
                ]
        }

        let parametros:[String:Any] = [
            "user_id":defaults.object(forKey: "usuario_id"),
            "products":[
                "custom_cake":[
                    "custom_cake1":[
                       "size":Size,
                       "base":Base,
                       "filling":Relleno,
                       "cost":"21",
                       "top_image":"lalala",
                       "inscription":Dedicatoria,
                       "ingredients":ingr
                    ]
                ]
            ]
        ]
        
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/order"
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data = try! JSONSerialization.data(withJSONObject: parametros, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        let json = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        if let json = json{
            print(json)
        }
        
        request.httpBody = json!.data(using: String.Encoding.utf8.rawValue)
        let alamoRequest = AF.request(request as URLRequestConvertible)
        alamoRequest.validate(statusCode: 200..<300)
        alamoRequest.responseString { response in
            print(response.result)
            print(response.response?.statusCode)
            if response.response?.statusCode == 201{
                let alert = UIAlertController(title: "¡Delicioso!", message: "¡Muchas gracias por tu pedido, puedes consultar su estado en tu perfil!", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                    self.tabBarController?.selectedIndex = 4
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "paso0") as! Step1ViewController
                  
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Error", message: "¡Ha ocurrido un error al realizar tu pedido!", preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Aceptar", style: .destructive, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            /// 5. Este método se activa cuando el usuario selecciona una imagen y devuelve información sobre la imagen seleccionada.
            /// 6. Obtenga el atributo originImage en esta imagen, que es la imagen misma
            guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("error: did not picked a photo")
            }
            /// 7. Realice otras operaciones relacionadas según sea necesario, seleccione la imagen aquí y luego cierre el controlador del selector
            picker.dismiss(animated: true) { [unowned self] in
                // add a image view on self.view
                self.foto_personalizada.image = selectedImage
            }
        }
    
}
