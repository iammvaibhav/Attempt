import 'package:attempt/repository/SentencesRepository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stetho/flutter_stetho.dart';

import 'home/HomeScreen.dart';


void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.blue[800], // status bar color
      systemNavigationBarColor: Colors.black
  ));

  Stetho.initialize();
  runApp(MyApp());
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  FirebaseDatabase.instance.reference().child("words").keepSynced(true);
  FirebaseDatabase.instance.reference().child("words").onChildRemoved.listen((event) {
    final word = event.snapshot.value["word"];
    SentencesRepository.getInstance().removeSentencesFor(word);
  });
  FirebaseDatabase.instance.reference().child("words").onChildAdded.listen((event) {
    final word = event.snapshot.value["word"];
    SentencesRepository.getInstance().downloadIfNotDownloaded(word);
  });

  SentencesRepository.getInstance().downloadNonDownloadedSentences();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeScreen()
    );
  }
}