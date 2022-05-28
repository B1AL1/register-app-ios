//
//  ToogleModel.swift
//  Projekt
//
//  Created by Konrad on 28/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//

import Foundation

class ToggleModel
{
    var isDark: Bool = true
    {
        didSet
        {
            SceneDelegate.shared?.window!.overrideUserInterfaceStyle = isDark ? .dark : .light
        }
    }
}
