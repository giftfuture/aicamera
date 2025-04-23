import 'package:flutter/material.dart';


class MyTabs extends StatefulWidget {
  final List tabs;
  MyTabs({super.key, required this.tabs,required this.onTab,required this.scrollDirection});
  int onTabIndex = 0;
  Function(int index) onTab;
  Axis scrollDirection;
  @override
  State<MyTabs> createState() => _LeftTabsState();
}

class _LeftTabsState extends State<MyTabs> {
  @override
  Widget build(BuildContext context) {
    if (widget.scrollDirection == Axis.vertical) {
      return SizedBox(
      width: 50,
      child: ListView.builder(
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          return _VerticalTabItems(str: widget.tabs[index], index: index, isOnTab: widget.onTabIndex == index, onTab:(index){
            setState(() {
              widget.onTabIndex = index;
            });
            widget.onTab(index);
          });
        },
      ),
    );
    } else {
      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20.0), // 设置圆角
        ),
        child: Row(
        children: widget.tabs.map((str){
          int index = widget.tabs.indexOf(str);
          return _HorizontalTabItems(str: widget.tabs[index], index: index, isOnTab: widget.onTabIndex == index, onTab:(index){
            setState(() {
              if(widget.onTabIndex == index){
                widget.onTabIndex = -1;
              }else {
                widget.onTabIndex = index;
              }
            });
            widget.onTab(widget.onTabIndex);
          });
        }).toList(),
            ),
      );
    }
  }
}


class _VerticalTabItems extends StatelessWidget {
  String str;
  bool isOnTab;
  int index;
  Function(int index) onTab;
  _VerticalTabItems({required this.str, required this.isOnTab, required this.index, required this.onTab});
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = isOnTab ? TextStyle(color:  Theme.of(context).colorScheme.error,fontWeight: FontWeight.bold):const TextStyle();
    List<Widget> strList = [];
    strList.add(Image.asset("assets/image/login_coffee.png",width: 20,));
    strList.add(const SizedBox(height: 10,));
    strList.addAll(str.characters.map((e) => Text(e,style: textStyle,)).toList());
    return Ink(
      color: Theme.of(context).colorScheme.primaryContainer,//isOnTab ? Theme.of(context).colorScheme.errorContainer :
      child: InkWell(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: strList,
          ),
        ),
        onTap: (){
          onTab(index);
        },
      ),
    );
  }
}


class _HorizontalTabItems extends StatelessWidget {
  String str;
  bool isOnTab;
  int index;
  Function(int index) onTab;
  _HorizontalTabItems({required this.str, required this.isOnTab, required this.index, required this.onTab});
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = isOnTab ? TextStyle(color:  Theme.of(context).colorScheme.error,fontWeight: FontWeight.bold,fontSize: 16):const TextStyle(fontSize: 16);
    return Expanded(
      child: Ink(
        color: Theme.of(context).colorScheme.primaryContainer,//isOnTab ? Theme.of(context).colorScheme.errorContainer :
        child: InkWell(
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0), // 设置圆角
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),child: Center(child: Text(str,style: textStyle,))),
          onTap: (){
            onTab(index);
          },
        ),
      ),
    );
  }
}




