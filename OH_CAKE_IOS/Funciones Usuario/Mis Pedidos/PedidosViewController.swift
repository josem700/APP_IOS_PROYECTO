//
//  PedidosViewController.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 26/5/22.
//

import UIKit

class PedidosViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var pedidosTableView: UITableView!
    @IBOutlet weak var pedidos_customTableview: UITableView!
    
    @IBOutlet weak var Empty_Label: UILabel!
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var custom_view: UIView!
    @IBOutlet weak var Loadingview: UIView!
    var pedidos:[[String:Any]] = [[:]]
    var pedidos_custom:[[String:Any]] = [[:]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if pedidos[0].isEmpty{
            pedidos.remove(at: 0)
        }
        
        
        if pedidos_custom[0].isEmpty{
            pedidos_custom.remove(at: 0)
        }
        
        self.pedidos_customTableview.delegate = self
        self.pedidos_customTableview.dataSource = self

        self.pedidosTableView.delegate = self
        self.pedidosTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.getPedidos()
    }
    
    
    @IBAction func Custom_Btn(_ sender: Any) {
        self.Loadingview.isHidden = false
        self.custom_view.isHidden = false
        if self.pedidos.isEmpty{
            self.Empty_Label.text = "¡No has realizado ningun pedido!"
        }
        else{
            self.Empty_Label.text = ""
        }
        self.getPedidosCustom()
        self.pedidos_customTableview.reloadData()
    }
    
    @IBAction func PredefinidasBtn(_ sender: Any) {
        self.custom_view.isHidden = true
        self.Loadingview.isHidden = false
        if self.pedidos.isEmpty{
            self.Empty_Label.text = "¡No has realizado ningun pedido!"
        }
        else{
            self.Empty_Label.text = ""
        }
        self.getPedidos()
        self.pedidosTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == pedidos_customTableview{
            return pedidos_custom.count
        }
        else{
            return pedidos.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == pedidosTableView{
            let defaultPedidos = tableView.dequeueReusableCell(withIdentifier: "pedidoscell", for: indexPath) as! PedidosCell
            if pedidos.count > 0 {
                let id = "\(pedidos[indexPath.item]["id"] as! Int)"
                defaultPedidos.Num_Pedido_Label.text = id
                defaultPedidos.Estado_Pedido_Label.text = pedidos[indexPath.item]["status"] as? String
                
                if pedidos[indexPath.item]["created_at"] != nil{
                    let fecha = pedidos[indexPath.item]["created_at"] as? String
                    let index = fecha!.firstIndex(of: "T")!
                    let recorte = fecha![..<index]
                    let recortado = String(recorte)
                   
                    defaultPedidos.Fecha_Pedido_Label.text = recortado
                }
                else{
                    defaultPedidos.Fecha_Pedido_Label.text = "Desconocido"
                }
               
                //cell.Descripcion_Pedido_Label.text = pedidos[indexPath.item][""] as! String
            }
            return defaultPedidos
        }
        
        else{
            let customPedidos = tableView.dequeueReusableCell(withIdentifier: "custompedido", for: indexPath) as! Custom_PedidoCell
            if pedidos_custom.count > 0 {
                let id = "\(pedidos_custom[indexPath.item]["id"] as! Int)"
                customPedidos.num_pedido_custom.text = id
                customPedidos.Estado_Pedido_Custom.text = pedidos_custom[indexPath.item]["status"] as? String
                
                if pedidos_custom[indexPath.item]["created_at"] != nil{
                    
                    let fecha = pedidos_custom[indexPath.item]["created_at"] as? String
                    let index = fecha!.firstIndex(of: "T")!
                    let recorte = fecha![..<index]
                    let recortado = String(recorte)
                   
                    customPedidos.Fecha_pedido_Custom.text = recortado
                }
                else{
                    customPedidos.Fecha_pedido_Custom.text = "Desconocido"
                }
               
                //cell.Descripcion_Pedido_Label.text = pedidos[indexPath.item][""] as! String
            }
            return customPedidos
        }
    }
    
    
    func getPedidos(){
    
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/orderdefaultcake/\(defaults.object(forKey: "usuario_id") ?? "")"
        
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
                let cosas = try JSONSerialization.jsonObject(with: datos, options: .fragmentsAllowed) as! [[String:Any]]
                
                print(cosas)
                
                self.pedidos = cosas
                
                DispatchQueue.main.async {
                    self.pedidosTableView.reloadData()
                    self.Loadingview.isHidden = true
                    if self.pedidos.isEmpty{
                        self.Empty_Label.text = "¡No has realizado ningun pedido!"
                    }
                    else{
                        self.Empty_Label.text = ""
                    }
                }
                    
                }
            
            catch{
                print("Error: \(error)")
            }

        }.resume()
    }
    
    
    
    func getPedidosCustom(){
    
        let urlString = "http://rumpusroom.es/tfc/back_cake_api_panels/public/api/ordercustomcake/\(defaults.object(forKey: "usuario_id") ?? "")"
        
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
                let cosas = try JSONSerialization.jsonObject(with: datos, options: .fragmentsAllowed) as! [[String:Any]]
                
                print(cosas)
                
                self.pedidos_custom = cosas
                
                DispatchQueue.main.async {
                    self.pedidos_customTableview.reloadData()
                    self.Loadingview.isHidden = true
                    if self.pedidos_custom.isEmpty{
                        self.Empty_Label.text = "¡No has realizado ningun pedido Custom!"
                    }
                    else{
                        self.Empty_Label.text = ""
                    }
                }
                    
                }
            
            catch{
                print("Error: \(error)")
            }

        }.resume()
    }


}
