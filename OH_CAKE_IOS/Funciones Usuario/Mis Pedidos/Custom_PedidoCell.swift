//
//  Custom_PedidoCell.swift
//  OH_CAKE_IOS
//
//  Created by Jose Manuel Qastusoft on 9/6/22.
//

import UIKit

class Custom_PedidoCell: UITableViewCell {
    
    
    @IBOutlet weak var num_pedido_custom: UILabel!
    @IBOutlet weak var Estado_Pedido_Custom: UILabel!
    @IBOutlet weak var Desc_pedido_Custom: UILabel!
    @IBOutlet weak var Fecha_pedido_Custom: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
