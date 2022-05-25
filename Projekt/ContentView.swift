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
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Przedmiot.id_przedmiot, ascending: true)], animation: .default)
    private var przedmioty: FetchedResults<Przedmiot>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Ocena.id_ocena, ascending: true)], animation: .default)
    private var oceny: FetchedResults<Ocena>
    
    @State private var nazwa: String = ""
    @State private var kategoria: String = ""
    @State private var waga: Double = 0.0
    @State private var wartosc: Double = 0.0
    @State private var ocenayTab: [Ocena]?
    
    @State private var pickerId: Int = 0
    
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
                    ForEach(przedmioty, id: \.self) { przedmiot in
                        Text("\(przedmiot.nazwa!)")
                        ForEach(przedmiot, id: \.self) { ocena in
                            VStack(alignment: .leading) {
                                Text("Test")
    //                                Text("Title: \(book.title!)")
    //                                Text("Author: \(book.author!)")
    //                                Text("Publish year: \(String(book.publishYear))")
    //                                Text("Publisher: \(book.publisher!)")
    //                                Text("Stars: \(book.stars)")
                            }
                        }
                        
                    }.onDelete(perform: deletePrzedmiot)
                }
                Button(action: addPrzedmiot) {
                    Text("Add Przedmiot")
                }
            }
        }
    }
    
    private func addPrzedmiot() {
        let przedmiot = Przedmiot(context: dbContext)
        przedmiot.nazwa = "XDDD"
        
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
