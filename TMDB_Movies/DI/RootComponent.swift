//
//  RootComponent.swift
//  TMDB_Movies
//
//  Created by KsArT on 04.09.2024.
//

import Foundation
import NeedleFoundation

// needle generate TMDB_Movies/DI/NeedleGenerated.swift TMDB_Movies/  
class RootComponent: BootstrapComponent {

    var mainComponent: MainComponent {
        MainComponent(parent: self)
    }

    var detailComponent: DetailComponent {
        DetailComponent(parent: self)
    }
}
