//
//  ViewController.swift
//  OH_CAKE_IOS
//
//  Created by Practica_libre on 16/3/22.
//

import UIKit
//Comprobar fittedSheets -> https://github.com/gordontucker/FittedSheets


var carrito:[[String:Any]] = [[:]]

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITabBarControllerDelegate{
    
    
   
    @IBOutlet weak var ofertasCollection: UICollectionView!
    @IBOutlet weak var mejorCollection: UICollectionView!
    
    @IBOutlet weak var UsuarioLabel: UILabel!
    let defaults = UserDefaults.standard

    @IBOutlet weak var registradoLabel: UILabel!
    @IBOutlet weak var crearcuentaBtn: UIButton!
    var tartas:[[String:Any]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            if carrito[0].isEmpty{
                carrito.remove(at: 0)
            }
        
     
        self.tabBarController?.delegate = self
        
        //Delegate de las ofertas
        ofertasCollection.delegate = self
        ofertasCollection.dataSource = self
        
        //Delegate de las ofertas 2
        mejorCollection.delegate = self
        mejorCollection.dataSource = self
 
        //self.defaults.set(true, forKey: "logued")
        
        self.getTartas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if defaults.bool(forKey: "logued") {
            registradoLabel.text = "Echa un vistazo a las categorias"
            crearcuentaBtn.setTitle("Categorias", for: .normal)
        }
        
        else{
            registradoLabel.text = "¿Todavía no estas registrado?"
            crearcuentaBtn.setTitle("Crear Cuenta", for: .normal)
           
        }
        
        let nombre = defaults.object(forKey: "usuario")
        let apellido = defaults.object(forKey: "apellido")
        
        if nombre != nil {
            UsuarioLabel.text = "Hola, \(nombre!)"
        }
        else{
            UsuarioLabel.text = "BIENVENIDO"
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
                 
        let newController = SelectionViewController()

        // Check if the view about to load is the second tab and if it is, load the modal form instead.
        if viewController == newController {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "user")
            tabBarController.present(vc, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.ofertasCollection {
            return 5
        }
        
        else{
            return 5
        }
    }
    
    @IBAction func AccountBtn(_ sender: Any) {
        
        if defaults.bool(forKey: "logued") {
            self.tabBarController?.selectedIndex = 1
        }
        
        else{
            self.tabBarController!.selectedIndex = 4
        }
        
    }
    
    @IBAction func PedirBtn(_ sender: Any) {
        self.tabBarController!.selectedIndex = 1
    }
    
    @IBAction func CustomBtn(_ sender: Any) {
        self.tabBarController!.selectedIndex = 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Si el collection view que recibe es el de las ofertas, instancia la celda correspondiente
        if collectionView == ofertasCollection {
            
            let ofertas = collectionView.dequeueReusableCell(withReuseIdentifier: "ofertascelda", for: indexPath) as! OfertasCell
            if tartas.count > 1{
                let urlString = tartas[indexPath.row]["image"] as! String
                guard let url = URL(string: urlString) else {return ofertas}
                
                ofertas.foto_ofertas.load(url: url)
            }
            
            
            return ofertas
        }
        
        else{
            
            //Si no, instancia la otra
            let mejores = collectionView.dequeueReusableCell(withReuseIdentifier: "mejorCelda", for: indexPath) as! MejoresCell
            
            if tartas.count > 1{
                let urlString = tartas[indexPath.row]["image"] as! String
                guard let url = URL(string: urlString) else {return mejores}
                
                mejores.foto_mejor.load(url: url)
            }
            
            return mejores
        }
        
    }
    
    
    func getTartas(){
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/defaultcakecategory/5"
        
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request){(data,response,error) in

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
            }
            
            guard let datos = data else {return}
            
            do{
                let cosas = try JSONSerialization.jsonObject(with: datos, options: .fragmentsAllowed) as! [String:Any]
                
                //Asigno los datos de las tartas de esta categoria
                self.tartas = cosas["default_cakes"] as! [[String : Any]]
                
                DispatchQueue.main.async {
                    //Actualizo la tabla
                    self.ofertasCollection.reloadData()
                }
                
            }
            catch{
                print("Error: \(error)")
            }

        }.resume()
    }
    
    
}

extension UIImageView {

    //Esta funcion es para redondear la foto de perfil
    func makeRounded() {

        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        self.layer.borderColor = hexStringToUIColor(hex: "#5B300D").cgColor
        self.layer.borderWidth = 3
        self.layer.cornerRadius = self.frame.height / 2
        assert(bounds.height == bounds.width, "The aspect ratio isn't 1/1. You can never round this image view!")
        self.clipsToBounds = true
    }
    
    //Esta esta declarada en mas sitios pero sirve para pasar un string de color hexadecimal a UICOLOR
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
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }

}


