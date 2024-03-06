//
//  SegmentView.swift
//  NelsonMandala_app
//
//  Created by Lucas Santos on 13/11/17.
//  Copyright © 2017 lucasSantos. All rights reserved.
//

import UIKit
import XMSegmentedControl

protocol SegmentViewProtocol {
    func OnSegmentSelectionChange(selectedSegment: Int)
}

@IBDesignable
class SegmentView: UIView, XMSegmentedControlDelegate {
    
    //delegate do protocolo SegmentViewProtocol
    var delegate: SegmentViewProtocol?
    
    //Adiciona a view aqui para garantir que ele nao esta vazio
    let segmentedControl:XMSegmentedControl = {
        let segment = XMSegmentedControl(frame: CGRect(x: 0, y: 0, width: 200, height: 50), segmentTitle: ["Login",NSLocalizedString("RegisterLogin", comment: "")], selectedItemHighlightStyle: .BottomEdge)
        return segment
        
    }()
    
    func xmSegmentedControl(xmSegmentedControl: XMSegmentedControl, selectedSegment: Int) {
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sponsorOrSponsored"), object: nil)
        if let delegate = self.delegate {
            delegate.OnSegmentSelectionChange(selectedSegment: selectedSegment)
        }
    }
    
    /*
    public func whichIsSelected() -> Int? {
        return segmentedControl.selectedSegment
    }
    */
    
    override func layoutSubviews() {
        segmentedControl.delegate = self
        setupSegmentedControl()
        addSubview(segmentedControl)
        setupSegmentedContraints()
    }
    
    //Funcao que seta as contraints do segmented control criado
    func setupSegmentedContraints(){
        self.segmentedControl.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.segmentedControl.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.segmentedControl.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    //Funcao que cria o segmented control e retorna o mesmo
    func setupSegmentedControl() {
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.backgroundColor = .clear
        segmentedControl.tint = #colorLiteral(red: 0.7764705882, green: 0.7764705882, blue: 0.7764705882, alpha: 1)
        segmentedControl.highlightTint = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        segmentedControl.edgeHighlightHeight = 3
        segmentedControl.font = .niSegmentedFont
        segmentedControl.highlightColor = #colorLiteral(red: 0.8156862745, green: 0.01960784314, blue: 0.7176470588, alpha: 1)
        
    }
    
}
