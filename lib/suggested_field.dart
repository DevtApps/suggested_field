library suggested_field;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:suggested_field/suggestion.dart';

class SuggestedField extends StatelessWidget {
  bool loading = false;
  List<Suggestion> suggestions;
  Function(Suggestion) onTap;
 
  bool closeOnEmpty;
  FocusNode focusNode = FocusNode();


  RxList<Suggestion> filtered = RxList<Suggestion>();

  SuggestedField(
      {super.key,
      this.closeOnEmpty = true,
      required this.suggestions,
      this.loading = false,
      required this.onTap}){

      focusNode.addListener(() { 
        if(focusNode.hasFocus){
          filter("");
        }else{
          filtered.clear();
        }
      });
      }

  void filter(String text) {
    if (text.isEmpty) {
      if (closeOnEmpty)
        return filtered.clear();
      else {
        filtered.clear();
        filtered.addAll(suggestions);
      }
    } else {
      var result = suggestions
          .where((element) => element.title
              .toLowerCase()
              .contains(text.toString().toLowerCase()))
          .toList();
      filtered.clear();
      filtered.addAll(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: ()async{

        if(focusNode.hasFocus){
          focusNode.unfocus();
          return false;
        }

        return true;
      },
      child: Material(
      color: Colors.transparent,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
           focusNode: focusNode,
            onChanged: filter,
            decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                hintText: "Pesquise postos de recarga...",
                suffixIcon: Icon(Icons.search)),
          ),
          Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
              height: loading
                      ? 60
                      : ((filtered.firstOrNull?.subtitle != null ? 60 : 50) *
                              filtered.length)
                          .toDouble(),
              constraints: BoxConstraints(maxHeight: size.height / 3),
              child: loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      padding: EdgeInsets.zero,
                      children: filtered
                          .map((e) => ListTile(
                                dense: true,
                                title: Text(e.title),
                                subtitle: e.subtitle != null
                                    ? Text(e.subtitle!)
                                    : null,
                                onTap: () {
                                   FocusScope.of(context).unfocus();
                                  
                                  onTap(e);
                                },
                              ))
                          .toList(),
                    ),
            ),
          ),
        ]),
      ),),
    );
  }
}
