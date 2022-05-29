//
//  AddPrzedmiotView.swift
//  register-app-ios
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
            Text("Dodawanie przedmiotu")
            Spacer()
            TextField("Podaj nazwę przedmiotu:", text: $nazwa).padding().multilineTextAlignment(.center)
            Button("Dodaj przedmiot") {
                addPrzedmiot()
            }
            .alert(isPresented: $showingAlert)
            {
                Alert(title: Text("Błąd"), message: Text("Przedmot już istnieje lub nie podano nazwy"), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }.padding()
    }
    
    private func addPrzedmiot() {
        if(nazwa == "")
        {
            showingAlert = true
            return
        }
        przedmioty.forEach { przedmiot in
            if(przedmiot.nazwa == nazwa)
            {
                showingAlert = true
                return
            }
        }
        if(!showingAlert)
        {
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
}

struct AddPrzedmiotView_Previews: PreviewProvider {
    static var previews: some View {
        AddPrzedmiotView()
    }
}
