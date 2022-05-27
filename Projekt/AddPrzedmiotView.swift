//
//  AddPrzedmiotView.swift
//  Projekt
//
//  Created by Konrad on 27/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//

import SwiftUI
import CoreData

struct AddPrzedmiotView: View {
    
    @Environment(\.managedObjectContext) private var dbContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Przedmiot.id_przedmiot, ascending: true)], animation: .default)
    private var przedmioty: FetchedResults<Przedmiot>
    
    @State private var nazwa: String = ""
    
    @State private var showingAlert = false
    
    var body: some View {
        VStack
        {
            TextField("Podaj nazwe przedmiotu:", text: $nazwa).padding().multilineTextAlignment(.center)
            Button("Dodaj Przedmiot") {
                czyPrzedmiotDodany()
            }
            .alert(isPresented: $showingAlert)
            {
                Alert(title: Text("Blad"), message: Text("Przedmot juz istnieje"), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func czyPrzedmiotDodany() {
        przedmioty.forEach { przedmiot in
            if(przedmiot.nazwa == nazwa)
            {
                showingAlert = true
                return
            }
        }
        if(!showingAlert)
        {
            addPrzedmiot()
        }
    }
    
    private func addPrzedmiot() {
        let przedmiot = Przedmiot(context: dbContext)
        przedmiot.id_przedmiot = UUID().uuidString
        przedmiot.nazwa = nazwa
        
        do {
            try dbContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddPrzedmiotView_Previews: PreviewProvider {
    static var previews: some View {
        AddPrzedmiotView()
    }
}
