import 'dart:async';
import 'package:flutter/material.dart';
import 'package:password_storage_for_official/db.dart';
import 'package:password_storage_for_official/detail.dart';
import 'package:password_storage_for_official/item.dart';
import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Root extends StatefulWidget {

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root>  with WidgetsBindingObserver  {

  final fontsize = 16;
  final iconsize = 13;
  int choice;
  int setting;
  double displayHeight = 5.0;
  String _value;
  String get searchText => searchtext.text;
  bool display1=true;
  bool display2=true;
  bool display3=true;
  bool display4=true;
  bool display5=true;
  bool favoriteOnly=false;
  bool orderDate=true;
  bool orderTitle=false;
  bool orderID=false;
  bool orderPass=false;
  bool deleteon = false;
  Color fontcolor = Colors.brown[800];
  List<bool> deleteCheckList =[];
  List<String> deleteValueStorage = [];
  var searchtext = TextEditingController();
  // ignore: non_constant_identifier_name
  StreamController<List<Item>> _streamController;
  final favorite = Set<int>();
  final deleteValueList = Set<String>();

  _RootState() {
    _streamController = StreamController<List<Item>>();
    streamIn();
    displayCount();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  streamIn() async{
    _streamController = StreamController<List<Item>>();
    List<Item> karioki=[];
    if(favoriteOnly==false){
      if(choice==1 || choice==null){
        karioki = await DB().search(null);}
      else if(choice==2){
        karioki = await DB().searchBytitle(null);
      }else if(choice==3){
        karioki = await DB().searchByid(null);
      }else if(choice==4){
        karioki = await DB().searchBypass(null);
      }
    }
    else{
      if(choice==1 || choice==null) {
        karioki = await DB().searchFAV(null);
      }else if(choice==2){
        karioki = await DB().searchBytitleFAV(null);
      }else if(choice==3){
        karioki = await DB().searchByidFAV(null);
      }else if(choice==4){
        karioki = await DB().searchBypassFAV(null);
      }
    }
    _streamController.add(karioki);
    if(deleteCheckList.length != 0){
      deleteCheckList.removeRange(0, deleteCheckList.length);
    }
    for(var i=0;i<karioki.length;i++){
      deleteCheckList.add(false);
    }
    if(deleteValueStorage.length != 0){
      deleteValueStorage.removeRange(0, deleteValueStorage.length);
    }
    if(deleteValueList.isNotEmpty){deleteValueList.clear();}
    for(var i=0;i<karioki.length;i++){
      deleteValueStorage.add(karioki[i].id.toString());
    }

    if(favorite.isNotEmpty){
      favorite.clear();
    }
    if(karioki!=null || karioki.length!=0){
      for(var i=0;i<karioki.length;i++){
        if(karioki[i].favorite==1){
          favorite.add(karioki[i].id);
        }
      }
    }
    choiceCheck();
  }

  onchanging(String keyword) async {
    List<Item> karioki0 = [];
    if(favoriteOnly==false){
      if(choice==1 || choice==null){
        karioki0 = await DB().search(keyword);
      }else if(choice==2){
        karioki0 = await DB().searchBytitle(keyword);
      }else if(choice==3){
        karioki0 = await DB().searchByid(keyword);
      }else if(choice==4){
        karioki0 = await DB().searchBypass(keyword);
      }
    }else{
      if(choice==1 || choice==null){
        karioki0 = await DB().searchFAV(keyword);
      }else if(choice==2){
        karioki0 = await DB().searchBytitleFAV(keyword);
      }else if(choice==3){
        karioki0 = await DB().searchByidFAV(keyword);
      }else if(choice==4){
        karioki0 = await DB().searchBypassFAV(keyword);
      }
    }
    _streamController.add(karioki0);

    if(favorite.isNotEmpty){
      favorite.clear();
    }
    for(var i=0;i<karioki0.length;i++){
      if(karioki0[i].favorite==1){
        favorite.add(karioki0[i].id);
      }
    }
    if(deleteCheckList.length != 0){
      deleteCheckList.removeRange(0, deleteCheckList.length);
    }
    for(var i=0;i<karioki0.length;i++){
      deleteCheckList.add(false);
    }
    if(deleteValueStorage.length != 0){
      deleteValueStorage.removeRange(0, deleteValueStorage.length);
    }
    if(deleteValueList.isNotEmpty){deleteValueList.clear();}
    for(var i=0;i<karioki0.length;i++){
      deleteValueStorage.add(karioki0[i].id.toString());
    }
  }

  SettingInit() async{
    displayHeight=5.0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    initSetting() async {
      SharedPreferences prefs= await SharedPreferences.getInstance();
      setState(() {
        display1=prefs.getBool('display1') ?? true;
        display2=prefs.getBool('display2') ?? true;
        display3=prefs.getBool('display3') ?? true;
        display4=prefs.getBool('display4') ?? true;
        display5=prefs.getBool('display5') ?? true;
      });
    }
  }

  chosen(int choice) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('choice', choice);
  }
  choiceCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    choice = prefs.getInt('choice');
  }

  set(String name){
    _value = name;
  }

  deleteflg() {
    setState(() {
      if(deleteon==false){
        deleteon = true;
      }else {
        deleteon =false;
      }
    });
  }

  displayOn1(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value){prefs.setBool('display1', true);
    }else{
      prefs.setBool('display1', false);
    }
  }
  displayOn2(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value){prefs.setBool('display2', true);
    }else{
      prefs.setBool('display2', false);
    }
  }
  displayOn3(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value){prefs.setBool('display3', true);
    }else{
      prefs.setBool('display3', false);
    }
  }
  displayOn4(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value){prefs.setBool('display4', true);
    }else{
      prefs.setBool('display4', false);
    }
  }
  displayOn5(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(value){prefs.setBool('display5', true);
    }else{
      prefs.setBool('display5', false);
    }
  }

  displayCount() {
      displayHeight=0;
      var displaycount = [];
      displaycount.add(display1);
      displaycount.add(display2);
      displaycount.add(display3);
      displaycount.add(display4);
      displaycount.add(display5);
      for(var i=0;i<displaycount.length;i++){
        if(displaycount[i]){displayHeight++;}
      }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adjustsizeh = MediaQuery.of(context).size.height * 0.0011;

    deleteOn() {
      if(deleteValueList.length != 0) {
        final List<String> forDelete = deleteValueList.toList();
        for (var i = 0; i < deleteValueList.length; i++) {
          DB().delete(int.parse(forDelete[i]));
        }
      }
    }
    

    return Scaffold(
        backgroundColor: Colors.cyan[100],
        appBar: AppBar(
          elevation: 8,
          leading:(deleteon==false)?Padding(
              padding:EdgeInsets.all(4.0),
              child:PopupMenuButton(
                color: Colors.amber[100],
                icon: Icon(Icons.settings),
                initialValue: setting,
                onSelected: (value){
                  setState(() {
                    if(value == 1){
                      if(display2==false&&display3==false&&display4==false&&display5==false){}else{
                      if(display1==true){
                        displayOn1(false);display1=false;}
                      else{displayOn1(true);display1=true;}}
                    }else  if(value == 2){
                      if(display1==false&&display3==false&&display4==false&&display5==false){}else{
                      if(display2==true){
                        displayOn2(false);display2=false;
                      }else{displayOn2(true);display2=true;}}
                    }else if(value == 3){
                      if(display1==false&&display2==false&&display4==false&&display5==false){}else{
                      if(display3==true){
                        displayOn3(false);display3=false;}
                      else{displayOn3(true);display3=true;}}
                    }else if(value == 4){
                      if(display1==false&&display2==false&&display3==false&&display5==false){}else{
                      if(display4==true){
                        displayOn4(false);display4=false;}
                      else{displayOn4(true);display4=true;}}
                    }else if(value == 5){
                      if(display1==false&&display2==false&&display3==false&&display4==false){}else{
                      if(display5==true){
                        displayOn5(false);display5=false;}
                      else{displayOn5(true);display5=true;}}
                    }
                    displayCount();
                    streamIn();
                });
                },
                itemBuilder: (BuildContext context) {
                  return[
                    PopupMenuItem(
                        child:  Row(children: <Widget>[
                          Text('Title'),
                          SizedBox(width: width*0.05),
                          (display1)?Icon(Icons.check,color: Colors.brown[700])
                              :Container()
                        ]),
                        value: 1
                    ),
                    PopupMenuItem(
                        child: Row(children: <Widget>[
                          Text('ID'),
                          SizedBox(width: width*0.05,),
                          (display2)?Icon(Icons.check,color: Colors.brown[700])
                              :Container()
                        ]),
                        value: 2
                    ),
                    PopupMenuItem(
                        child:  Row(children: <Widget>[
                          Text('Password'),
                          SizedBox(width: width*0.05),
                          (display3)?Icon(Icons.check,color: Colors.brown[700])
                              :Container()
                        ]),
                        value: 3
                    ),
                    PopupMenuItem(
                        child:  Row(children: <Widget>[
                          Text('URL'),
                          SizedBox(width: width*0.05,),
                          (display4)?Icon(Icons.check,color: Colors.brown[700])
                              :Container()
                        ]),
                        value: 4
                    ),
                    PopupMenuItem(
                      child: Row(children: <Widget>[
                        Text('Memo'),
                        SizedBox(width: width*0.05),
                        (display5)?Icon(Icons.check,color: Colors.brown[700])
                            :Container()
                      ]),
                      value: 5,)
                  ];
                },
              )
          ):Container(),
          centerTitle: true,
          title:Text("PASSWORDLIST",style: TextStyle(color: Colors.yellow[200])),
          backgroundColor: Colors.brown[800],
          actions: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child:PopupMenuButton(
                color: Colors.amber[100],
                icon: Icon(Icons.shuffle),
                initialValue: choice,
                onSelected: (value){
                  setState(() {
                    if(choice==null){choice=1;}
                    var karioki=choice;
                    print(karioki);
                    if(value!=5){
                    choice = value;}
                    print(choice);
                    if(value==5){choice=karioki;print(choice);print(karioki);
                    if(favoriteOnly==false){favoriteOnly=true;}else{favoriteOnly=false;}
                    }
                    if(value!=5){
                    chosen(value);}
                    streamIn();
                  });
                },
                itemBuilder: (BuildContext context) {
                  return[
                    PopupMenuItem(
                        child: Text('Date'),
                        value: 1,
                        enabled: (choice==1)?false:true),
                    PopupMenuItem(
                      child: Text('Name(title)'),
                      value: 2,
                      enabled: (choice==2)?false:true,
                    ),
                    PopupMenuItem(
                      child: Text('Name(ID)'),
                      value: 3,
                      enabled: (choice==3)?false:true,
                    ),
                    PopupMenuItem(
                      child: Text('Name(pass)'),
                      value: 4,
                      enabled: (choice==4)?false:true,
                    ),
                    (favoriteOnly==true) ?PopupMenuItem(
                      child: Row(children: <Widget>[
                        Text('favorite'),
                        SizedBox(width: width*0.05,),
                        Icon(Icons.check,color: Colors.brown[800],)
                      ]),
                      value: 5,)
                        :PopupMenuItem(child: Row(children: <Widget>[
                      Text('favorite')
                    ]),
                      value: 5,)
                  ];
                },
              ) ,
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: (deleteon == false)?IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => {
                  deleteflg()
                },
              )
                  :IconButton(
                icon: Icon(Icons.close),
                onPressed: (){
                  setState(() {
                    deleteflg();
                  });
                },
              ),
            ),
          ],
        ),
        floatingActionButton: (deleteon == false)?FloatingActionButton(
            child:Icon(Icons.add,color: Colors.amber[200],),backgroundColor: Colors.brown[700] ,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>Detail(
                    0,
                    null
                )),
              ).then((value) => setState(() {
                streamIn();
              }));
            })
            :Container(),
        body: (deleteon == false) ?Center(
            child:Container(
                decoration: BoxDecoration(
                    color: Colors.amber[200]
                ),
                child:Column(children:<Widget>[
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      height: height*0.07,
                      child:TextField(
                        controller: searchtext,
                        style: TextStyle(color: Colors.brown[700]),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.brown[700]),
                          hintText: 'search',
                          hintStyle: TextStyle(color: Colors.brown[700], fontSize: 20*adjustsizeh),
                        ),
                        onChanged:
                            (value){
                          onchanging(value);
                        },
                      )),
                  Expanded(
                      child:
                      StreamBuilder(
                          stream: _streamController.stream,
                          // ignore: missing_return
                          builder: (context, snapshot){
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(child:Container(height:height*0.01,width: width*0.02,
                                  child:CircularProgressIndicator()));
                            }
                            if(!snapshot.hasData){
                              return Container();
                            }
                            if(snapshot.hasData){
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index){
                                  final itemlist00 = snapshot.data;
                                  final item = itemlist00[index];
                                  final favoriteCheck = favorite.contains(item.id);
                                  return (item.memostyle==0)?InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>Detail(
                                            1,
                                            item.id
                                        )),
                                      ).then((value) => setState(() {
                                        streamIn();
                                      }));
                                    },
                                    onLongPress: () async {
                                      var dialog = await showDialog(context: context, builder: (BuildContext context){
                                        return SimpleDialog(
                                            backgroundColor: Colors.amber[200],
                                            children: <Widget>[
                                              SimpleDialogOption(onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) =>Detail(
                                                      1,
                                                      item.id
                                                  )),
                                                ).then((value) => setState(() {
                                                  Navigator.pop(context);
                                                  streamIn();
                                                }));
                                              },child: Container(
                                                  height:height*0.05,
                                                  width:width*0.4,
                                                  alignment:Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.brown[700],
                                                      border: Border.all(
                                                        color: Colors.brown[800],
                                                        width:1,
                                                      )),
                                                  child:Text('edit',style: TextStyle(fontSize: 22*adjustsizeh, color: Colors.yellow[200])))),
                                              SimpleDialogOption(onPressed: (){
                                                DB().insert(
                                                    Item(
                                                        title: item.title,
                                                        email: item.email,
                                                        pass: item.pass,
                                                        url: item.url,
                                                        memo: item.memo,
                                                        favorite: item.favorite,
                                                        memostyle: item.memostyle,
                                                        date: DateTime.now().toString()));
                                                setState(() {
                                                  streamIn();
                                                });
                                                Navigator.pop(context);
                                              },child: Container(
                                                height:height*0.05,
                                                width:width*0.4,
                                                alignment:Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: Colors.brown[700],
                                                    border: Border.all(
                                                      color: Colors.brown[800],
                                                      width:1,
                                                    )),
                                                child:Text('copy', style: TextStyle(fontSize: 22*adjustsizeh, color: Colors.yellow[200]),),)),
                                              SimpleDialogOption(onPressed: (){
                                                DB().delete(item.id);
                                                Navigator.pop(context);
                                                setState(() {
                                                  streamIn();
                                                });
                                              },child: Container(
                                                  height:height*0.05,
                                                  width:width*0.4,
                                                  alignment:Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.brown[700],
                                                      border: Border.all(
                                                        color: Colors.brown[800],
                                                        width:1,
                                                      )),
                                                  child:Text('delete', style: TextStyle(fontSize: 22*adjustsizeh, color: Colors.yellow[200]))))
                                            ]);
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: Container(
                                        height: height*0.02+height*0.03*displayHeight,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.spaceAround,
                                                      children: <Widget>[
                                                        (display1 == true)?Container(
                                                            width:width*0.85,
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    bottom: BorderSide(
                                                                      color: Colors.white,
                                                                      width:1,
                                                                    )
                                                                )),
                                                            height: height*0.03,
                                                            child:Row(children:<Widget>[SizedBox(width: width*0.05,),Text(item.title,
                                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: fontsize*adjustsizeh),
                                                            )])):Container(),
                                                        (display2 == true)?Container(
                                                            height: height*0.025,
                                                            child: Row(children:<Widget>[Text(
                                                                'ID/Email: '
                                                                    +item.email,
                                                                style: TextStyle(fontSize:fontsize*adjustsizeh, color: Colors.black54, fontWeight: FontWeight.w600)),
                                                              (item.email.length != 0) ?IconButton(icon: Icon(Icons.copy,size: iconsize*adjustsizeh,),
                                                                  onPressed:(){print(item.email);
                                                                    if(item.email.length != 0){
                                                                      ClipboardManager.copyToClipBoard(
                                                                          item.email);}
                                                                  })
                                                                  :Container(),
                                                            ])):Container(),
                                                        (display3 == true)?Container(
                                                          height: height*0.025,
                                                          width: width*0.6,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment.start,
                                                            children: <Widget>[
                                                              Container(
                                                                child: Text("PASSWORD: ",
                                                                    textAlign: TextAlign.center,
                                                                    style: TextStyle(
                                                                        fontSize: fontsize*adjustsizeh,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.black54)),
                                                              ),
                                                              Container(
                                                                  child:Text(item.pass,
                                                                    style: TextStyle(
                                                                        fontSize: fontsize*adjustsizeh,
                                                                        fontWeight: FontWeight.bold,
                                                                        color:Colors.black54),
                                                                  )
                                                              ),
                                                              (item.pass.length != 0) ?IconButton(icon: Icon(Icons.copy,size: iconsize*adjustsizeh),
                                                                onPressed: (){print(item.pass);
                                                                  if(item.pass.length != 0){
                                                                    ClipboardManager.copyToClipBoard(
                                                                        item.pass);}
                                                                },)
                                                                  :Container(),
                                                            ],
                                                          ),
                                                        ):Container(),
                                                        (display4 == true)?Container(
                                                            height: height*0.02,
                                                            width: width*0.65,
                                                            child:
                                                            Row(children: <Widget>[
                                                              Flexible(
                                                                child:Text(item.url,
                                                                  style: TextStyle(
                                                                    fontSize: fontsize*adjustsizeh,
                                                                    color: Colors.brown[800],
                                                                  ),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                              (item.url.length != 0)?IconButton(icon: Icon(Icons.copy, size: iconsize*adjustsizeh),
                                                                onPressed: (){
                                                                  if(item.pass.length != 0){
                                                                    ClipboardManager.copyToClipBoard(
                                                                        item.url);}
                                                                },)
                                                                  :Container()
                                                            ])):Container(),
                                                        (display5 == true)?Container(
                                                            height: height*0.025,
                                                            width: width*0.7,
                                                            child:Row(children:<Widget>[
                                                              SizedBox(width: width*0.03,),
                                                              Flexible(
                                                                child:Text(item.memo,
                                                                  style: TextStyle(
                                                                    fontSize: 14*adjustsizeh,
                                                                    color: Colors.brown[800],
                                                                  ),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 2,
                                                                ),
                                                              ),
                                                              Container(),
                                                            ])
                                                        ):Container(),
                                                      ])
                                              ),
                                              Container(
                                                height: height*0.15,
                                                decoration: BoxDecoration(
                                                ),
                                                child: Row(children: <Widget>[
                                                  SizedBox(width: width*0.02),
                                                  GestureDetector(
                                                      onTap: () {
                                                        if(favoriteCheck){
                                                          DB().update(
                                                              Item(
                                                                  id: item.id,
                                                                  title:item.title,
                                                                  email:item.email,
                                                                  pass: item.pass,
                                                                  url: item.url,
                                                                  memo: item.memo,
                                                                  favorite: 0,
                                                                  memostyle:item.memostyle,
                                                                  date: DateTime.now().toString()) ,
                                                              item.id);
                                                          setState(() {
                                                            favorite.remove(item.id);
                                                          });
                                                        }else{
                                                          DB().update(
                                                              Item(
                                                                  id: item.id,
                                                                  title:item.title,
                                                                  email:item.email,
                                                                  pass: item.pass,
                                                                  url: item.url,
                                                                  memo: item.memo,
                                                                  favorite: 1,
                                                                  memostyle: item.memostyle,
                                                                  date: DateTime.now().toString()),
                                                              item.id);
                                                          setState(() {
                                                            favorite.add(item.id);
                                                          });
                                                        }
                                                      },
                                                      child:(favoriteCheck)?Icon(Icons.favorite,color: Colors.brown[700], size: 30*adjustsizeh,)
                                                          :Icon(Icons.favorite_border, color: Colors.brown[700], size: 30*adjustsizeh,)
                                                  ),
                                                  SizedBox(width: width*0.025),
                                                ]),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  ):InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>Detail(
                                            1,
                                            item.id
                                        )),
                                      ).then((value) => setState(() {
                                        streamIn();
                                      }));
                                    },
                                    onLongPress: () async {
                                      var dialog = await showDialog(context: context, builder: (BuildContext context){
                                        return SimpleDialog(children: <Widget>[
                                          SimpleDialogOption(onPressed: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) =>Detail(
                                                  1,
                                                  item.id
                                              )),
                                            ).then((value) => setState(() {
                                              streamIn();
                                            }));
                                          },child: Container(
                                              height:height*0.05,
                                              width:width*0.4,
                                              alignment:Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.brown[700],
                                                  border: Border.all(
                                                    color: Colors.brown[800],
                                                    width:1,
                                                  )),
                                              child:Text('edit',style: TextStyle(fontSize: 22*adjustsizeh, color: Colors.yellow[200])))),
                                          SimpleDialogOption(onPressed: (){
                                            DB().insert(
                                                Item(
                                                    title: item.title,
                                                    email: item.email,
                                                    pass: item.pass,
                                                    url: item.url,
                                                    memo: item.memo,
                                                    memostyle: item.memostyle,
                                                    favorite: item.favorite,
                                                    date: DateTime.now().toString()));
                                            Navigator.pop(context);
                                          },child: Container(
                                              height:height*0.05,
                                              width:width*0.4,
                                              alignment:Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.brown[700],
                                                  border: Border.all(
                                                    color: Colors.brown[800],
                                                    width:1,
                                                  )),
                                              child:Text('copy', style: TextStyle(fontSize: 22*adjustsizeh, color: Colors.yellow[200])))),
                                          SimpleDialogOption(onPressed: (){
                                            DB().delete(item.id);
                                            Navigator.pop(context);
                                            setState(() {
                                              streamIn();
                                            });
                                          },child: Container(
                                              height:height*0.05,
                                              width:width*0.4,
                                              alignment:Alignment.center,
                                              decoration: BoxDecoration(
                                                  color: Colors.brown[700],
                                                  border: Border.all(
                                                    color: Colors.brown[800],
                                                    width:1,
                                                  )),
                                              child:Text('delete', style: TextStyle(fontSize: 22*adjustsizeh, color: Colors.yellow[200]))))
                                        ],);
                                      });
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      child: Container(
                                        height: height*0.02+height*0.03*displayHeight,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                  child:Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        SizedBox(height:height*0.016),
                                                        Container(
                                                            height: height*0.013+height*0.02*displayHeight,
                                                            width: width*0.7,
                                                            alignment: Alignment.topLeft,
                                                            child:Row(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children:<Widget>[
                                                                  SizedBox(width: width*0.03,),
                                                                  Flexible(
                                                                    child:Text(item.memo,
                                                                      style: TextStyle(
                                                                        fontSize: fontsize*adjustsizeh,
                                                                        color: Colors.brown[800],
                                                                      ),
                                                                      overflow: TextOverflow.ellipsis,
                                                                      maxLines: 5,
                                                                    ),
                                                                  ),
                                                                ])
                                                        )
                                                      ])
                                              ),
                                              Container(
                                                height: height*0.15,
                                                decoration: BoxDecoration(
                                                ),
                                                child: Row(children: <Widget>[
                                                  SizedBox(width: width*0.02),
                                                  GestureDetector(
                                                      onTap: () {
                                                        if(favoriteCheck){
                                                          DB().update(
                                                              Item(
                                                                  id: item.id,
                                                                  title:item.title,
                                                                  email:item.email,
                                                                  pass: item.pass,
                                                                  url: item.url,
                                                                  memo: item.memo,
                                                                  favorite: 0,
                                                                  memostyle:item.memostyle,
                                                                  date: DateTime.now().toString()),
                                                              item.id);
                                                          setState(() {
                                                            favorite.remove(item.id);
                                                          });
                                                        }else{
                                                          DB().update(
                                                              Item(
                                                                  id: item.id,
                                                                  title:item.title,
                                                                  email:item.email,
                                                                  pass: item.pass,
                                                                  url: item.url,
                                                                  memo: item.memo,
                                                                  favorite: 1,
                                                                  memostyle: item.memostyle,
                                                                  date: DateTime.now().toString()),
                                                              item.id);
                                                          setState(() {
                                                            favorite.add(item.id);
                                                          });
                                                        }
                                                      },
                                                      child:(favoriteCheck)?Icon(Icons.favorite,color: Colors.brown[700], size: 30*adjustsizeh)
                                                          :Icon(Icons.favorite_border, color: Colors.brown[700], size: 30*adjustsizeh)
                                                  ),
                                                  SizedBox(width: width*0.025),
                                                ]),
                                              ),
                                            ]),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }
                      )
                  ),
                ]))
        )
            :Center(
            child:Container(
                decoration: BoxDecoration(
                    color: Colors.amber[200]
                ),
                child:Column(children:<Widget>[
                  Container(
                      height: height*0.07,
                      width: width,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:<Widget> [
                            ElevatedButton(onPressed: (){
                              setState(() {
                                for(var i=0;i<deleteCheckList.length;i++){
                                  deleteCheckList[i]=true;
                                }
                                if(deleteValueStorage.isNotEmpty){
                                  for(var i=0;i<deleteValueStorage.length;i++){
                                    deleteValueList.add(deleteValueStorage[i]);
                                  }
                                }
                              });
                            }, child: Text('all check', style: TextStyle(color: Colors.yellow[200])),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.brown,
                                )),
                            SizedBox(width: width*0.2,),
                            ElevatedButton(onPressed: (){
                              setState(() {
                                for(var i=0;i<deleteCheckList.length;i++){
                                  deleteCheckList[i]=false;
                                }
                                deleteValueList.clear();
                              });
                            }, child: Text('all clear',style: TextStyle(color: Colors.yellow[200])),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.brown,
                                ))
                          ])),
                  Expanded(
                      child: StreamBuilder(
                          stream: _streamController.stream,
                          // ignore: missing_return
                          builder: (context, snapshot){
                            if(!snapshot.hasData){
                              return Container();
                            }
                            if(snapshot.hasData){
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index){
                                  final itemlist00 = snapshot.data;
                                  final item = itemlist00[index];
                                  return Container(child:Row(children:<Widget>[
                                    Container(
                                        height:height*0.15*0.7,
                                        width:width*0.1,
                                        child: Checkbox(
                                          activeColor: Colors.brown,
                                          value: deleteCheckList[index],
                                          onChanged: (value){
                                            setState(() {
                                              if(value) {
                                                deleteCheckList[index] = value;
                                                if(deleteValueList.contains(item.id.toString())==false){
                                                  deleteValueList.add(item.id.toString());
                                                }
                                              }
                                              else{
                                                deleteCheckList[index] = value;
                                                if(deleteValueList.contains(item.id.toString())){
                                                  deleteValueList.remove(item.id.toString());
                                                }
                                              }
                                            });
                                          },
                                        )),
                                    (item.memostyle==0)?InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        child: Container(
                                          height: height*0.7*0.02+height*0.7*0.03*displayHeight,
                                          width: width*0.8,
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceAround,
                                                        children: <Widget>[
                                                          (display1 ==true)?Container(
                                                              width:width*0.85*0.7,
                                                              decoration: BoxDecoration(
                                                                  border: Border(
                                                                      bottom: BorderSide(
                                                                        color: Colors.white,
                                                                        width:1,
                                                                      )
                                                                  )),
                                                              height: height*0.03*0.7,
                                                              child:Row(children:<Widget>[SizedBox(width: width*0.05*0.7,),
                                                                Text(item.title,
                                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: fontsize*adjustsizeh*0.7),
                                                                )])):Container(),
                                                          (display2 == true)?Container(
                                                              height: height*0.025*0.8,
                                                              child: Row(children:<Widget>[Text(
                                                                  ' Email:'
                                                                      +item.email,
                                                                  style: TextStyle(fontSize:fontsize*adjustsizeh*0.7, color: Colors.black54)),
                                                                (item.email.length != 0) ?IconButton(icon: Icon(Icons.copy,size: iconsize*adjustsizeh*0.7), onPressed:(){
                                                                  if(item.email.length != 0){
                                                                    ClipboardManager.copyToClipBoard(
                                                                        item.email);}
                                                                })
                                                                    :Container(),
                                                              ])):Container(),
                                                          (display3 == true)?Container(
                                                            height: height*0.025*0.7,
                                                            width: width*0.6*0.8,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.start,
                                                              children: <Widget>[
                                                                Container(
                                                                  child: Text(" PASSWORD:",
                                                                      textAlign: TextAlign.center,
                                                                      style: TextStyle(
                                                                          fontSize: fontsize*adjustsizeh*0.7,
                                                                          fontWeight: FontWeight.w600,
                                                                          color: Colors.black54)),
                                                                ),
                                                                Container(
                                                                  child:Text(item.pass,
                                                                    style: TextStyle(
                                                                        fontSize: fontsize*adjustsizeh*0.7,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: Colors.black54),
                                                                  ),
                                                                ),
                                                                (item.pass.length != 0) ?IconButton(
                                                                  icon: Icon(Icons.copy,size: iconsize*adjustsizeh*0.7),
                                                                  onPressed: (){
                                                                    if(item.pass.legth != 0){
                                                                      ClipboardManager.copyToClipBoard(
                                                                          item.pass);}
                                                                  },)
                                                                    :Container(),
                                                              ],
                                                            ),
                                                          ):Container(),
                                                          (display4 == true)?Container(
                                                              height: height*0.02*0.7,
                                                              width: width*0.65*0.7,
                                                              child:Row(children: <Widget>[
                                                                Flexible(
                                                                  child:Text(' '+item.url,
                                                                    style: TextStyle(
                                                                      fontSize: fontsize*adjustsizeh*0.7,
                                                                      color: Colors.brown[800],
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                ),
                                                                (item.url.length != 0)?IconButton(icon: Icon(Icons.copy, size: iconsize*adjustsizeh*0.7),
                                                                  onPressed: (){
                                                                    if(item.pass.legth != 0){
                                                                      ClipboardManager.copyToClipBoard(
                                                                          item.url);}
                                                                  },)
                                                                    :Container()
                                                              ])):Container(),
                                                          (display5 == true)?Container(
                                                              height: height*0.02,
                                                              width: width*0.7,
                                                              alignment: Alignment.topLeft,
                                                              child: Row(children: <Widget>
                                                              [Flexible(
                                                                  child:Text(' '+item.memo,
                                                                    style: TextStyle(
                                                                      fontSize: fontsize*adjustsizeh*0.7,
                                                                      color: Colors.brown[800],
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                )])
                                                          ):Container(),
                                                        ])
                                                ),
                                                Container(
                                                  height: height*0.15*0.7,
                                                  decoration: BoxDecoration(
                                                  ),
                                                  child: Row(children: <Widget>[
                                                    SizedBox(width: width*0.02*0.7),
                                                    GestureDetector(
                                                        onTap: () {
                                                        },
                                                        child:(item.favorite==true)?Icon(Icons.favorite,color: Colors.brown[700], size: 30*0.7)
                                                            :Icon(Icons.favorite_border,color: Colors.brown[700], size: 30*0.7,)
                                                    ),
                                                    SizedBox(width: width*0.025*0.7),
                                                  ]),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    )
                                        :InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        child: Container(
                                          height: height*0.7*0.02+height*0.7*0.03*displayHeight,
                                          width: width*0.8,
                                          child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceAround,
                                                        children: <Widget>[
                                                          Container(
                                                              height: height*0.02,
                                                              width: width*0.7,
                                                              alignment: Alignment.topLeft,
                                                              child: Row(children: <Widget>
                                                              [Flexible(
                                                                  child:Text(item.memo,
                                                                    style: TextStyle(
                                                                      fontSize: fontsize*adjustsizeh*0.7,
                                                                      color: Colors.brown[800],
                                                                    ),
                                                                    overflow: TextOverflow.ellipsis,
                                                                    maxLines: 1,
                                                                  ),
                                                                )])
                                                          )
                                                        ])
                                                ),
                                                Container(
                                                  height: height*0.15*0.7,
                                                  decoration: BoxDecoration(
                                                  ),
                                                  child: Row(children: <Widget>[
                                                    SizedBox(width: width*0.02*0.7),
                                                    GestureDetector(
                                                        onTap: () {
                                                        },
                                                        child:(item.favorite==true)?Icon(Icons.favorite,color: Colors.brown[700], size: 30*0.7)
                                                            :Icon(Icons.favorite_border,color: Colors.brown[700], size: 30*0.7,)
                                                    ),
                                                    SizedBox(width: width*0.025*0.7),
                                                  ]),
                                                ),
                                              ]),
                                        ),
                                      ),
                                    ),
                                  ]));
                                },
                              );
                            }
                          }
                      )
                  ),
                  Container(
                      height: height*0.1,
                      width: width*0.7,
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                          onPressed: () {
                            deleteOn();
                            setState(() {
                              deleteon = false;
                              streamIn();
                            });
                          },
                          style:ElevatedButton.styleFrom(
                            primary: Colors.brown,
                          ),
                          child: Text('DELETE', style: TextStyle(color: Colors.yellow[200])))),
                ]))
        )
    );
  }
}
