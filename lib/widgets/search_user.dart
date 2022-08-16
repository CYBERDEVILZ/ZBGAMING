import 'package:flutter/material.dart';
import '../pages/show_user_account.dart';

class SearchPlayer extends StatefulWidget {
  const SearchPlayer({Key? key, required this.levelAttrib}) : super(key: key);
  final String levelAttrib;

  @override
  State<SearchPlayer> createState() => _SearchPlayerState();
}

class _SearchPlayerState extends State<SearchPlayer> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 1, top: 10),
      child: isClicked
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 20),
                  Expanded(
                      child: TextFormField(
                    cursorColor: colorCodeForCanvas[widget.levelAttrib]!,
                    style: TextStyle(color: colorCodeForCanvas[widget.levelAttrib]!),
                    decoration: InputDecoration(
                        focusColor: colorCodeForCanvas[widget.levelAttrib],
                        filled: true,
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: colorCodeForCanvas[widget.levelAttrib]!)),
                        disabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: colorCodeForCanvas[widget.levelAttrib]!)),
                        border:
                            OutlineInputBorder(borderSide: BorderSide(color: colorCodeForCanvas[widget.levelAttrib]!)),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: colorCodeForCanvas[widget.levelAttrib]!)),
                        prefixIcon: Icon(
                          Icons.search,
                          color: colorCodeForCanvas[widget.levelAttrib],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.cancel,
                            color: colorCodeForCanvas[widget.levelAttrib],
                          ),
                          onPressed: () {
                            isClicked = !isClicked;
                            setState(() {});
                          },
                        )),
                  )),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () async {},
                    child: Text(
                      "Go",
                      style: TextStyle(color: colorCodeForHeading[widget.levelAttrib]),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(colorCodeForCanvas[widget.levelAttrib]!)),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            )
          : IconButton(
              icon: Icon(
                Icons.search,
                size: 30,
                color: colorCodeForCanvas[widget.levelAttrib],
              ),
              onPressed: () {
                isClicked = !isClicked;
                setState(() {});
              },
            ),
    );
  }
}
