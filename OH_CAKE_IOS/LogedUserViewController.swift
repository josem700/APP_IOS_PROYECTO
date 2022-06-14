//
//  LogedUserViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 17/5/22.
//

import UIKit

class LogedUserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Defaults y funcion para coger fotos
    let defaults = UserDefaults.standard
    var imagepicker: UIImagePickerController = UIImagePickerController()
    @IBOutlet weak var UsuarioLabel: UILabel!
    
    @IBOutlet weak var foto_perfil: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        foto_perfil.makeRounded()
        imagepicker.delegate = self
        imagepicker.sourceType = .photoLibrary
        let nombre = defaults.object(forKey: "usuario")
        let apellido = defaults.object(forKey: "apellido")
        UsuarioLabel.text = "Bienvenido, \(nombre!) \(apellido!)"
    }
    
    
    //Instaciar controlador de Pedidos
    @IBAction func PedidosBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "pedidos") as! PedidosViewController
        self.present(vc, animated: true)
    }
    
    //Presenta el controlador de elegir la foto
    @IBAction func changeProfilepic(_ sender: Any) {
        present(imagepicker, animated: true)
    }
    
    //Instanciar el controlador de contacto con el pastelero
    @IBAction func ContactoBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "contacto") as! ContactoViewController
        self.present(vc, animated: true)
    }
    
    @IBAction func CarritoBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "carrito") as! CarritoViewController
        self.present(vc, animated: true)
    }
    
    //Funcion para hacerlogout
    @IBAction func logout(_ sender: Any) {

        //Alerto de cerrar la sesion
        let alert = UIAlertController(title: "¡Atencion!", message: "¿Seguro que quieres cerrar tu sesion?", preferredStyle: .alert)
        
        let confirmar = UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
            //Si el usuario dice que si, pongo el booleano de logued a false, cierro la vista y lo {redirijo a la vista principal} -> (Funciona un poco cuando le sale de los huevos)
            self.dismiss(animated: true)
            self.defaults.set(false, forKey: "logued")
            self.tabBarController?.selectedIndex = 0
            clearAllUserDefaultsData()
        })
        
        //Si pulsa cancelar pues no hace nada
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        
        alert.addAction(confirmar)
        alert.addAction(cancelar)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Esta funcion hace que al usuario le salga una vista con la galeria para que pueda elegir foto
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            /// 5. Este método se activa cuando el usuario selecciona una imagen y devuelve información sobre la imagen seleccionada.
            /// 6. Obtenga el atributo originImage en esta imagen, que es la imagen misma
            guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                fatalError("error: did not picked a photo")
            }
            /// 7. Realice otras operaciones relacionadas según sea necesario, seleccione la imagen aquí y luego cierre el controlador del selector
            picker.dismiss(animated: true) { [unowned self] in
                //Añade la foto al viewcontroller de arriba
                
                ///NO OLVIDAR QUE HAY QUE SUBIR ESTO AL SERVIDOR CUANDO ESTE DISPONIBLE QUE LUEGO SE ME OLVIDA
                self.foto_perfil.image = selectedImage
            }
        }
//5B300D

}


func clearAllUserDefaultsData(){
   let userDefaults = UserDefaults.standard
   let dics = userDefaults.dictionaryRepresentation()
   for key in dics {
       userDefaults.removeObject(forKey: key.key)
   }
   userDefaults.synchronize()
}

