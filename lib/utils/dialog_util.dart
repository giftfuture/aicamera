import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingDialog extends Dialog {

  LoadingDialog(this.canceledOnTouchOutside, {super.key});
  final bool canceledOnTouchOutside;
  bool isShow = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(isShow) {
          Navigator.pop(context);
          isShow = false;
        }
        return false;
      },
      child: Center(
        child: Material(
            color: Colors.transparent,
            child: Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if(canceledOnTouchOutside){
                      Navigator.pop(context);
                      isShow = false;
                    }
                  },
                ),
                _dialog()
              ],
            )
        ),
      ),
    );
  }

  Widget _dialog(){
    return Center(
      ///弹框大小
      child: SizedBox(
        width: 150.0,
        height: 150.0,
        child: Container(
          decoration: const ShapeDecoration(
            color: Color(0xffffffff),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(
                  top: 20.0,
                ),
                child: Text(
                  "加载中...",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogRouter extends PageRouteBuilder{

  final Widget page;

  DialogRouter(this.page)
      : super(
    opaque: false,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}

class LoadingUtil{
  static late LoadingDialog loadingDialog;
  static show(context, {bool isClose = true}){
    loadingDialog = LoadingDialog(isClose);
    Navigator.push(context, DialogRouter(loadingDialog));
    loadingDialog.isShow = true;
  }
  static hide(context){
    if(loadingDialog != null && loadingDialog.isShow){
      loadingDialog.isShow = false;
      Navigator.pop(context);
    }
  }

  static toast(title,content,color){
    Get.snackbar(
      title,
      content,
      icon: Icon(Icons.error,color: color,),
      colorText: color,
      shouldIconPulse: true,
      barBlur: 20,
      isDismissible: true,
      duration: const Duration(seconds: 1),
    );
  }
}