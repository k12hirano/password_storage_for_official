import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_for_official/db.dart';
import 'package:password_storage_for_official/item.dart';

class Detail extends StatefulWidget {
  final argumentmode;
  final id;
  Detail(this.argumentmode,this.id);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {

  List<bool> isSelected;
  TextEditingController titletext0;
  TextEditingController emailtext0;
  TextEditingController passtext0;
  TextEditingController urltext0;
  TextEditingController memotext0;
  bool favo;
  bool datagetflg = false;
  bool memostyle = false;
  // ignore: non_constant_identifier_names
  double TextFieldFontSize = 20;
  var titletext = TextEditingController();
  var emailtext = TextEditingController();
  var passtext = TextEditingController();
  var urltext = TextEditingController();
  var memotext = TextEditingController();
  var titletext123 = TextEditingController(text: 'controller');

  @override
  void initState() {
    isSelected = [true, false];
    if(widget.argumentmode == 1 || widget.argumentmode==2){
      setState(() {
        getdata(widget.id);
      });}else{}
    super.initState();
  }

  @override
  void dispose() {
    titletext?.dispose();
    titletext0?.dispose();
    emailtext?.dispose();
    emailtext0?.dispose();
    passtext?.dispose();
    passtext0?.dispose();
    urltext0?.dispose();
    urltext?.dispose();
    memotext0?.dispose();
    memotext?.dispose();
    super.dispose();
  }

  void getdata(int id) async{
    datagetflg = false;
    var forEdit = await DB().select(id);
    titletext0 = TextEditingController(text:forEdit[0].title);
    emailtext0 = TextEditingController(text:forEdit[0].email);
    passtext0 = TextEditingController(text:forEdit[0].pass);
    urltext0 = TextEditingController(text:forEdit[0].url);
    memotext0 = TextEditingController(text:forEdit[0].memo);
    setState(() {
      if(forEdit[0].favorite==0){
        favo=false;
      }else{
        favo=true;
      }
      datagetflg = true;
      if(widget.argumentmode==2){
        memostyle=true;
      }
    });
  }

  void insert() async {
    if(memostyle==false){
      return await  DB().insert(
          Item(
              title: titletext.text,
              email:emailtext.text,
              pass:passtext.text,
              url:urltext.text,
              memo:memotext.text,
              favorite: 0,
              memostyle: 0,
              date: DateTime.now().toString()));}else{
      return await  DB().insert(
          Item(
              title: titletext.text,
              email:emailtext.text,
              pass:passtext.text,
              url:urltext.text,
              memo:memotext.text,
              favorite: 0,
              memostyle: 1,
              date: DateTime.now().toString()));
    }
  }

   update() async {
    if(favo==false) {if(memostyle==false){
    return await DB().update(Item(
        id: widget.id,
        title: titletext0.text,
        email: emailtext0.text,
        pass: passtext0.text,
        url: urltext0.text,
        memo: memotext0.text,
        favorite: 0,
        memostyle: 0,
        date: DateTime.now().toString()), widget.id);}else{
    return await DB().update(Item(
        id: widget.id,
        title: titletext0.text,
        email: emailtext0.text,
        pass: passtext0.text,
        url: urltext0.text,
        memo: memotext0.text,
        favorite: 0,
        memostyle: 1,
        date: DateTime.now().toString()), widget.id);
    }
    }else if(favo==true){if(memostyle==false){
    return await DB().update(Item(
        id: widget.id,
        title: titletext0.text,
        email: emailtext0.text,
        pass: passtext0.text,
        url: urltext0.text,
        memo: memotext0.text,
        favorite: 1,
        memostyle: 0,
        date: DateTime.now().toString()), widget.id);}else {
    return await DB().update(Item(
        id: widget.id,
        title: titletext0.text,
        email: emailtext0.text,
        pass: passtext0.text,
        url: urltext0.text,
        memo: memotext0.text,
        favorite: 1,
        memostyle: 1,
        date: DateTime.now().toString()), widget.id);
    }}}

  favoriteOnOff() async{
    List<Item> dataget = await DB().select(widget.id);

    setState(() {
      if(favo){
        DB().update(
            Item(
                id: widget.id,
                title: dataget[0].title,
                email: dataget[0].email,
                pass: dataget[0].pass,
                url: dataget[0].url,
                memo: dataget[0].memo,
                favorite: 0,
                memostyle: dataget[0].memostyle,
                date: dataget[0].date),
            widget.id);
        favo=false;
      }else{
        DB().update(
            Item(
                id: widget.id,
                title: dataget[0].title,
                email: dataget[0].email,
                pass: dataget[0].pass,
                url: dataget[0].url,
                memo: dataget[0].memo,
                favorite: 1,
                memostyle: dataget[0].memostyle,
                date: dataget[0].date),
            widget.id);
        favo=true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final adjustsizeh = MediaQuery.of(context).size.height * 0.0011;

    return Scaffold(
        backgroundColor: Colors.amber[200],
        appBar: AppBar(
          elevation: 8,
          centerTitle: true,
          title:Text("Detail / Edit ",style: TextStyle(color: Colors.yellow[200])),
          backgroundColor: Colors.brown[800],
          actions: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child:(widget.argumentmode ==1 && datagetflg == true)?IconButton(
                  icon: (favo==false)?Icon(Icons.favorite,color: Colors.white)
                      :Icon(Icons.favorite, color: Colors.yellow[200]),
                  onPressed: () => {
                    favoriteOnOff()
                  }
              ):(widget.argumentmode == 2 && datagetflg == true)?IconButton(
                  icon: (favo==false)?Icon(Icons.favorite,color: Colors.white)
                      :Icon(Icons.favorite, color: Colors.yellow[200]),
                  onPressed: () => {
                    favoriteOnOff()
                  }
              )
                  :Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: (widget.argumentmode == 1 || widget.argumentmode == 2)?
              IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            backgroundColor: Colors.amber[200],
                            actions: <Widget>[
                              Container(
                                  height:height*0.2,
                                  width: width*0.7,
                                  child:Column(
                                    children: <Widget>[
                                      Container(
                                          height:height*0.15,
                                          width: width*0.7,
                                          alignment: Alignment.center,
                                          child: Text("DELETE THIS ITEM?", style: TextStyle(color: Colors.brown[800], fontSize: 20*adjustsizeh, fontWeight: FontWeight.w500))),
                                      Container(
                                        height:height*0.05,
                                        width: width*0.7,
                                        child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              InkWell(
                                                  child: Container(
                                                      color: Colors.amber[200],
                                                      height:height*0.05,
                                                      width: width*0.35,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        border: Border(
                                                          top: BorderSide(
                                                            color: Colors.brown[800],
                                                            width: 2,
                                                          ),
                                                          right: BorderSide(
                                                            color: Colors.brown[800],
                                                            width: 1,
                                                          ),
                                                        ),
                                                      ),
                                                      child: Text('Cancel', style: TextStyle(color: Colors.brown[800], fontSize: 18*adjustsizeh, fontWeight: FontWeight.w500))),
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  }),
                                              InkWell(child: Container(
                                                  color: Colors.amber[200],
                                                  height:height*0.05,
                                                  width:width*0.35,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      left: BorderSide(
                                                        color: Colors.brown[800],
                                                        width: 1,
                                                      ),
                                                      top: BorderSide(
                                                        color: Colors.brown[800],
                                                        width: 2,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Text('Delete', style: TextStyle(color: Colors.brown[800], fontSize: 18*adjustsizeh, fontWeight: FontWeight.w500))),
                                                  onTap: (){
                                                    DB().delete(widget.id);
                                                    int count = 0;
                                                    Navigator.popUntil(context, (_) => count++ >= 2);
                                                  })
                                            ]),
                                      )
                                    ],
                                  )
                              )
                            ],
                          );})}) :Container(),
            ),
          ],
        ),
        body: Center(child: SingleChildScrollView(
            child:Container(
                height: height*0.9,
                decoration: (BoxDecoration(color: Colors.amber[200])),
                child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:<Widget>[
                      (widget.argumentmode==0)?Container(
                        height: height*0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CupertinoSwitch(
                              activeColor: Colors.brown[700],
                              value: memostyle,
                              onChanged: (bool value) {
                                setState(() {
                                  memostyle= value;
                                });
                              },
                            ),
                            Container(child: Text('MEMO STYLE',style: TextStyle(fontSize: 18*adjustsizeh))),
                          ],),
                      )
                          :Container(),
                      (memostyle == false)?Container(
                        height:height*0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: height*0.075,
                                width: width*0.85,
                                child: (widget.argumentmode == 1 && datagetflg == true)?TextFormField( decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'title'),
                                    controller: titletext0,
                                    style: TextStyle(
                                        fontSize: TextFieldFontSize*adjustsizeh,
                                        height: 2.0,
                                        color: Colors.brown
                                    ))
                                    :TextFormField( decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'title'),
                                    controller: titletext,
                                    style: TextStyle(
                                        fontSize: TextFieldFontSize*adjustsizeh,
                                        height: 2.0,
                                        color: Colors.brown
                                    ))),
                            Container(
                                height: height*0.075,
                                width: width*0.85,
                                child: (widget.argumentmode == 1 && datagetflg == true) ?TextFormField( decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'id/Email/user name/etc...'),
                                    controller: emailtext0,
                                    style: TextStyle(
                                        fontSize: TextFieldFontSize*adjustsizeh,
                                        height: 2.0,
                                        color: Colors.brown
                                    ))
                                    :TextFormField( decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'id/Email/user name/etc...'),
                                    controller: emailtext,
                                    style: TextStyle(
                                        fontSize: TextFieldFontSize*adjustsizeh,
                                        height: 2.0,
                                        color: Colors.brown
                                    ))),
                            Container(
                                height: height*0.08,
                                width: width*0.85,
                                child: (widget.argumentmode == 1 && datagetflg == true) ?TextFormField( decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'PassWord'),
                                    controller: passtext0,
                                    style: TextStyle(
                                        fontSize: TextFieldFontSize*adjustsizeh,
                                        height: 2.0,
                                        color: Colors.brown
                                    ))
                                    :TextFormField( decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'PassWord'),
                                    controller: passtext,
                                    style: TextStyle(
                                        fontSize: TextFieldFontSize*adjustsizeh,
                                        height: 2.0,
                                        color: Colors.brown
                                    ))),
                            Container(
                                height: height*0.075,
                                width: width*0.85,
                                child: (widget.argumentmode == 1 && datagetflg == true) ?TextFormField(decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'URL'),
                                    controller: urltext0,
                                    style: TextStyle(
                                        fontSize: 18*adjustsizeh,
                                        height: 2.0,
                                        color: Colors.brown
                                    ))
                                    :TextFormField(decoration: InputDecoration(
                                    isDense: true,
                                    labelText: 'URL'),
                                    controller: urltext,
                                    style: TextStyle(
                                        fontSize: 18*adjustsizeh,
                                        height: 2.0,
                                        color: Colors.brown
                                    ))),
                            Container(
                              height: height*0.15,
                              width: width*0.85,
                              child: (widget.argumentmode == 1 && datagetflg == true) ?TextFormField( decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'memo'),
                                  controller: memotext0,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(
                                      fontSize: TextFieldFontSize*adjustsizeh,
                                      height: 2.0,
                                      color: Colors.brown
                                  ))
                                  :TextFormField( decoration: InputDecoration(
                                  isDense: true,
                                  labelText: 'memo'),
                                  controller: memotext,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  style: TextStyle(
                                      fontSize: TextFieldFontSize*adjustsizeh,
                                      height: 2.0,
                                      color: Colors.brown
                                  )))
                          ]))
                          :Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.fromLTRB(50, 0, 50, 200),
                          height: height*0.5,
                          child: (widget.argumentmode == 2 && datagetflg == true) ?TextFormField( decoration: InputDecoration(
                              isDense: true,
                              labelText: 'memo'),
                              controller: memotext0,
                              keyboardType: TextInputType.multiline,
                              maxLines: 100,
                              style: TextStyle(
                                  fontSize: 18*adjustsizeh,
                                  height: 2.0,
                                  color: Colors.brown
                              ))
                              :TextFormField( decoration: InputDecoration(
                              isDense: true,
                              labelText: 'memo'),
                              controller: memotext,
                              keyboardType: TextInputType.multiline,
                              maxLines: 100,
                              style: TextStyle(
                                  fontSize: 18*adjustsizeh,
                                  height: 2.0,
                                  color: Colors.brown
                              ))),
                      Container(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                height: height*0.05,
                                width:width*0.3,
                                child:ElevatedButton(onPressed: (){
                                  Navigator.pop(context);
                                }, child: Text('cancel',style: TextStyle(fontSize: 18*adjustsizeh,color: Colors.yellow[200])),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.brown,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        )
                                    ))),
                            SizedBox(width: width*0.1,),
                            Container(
                                height: height*0.05,
                                width:width*0.3,
                                child:(widget.argumentmode == 0)?ElevatedButton(onPressed: (){
                                  insert();
                                  Navigator.pop(context);
                                }, child: Text('OK',style: TextStyle(fontSize: 18*adjustsizeh ,color: Colors.yellow[400])),
                                    style:  ElevatedButton.styleFrom(
                                        primary: Colors.brown,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        )
                                    ))
                                    :ElevatedButton(onPressed: (){
                                        update();
                                  Navigator.pop(context);
                                }, child: Text('OK',style: TextStyle(fontSize: 18*adjustsizeh ,color: Colors.yellow[400])),
                                    style:  ElevatedButton.styleFrom(
                                        primary: Colors.brown,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        )
                                    ))
                            )
                          ]))
                    ]))
        )
        ));
  }
}
