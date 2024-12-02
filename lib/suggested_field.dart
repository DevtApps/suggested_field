library suggested_field;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:suggested_field/suggestion.dart';

class SuggestedField extends StatelessWidget {
  bool loading = false;
  List<Suggestion> suggestions = [];
  Function(Suggestion) onTap;
  String hint;

  bool closeOnEmpty;
  FocusNode focusNode = FocusNode();

  RxList<Suggestion> filtered = RxList<Suggestion>();

  SuggestedField(
      {super.key,
      this.hint = "Search...",
      this.closeOnEmpty = true,
      required this.suggestions,
      this.loading = false,
      required this.onTap}) {
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        filter("");
      } else {
        filtered.clear();
      }
    });
  }

  void filter(String text) {
    if (text.isEmpty) {
      if (closeOnEmpty) {
        return filtered.clear();
      } else {
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
      onWillPop: () async {
        if (focusNode.hasFocus) {
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  hintText: hint,
                  suffixIcon: const Icon(Icons.search)),
            ),
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
                height: loading
                    ? 60
                    : ((filtered.firstOrNull?.subtitle != null ? 60 : 50) *
                            filtered.length)
                        .toDouble(),
                constraints: BoxConstraints(maxHeight: size.height / 3),
                child: loading
                    ? const Center(
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
        ),
      ),
    );
  }
}
