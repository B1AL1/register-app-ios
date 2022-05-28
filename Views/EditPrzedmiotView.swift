//
//  EditPrzedmiotView.swift
//  Projekt
//
//  Created by Konrad on 28/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//

import SwiftUI

struct EditPrzedmiotView: View {
    
    @Environment(\.managedObjectContext) private var dbContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Przedmiot.id_przedmiot, ascending: true)], animation: .default)
    private var przedmioty: FetchedResults<Przedmiot>
    
    @State private var nazwa: String = ""
    
    @State private var showingAlert = false
    
    var przedmiot: Przedmiot
    
    var body: some View {
        VStack
        {
            Text("Edytowanie przedmiotu")
            Spacer()
            TextField("Podaj nazwę przedmiotu:", text: $nazwa).padding().multilineTextAlignment(.center)
            Button("Edytuj przedmiot") {
                editPrzedmiot()
            }
            .alert(isPresented: $showingAlert)
            {
                Alert(title: Text("Blad"), message: Text("Przedmot już istnieje lub nie podano nazwy"), dismissButton: .default(Text("OK")))
            }
            Spacer()
        }.padding()
    }
    
    private func editPrzedmiot() {
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

struct EditPrzedmiotView_Previews: PreviewProvider {
    static var previews: some View {
        EditPrzedmiotView(przedmiot: Przedmiot.init())
    }
}
