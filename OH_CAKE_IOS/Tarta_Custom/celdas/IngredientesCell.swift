//
//  IngredientesCell.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 7/6/22.
//

import UIKit

class IngredientesCell: UICollectionViewCell {
    
    @IBOutlet weak var foto_Ingrediente: UIImageView!
    @IBOutlet weak var nombre_ingrediente: UILabel!
    @IBOutlet weak var CantidadLabel: UILabel!
    
   
    var currentUnidades: Int = 0{
            didSet{
                CantidadLabel.text = "\(currentUnidades)"
            }
        }
    
    
    @IBAction func SumarBtn(_ sender: Any) {
        currentUnidades += 1
    }
    
    
    @IBAction func RestarBtn(_ sender: Any) {
        
        if currentUnidades > 0{
            currentUnidades -= 1
        }
        
    }
    
}
