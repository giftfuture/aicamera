import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FirstRefreshWidget extends StatelessWidget {
  final String? progress;
  final String? text;

  const FirstRefreshWidget({super.key, this.progress, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
          height: 120.0,
          width: 120.0,
          child: Card(
            elevation: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50.0,
                  height: 50.0,
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(bottom: 5),
                  child: SpinKitRotatingCircle(size: 50.0,color: Theme.of(context).colorScheme.primaryContainer,),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text('${text ?? '正在加载...'}${progress ?? ''}'),
                ),
              ],
            ),
          ),
        ));
  }
}

typedef OnTap = Function();

class EmptyImgWidget extends StatelessWidget {
  final String? title;
  final OnTap? onTap;

  const EmptyImgWidget({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Image.asset('assets/day/no_data_icon.png',
          //     width: 150.0, height: 150.0),
          Text(
            title ?? '暂无数据',
          ),
        ],
      ),
    );
  }
}