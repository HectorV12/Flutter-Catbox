import 'dart:async';
import 'package:catbox/ui/cat_details/details_page.dart';
import 'package:catbox/models/cat.dart';
import 'package:catbox/services/api.dart';
import 'package:catbox/utils/routes.dart';
import 'package:flutter/material.dart';

class CatList extends StatefulWidget {
  @override
  _CatListState createState() => _CatListState();
}

class _CatListState extends State<CatList> {
  List<Cat> _cats = [];
  CatApi _api;
  NetworkImage _profileImage;

  @override
  void initState(){
    super.initState();
    _loadFromFirebase();
    _reloadCats();
    }

  _loadFromFirebase() async {
    final api = await CatApi.signInWithGoogle();
    final cats = await api.getAllCats();

    setState(() {
      _api = api;
      _cats = cats;
      _profileImage = new NetworkImage(api.firebaseUser.photoUrl);
    });
  }

  _reloadCats() async {
    if (_api != null) {
      final cats = await _api.getAllCats();
      setState(() {
        _cats = cats;
      });
    }
  }

  _navigateToCatDetails(Cat cat, Object avatarTag){
    Navigator.of(context).push(
      new FadePageRoute(
        builder: (c) {
          return new CatDetailsPage(cat, avatarTag: avatarTag);
        },
        settings: new RouteSettings(),
      )
    );
  }
  
  Widget _getAppTitleWidget() {
    return new Text('Cats',
    style: new TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontSize: 130.0,
    ),);
  }

  Widget _buildBody() {
    return new Container(
      margin: const EdgeInsets.fromLTRB(8.0, 56.0, 8.0, 0.0),
      child: new Column(
        children: <Widget>[
          _getAppTitleWidget(),
          _getListViewWidget(),
        ],
      ),
    );
  }

  Widget _buildCatItem(BuildContext context, int index){
    Cat cat = _cats[index];
    return new Container(
      margin: const EdgeInsets.only(top: 5.0),
      child: new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new ListTile(
              onTap: () => _navigateToCatDetails(cat, index),
              leading: new Hero(
                tag: index,
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(cat.avatarUrl),
                ),
              ),
              title: new Text(
                cat.name,
                style: new TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              subtitle: new Text(cat.description),
              isThreeLine: true,
              dense: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> refresh(){
    _reloadCats();
    return new Future<Null>.value();
  }

  Widget _getListViewWidget(){
    return new Flexible(
        child: new RefreshIndicator(
          onRefresh: refresh,
          child: new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _cats.length,
              itemBuilder: _buildCatItem),));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade900,
      body:  _buildBody(),
      floatingActionButton: new FloatingActionButton(
          onPressed: () {
            //TODO: Add something here
          },
      tooltip: _api != null ? 'Signed-in ' + _api.firebaseUser.displayName : 'Not Signed-in',
        backgroundColor: Colors.redAccent,
        child: new CircleAvatar(
          backgroundImage: _profileImage,
          radius: 50.0,
        ),
      ),
    );
  }
}
