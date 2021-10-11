import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class NewImageNetwork extends StatelessWidget {
  String url;
  NewImageNetwork(this.url);
  @override
  Widget build(BuildContext context) {
    int randomNum =Random().nextInt(100000);
    return GestureDetector(
      child: Hero(
        tag: randomNum.toString()+'w',
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return DetailScreen(url);
        }));
      },
    );
  }
}


class DetailScreen extends StatefulWidget {
  String url;
  DetailScreen(this.url);


  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {


  @override
  Widget build(BuildContext context) {
    int randomNum =Random().nextInt(100000);

    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag:randomNum.toString()+'q',
            child: CachedNetworkImage(
              imageUrl:widget.url,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}