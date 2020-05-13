import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(FireBaseApp());
}

class FireBaseApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FireBaseApp",
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          canvasColor: Colors.cyan[50]
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  TextEditingController controller = TextEditingController();
  String url = "https://owlbot.info/api/v4/dictionary/";
  String token = "48e422eb034399038b5597de5f2c1b63bd761650";
  Stream stream;
  StreamController streamController;
  List list;


   searchNow() async{

    if(controller.text.trim()== null || controller.text.length == 0){
      streamController.add(null);
    }
    Response response = await get(url + controller.text.trim(),
        headers: {"Authorization": "Token " + token});

    streamController.add(json.decode(response.body));
    

  }


  @override
  void initState() {
    super.initState();
    streamController = StreamController();
    stream = streamController.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Dictionary App',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        bottom: PreferredSize(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)
                    ),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                          hintText: "Enter your search word",
                          contentPadding: const EdgeInsets.all(20),
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: (){
                      searchNow();
                    })
              ],
            ),
            preferredSize: Size.fromHeight(100.0)),

      ),
      body: StreamBuilder(
          stream:  stream,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.data == null){
              return Center(
                child: Text("Put in a search Word Here"),
              );
            }
            else
              {
                return ListView.builder(
                    itemCount: snapshot.data["definitions"].length,
                    itemBuilder:(BuildContext context, int index){
                      return ListBody(
                        children: <Widget>[
                          Container(
                            color: Colors.cyan.withOpacity(.5),
                            child: ListTile(
                              leading:
                              snapshot.data["definitions"][index]["image_url"] == null
                              ? null : CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data["definitions"][index]["image_url"]
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    });
              }
          })
    );
  }
}