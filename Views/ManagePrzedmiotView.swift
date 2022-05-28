//
//  ManageOcenaView.swift
//  Projekt
//
//  Created by Konrad on 27/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//

import SwiftUI
import CoreData

struct ManagePrzedmiotView: View {
    
    @Environment(\.managedObjectContext) private var dbContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Przedmiot.id_przedmiot, ascending: true)], animation: .default)
    private var przedmioty: FetchedResults<Przedmiot>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Ocena.id_ocena, ascending: true)], animation: .default)
    private var oceny: FetchedResults<Ocena>
    
    var przedmiot: Przedmiot
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack {
            Text(przedmiot.nazwa!)
            List {
                if(przedmiot.ocenaArray.isEmpty)
                {
                    Text("Nie dodano jeszcze żadnej oceny!")
                }
                else
                {
                    ForEach(przedmiot.ocenaArray) { ocenaItem in
                        HStack
                        {
                            Text("Ocena: \n\(Int(ocenaItem.wartosc))").foregroundColor((ocenaItem.kategoria=="Sprawdzian") ? .red :
                                                                                        (ocenaItem.kategoria=="Kartkówka") ? .blue :
                                                                                        (ocenaItem.kategoria=="Aktywność") ? .green :
                                                                                        (ocenaItem.kategoria=="Odpowiedź") ? .purple : .black)
                            Divider()
                            Text("Waga: \n\(ocenaItem.waga, specifier: "%.2f")")
                            Divider()
                            Text("Kategoria: \n\(ocenaItem.kategoria!)")
                        }.padding().multilineTextAlignment(.center)
                    }.onDelete(perform: deleteOcena)
                }
            }
            Button(action:
                {
                    showSheet.toggle()
                }, label: {
                    Text("Dodaj ocenę")
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showSheet)
            {
                    AddOcenaView(przedmiot: przedmiot)
            }
        }
    }
    
    private func deleteOcena(offsets: IndexSet) {
        withAnimation {
            offsets.map { przedmiot.ocenaArray[$0] }.forEach(dbContext.delete)
            do {
                try dbContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ManagePrzedmiotView_Previews: PreviewProvider {
    static var previews: some View {
        ManagePrzedmiotView(przedmiot: Przedmiot.init())
    }
}
