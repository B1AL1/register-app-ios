//
//  DefaultView.swift
//  Projekt
//
//  Created by Konrad on 27/05/2022.
//  Copyright © 2022 PL. All rights reserved.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
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
                        VStack
                        {
                            Text("Nie dodano jeszcze zadnego przedmiotu!")
                        }
                    }
                    else
                    {
                        ForEach(przedmioty) { przedmiot in
                            NavigationLink(destination: ManagePrzedmiotView(przedmiot: przedmiot))
                            {
                                VStack
                                {
                                    Text(przedmiot.nazwa!)
                                    if(!przedmiot.ocenaArray.isEmpty)
                                    {
                                        Divider()
                                        Group
                                        {
                                            HStack
                                            {
                                                ForEach(przedmiot.ocenaArray) { ocenaItem in
                                                    Text("\(Int(ocenaItem.wartosc))")
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        Group
                                        {
                                            Divider()
                                            Text("Kliknij aby dodac oceny").font(.system(size: 8))
                                            Spacer()
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
