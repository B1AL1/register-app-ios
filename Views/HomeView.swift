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
    
    @State private var showSheetEdit: Bool = false
    
    @GestureState var isLongPress = false
    
    var body: some View {
        
        let longPress = LongPressGesture().onEnded
        { finished in
            showSheetEdit.toggle()
        }
        
        NavigationView{
            VStack {
                Image("iconDziennik")
                Text("Dzienniczek ucznia")
                List {
                    if(przedmioty.isEmpty)
                    {
                        VStack
                        {
                            Text("Nie dodano jeszcze żadnego przedmiotu!")
                        }.padding()
                    }
                    else
                    {
                        ForEach(przedmioty) { przedmiot in
                            NavigationLink(destination: ManagePrzedmiotView(przedmiot: przedmiot))
                            {
                                VStack
                                {
                                    Text(przedmiot.nazwa!).gesture(longPress).sheet(isPresented: $showSheetEdit)
                                    {
                                        EditPrzedmiotView(przedmiot: przedmiot)
                                    }
                                    if(!przedmiot.ocenaArray.isEmpty)
                                    {
                                        Divider()
                                        Group
                                        {
                                            HStack
                                            {
                                                ForEach(przedmiot.ocenaArray) { ocenaItem in
                                                    Text("\(Int(ocenaItem.wartosc))").foregroundColor((ocenaItem.kategoria=="Sprawdzian") ? .red :
                                                                                                        (ocenaItem.kategoria=="Kartkówka") ? .blue :
                                                                                                        (ocenaItem.kategoria=="Aktywność") ? .green :
                                                                                                        (ocenaItem.kategoria=="Odpowiedź") ? .purple : .black)
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        Group
                                        {
                                            Divider()
                                            Text("Kliknij aby dodać oceny").font(.system(size: 8))
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
