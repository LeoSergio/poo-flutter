import 'package:flutter/material.dart';


var dataObjects = [
      {

      "name": "La Fin Du Monde",

      "style": "Bock",

      "ibu": "65"

    },

    {

      "name": "Sapporo Premiume",

      "style": "Sour Ale",

      "ibu": "54"

    },

    {

      "name": "Duvel", 

      "style": "Pilsner", 

      "ibu": "82"

    },
    {

      "name": "Duvel", 

      "style": "Pilsner", 

      "ibu": "82"

    },
    {

      "name": "Duvel", 

      "style": "Pilsner", 

      "ibu": "82"

    },
    {

      "name": "Duvel", 

      "style": "Pilsner", 

      "ibu": "82"

    }

    ];


void main() {

  MyApp app = MyApp();

  runApp(app);

}



class MyApp extends StatelessWidget {

  @override

  Widget build(BuildContext context) {

    

    return MaterialApp(

      theme: ThemeData(primarySwatch: Colors.deepPurple),

      debugShowCheckedModeBanner:false,

      home: Scaffold(

        appBar: AppBar( 

          title: const Text("Dicas"),

          ),

        body: DataBodyWidget(objects:dataObjects),

        bottomNavigationBar: NewNavBar(),

      ));

  }

}



class NewNavBar extends StatelessWidget {

  NewNavBar();


  void botaoFoiTocado(int index) {

    print("Tocaram no botão $index");

  }


  @override

  Widget build(BuildContext context) {

    return BottomNavigationBar(onTap: botaoFoiTocado, items: const [

      BottomNavigationBarItem(

        label: "Cafés",

        icon: Icon(Icons.coffee_outlined),

      ),

      BottomNavigationBarItem(

          label: "Cervejas", icon: Icon(Icons.local_drink_outlined)),

      BottomNavigationBarItem(label: "Nações", icon: Icon(Icons.flag_outlined))

    ]);

  }

}


class DataBodyWidget extends StatelessWidget {
  final List objects;
  const DataBodyWidget({super.key, this.objects = const []});

  @override
  Widget build(BuildContext context) {
    var columnNames = ["Nome","Estilo","IBU"],
        propertyNames = ["name", "style", "ibu"];
    
    // SOLUÇÃO: Envolver o DataTable com SingleChildScrollView e usar um box para o tamanho
    return Expanded( // Necessário porque está dentro de uma Column no Scaffold
      child: SingleChildScrollView(
        child: DataTable(
          columns: columnNames.map((name) => DataColumn(
            label: Text(name, style: const TextStyle(fontStyle: FontStyle.italic))
          )).toList(),
          rows: objects.map((obj) => DataRow(
            cells: propertyNames.map((propName) => DataCell(Text(obj[propName]))).toList()
          )).toList()
        ),
      ),
    );
  }
}