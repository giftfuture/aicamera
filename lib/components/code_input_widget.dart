import 'package:flutter/material.dart';

class CodeInputBox extends StatefulWidget {
  Function(String code) codeChange;
  CodeInputBox({super.key,required this.codeChange});

  @override
  CodeInputBoxState createState() => CodeInputBoxState();
}

class CodeInputBoxState extends State<CodeInputBox> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 4; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
      _focusNodes[i].addListener(() {
        if(_focusNodes[i].hasFocus){
          _controllers[i].selection = TextSelection.fromPosition(TextPosition(
            affinity: TextAffinity.downstream,
            offset: _controllers[i].text.length,
          ));
        }
        if(_focusNodes[i].hasFocus && _controllers[i].text.isEmpty && i > 0){
          FocusScope.of(context).requestFocus(_focusNodes[i-1]);
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
       return Container(
         width: 70,
         margin: EdgeInsets.only(right:index == 3 ? 0:15),
         child: TextField(
           controller: _controllers[index],
           focusNode: _focusNodes[index],
           textAlign: TextAlign.center,
           maxLength: index == 3 ? 1:2,
           keyboardType: TextInputType.number,
           decoration: const InputDecoration(
             border: InputBorder.none,
             counterText: '',
           ),
           onChanged: (value) {
             if (value.length > 1 && index < 3) {
               _controllers[index+1].text = _controllers[index].text.substring(1,2);
               _controllers[index].text = _controllers[index].text.substring(0,1);
               if(index == 0){
                 _controllers[2].clear();
                 _controllers[3].clear();
               }
               if(index == 1){
                 _controllers[3].clear();
               }
               if(index == 2) {
                 FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
               } else {
                 FocusScope.of(context).requestFocus(_focusNodes[index + 2]);
               }
             }
             if (value.length == 1 && index < 3) {
               FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
             }
             if (value.isEmpty && index < 4) {
               if(index > 0)FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
               for(int j = 0; j < 4; j++){
                 if(index < j)_controllers[j].clear();
               }
             }
             if(value.length == 2 && index == 2){
                 FocusScope.of(context).requestFocus(FocusNode());
             }
             widget.codeChange(_controllers[0].text+_controllers[1].text+_controllers[2].text+_controllers[3].text);
           },
         ),
       );
        // index == 1 ? const SizedBox.shrink():const SizedBox(width: 30,),
      }),
    );
  }
}