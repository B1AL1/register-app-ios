//
//  DefaultView.swift
//  Projekt
//
//  Created by Konrad on 27/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//

import SwiftUI
import CoreData

struct DefaultView: View {
    
    @Environment(\.managedObjectContext) private var dbContext
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Przedmiot.id_przedmiot, ascending: true)], animation: .default)
    private var przedmioty: FetchedResults<Przedmiot>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Ocena.id_ocena, ascending: true)], animation: .default)
    private var oceny: FetchedResults<Ocena>
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Dzienniczek ucznia")
                List {
                    if(przedmioty.isEmpty)
                    {
                        Text("Nie dodano jeszcze zadnego przedmiotu!")
                    }
                    else
                    {
                        ForEach(przedmioty) { przedmiot in
                            NavigationLink(destination: ManagePrzedmiotView(przedmiot: przedmiot))
                            {
                                VStack
                                {
                                    Text(przedmiot.nazwa!)
                                    Spacer()
                                    Group {
                                        VStack(alignment: .center)
                                        {
                                            ForEach(Array((przedmiot.ocena as? Set<Ocena>)!)) { ocenaItem in
                                                HStack {
                                                    Text("Ocena: \(ocenaItem.wartosc, specifier: "%.2f")")
                                                    Text("Waga: \(ocenaItem.waga, specifier: "%.2f")")
                                                    Text("Kategoria: \(ocenaItem.kategoria ?? "")")
                                                }.padding()
                                            }
                                        }
                                    }
                                }
                            }
                        }.onDelete(perform: deletePrzedmiot)
                    }
                }
                Button(action:
                    {
                        showSheet.toggle()
                    }, label: {
                        Text("Dodaj przedmiot")
                        Image(systemName: "plus")
                    }
                )
                .sheet(isPresented: $showSheet)
                {
                        AddPrzedmiotView()
                }
            }
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

struct DefaultView_Previews: PreviewProvider {
    static var previews: some View {
        DefaultView()
    }
}
