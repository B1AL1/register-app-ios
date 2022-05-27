//
//  AddOcenaView.swift
//  Projekt
//
//  Created by Konrad on 27/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//

import SwiftUI
import CoreData

struct AddOcenaView: View {
    
    @Environment(\.managedObjectContext) private var dbContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Przedmiot.id_przedmiot, ascending: true)], animation: .default)
    private var przedmioty: FetchedResults<Przedmiot>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Ocena.id_ocena, ascending: true)], animation: .default)
    private var oceny: FetchedResults<Ocena>
    
    var przedmiot: Przedmiot
    
    var wartosci = [1.0, 2.0, 3.0, 4.0, 5.0]
    var wagi = [1.0, 2.0, 3.0, 4.0, 5.0]
    var kategorie = ["Sprawdzian", "Kartkowka", "Odpowiedz", "Aktywnosc", "Inne"]
    
    @State private var kategoria: String = "Sprawdzian"
    @State private var waga: Double = 1.0
    @State private var wartosc: Double = 1.0
    
    var body: some View {
        VStack
        {
            Picker(selection: $wartosc, label: Text("Wybierz ocene"))
            {
                ForEach(0..<wartosci.count)
                {
                    Text("\(Int(wartosci[$0]))").tag(wartosci[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            Picker(selection: $waga, label: Text("Wybierz wage"))
            {
                ForEach(0..<wagi.count)
                {
                    Text("\(wagi[$0], specifier: "%0.2f")").tag(wagi[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            Picker(selection: $kategoria, label: Text("Wybierz kategorie"))
            {
                ForEach(0..<kategorie.count)
                {
                    Text(kategorie[$0]).tag(kategorie[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            Button("Dodaj ocene") {
                addOcena()
            }
        }
    }
    
    private func addOcena() {
        let ocena = Ocena(context: dbContext)
        ocena.id_ocena = UUID().uuidString
        ocena.wartosc = wartosc
        ocena.waga = waga
        ocena.kategoria = kategoria
        przedmiot.addToOcena(ocena)
        
        do {
            try dbContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddOcenaView_Previews: PreviewProvider {
    static var previews: some View {
        AddOcenaView(przedmiot: Przedmiot.init())
    }
}
