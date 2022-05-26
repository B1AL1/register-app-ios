//
//  ContentView.swift
//  Projekt
//
//  Created by student on 18/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var dbContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Przedmiot.nazwa, ascending: true)], animation: .default)
    private var przedmioty: FetchedResults<Przedmiot>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Ocena.kategoria, ascending: true)], animation: .default)
    private var oceny: FetchedResults<Ocena>
    
    @State private var nazwa: String = ""
    @State private var kategoria: String = ""
    @State private var waga: Double = 0.0
    @State private var wartosc: Double = 0.0
    
    @State private var showingAlert = false
    
    var body: some View {
        
        NavigationView{
//            VStack{
//                Text("Dzienniczek ucznia")
//                    .font(.title)
//                Spacer()
//
//                NavigationLink("Otworz dziennik", destination: DziennikView())
//                .padding()
//                .accentColor(Color(.blue))
//                NavigationLink("Utworz nowy dziennik", destination: NowyDziennikView())
//                .padding()
//                .accentColor(Color(.blue))
//                Spacer()
//            }
            
            VStack {
                Text("Dzienniczek ucznia")
                
                List {
                    ForEach(przedmioty) { przedmiot in
                        HStack {
                            Text(przedmiot.nazwa!)
                            Section {
                                ForEach(Array((przedmiot.ocena as? Set<Ocena>)!)) { ocenaItem in
                                    VStack(alignment: .leading) {
                                        Text("Ocena: \(ocenaItem.wartosc)")
                                        Text("Waga: \(ocenaItem.waga)")
                                        Text("Kategoria: \(ocenaItem.kategoria!)")
                                    }
                                }
                            }
                        }
                    }.onDelete(perform: deletePrzedmiot)
                }
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
        przedmiot.nazwa = nazwa
        
        do {
            try dbContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deletePrzedmiot(offsets: IndexSet) {
        withAnimation {
            offsets.map { przedmioty[$0] }.forEach(dbContext.delete)
            do {
                try dbContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
