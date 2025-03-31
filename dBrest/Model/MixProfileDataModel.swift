//
//  MixProfileDataModel.swift
//  dBrest
//
//  Created by Markus Platter on 31.03.25.
//

import Foundation

class MixProfileDataModel: ObservableObject {
    
    @Published var mixProfiles: [Mixprofile] = []
    
    func addMixprofileToList(mixprofile: Mixprofile) {
        self.mixProfiles.append(mixprofile)
    }
}
