import 'package:LiveChatFrontend/models/sections.dart';
import 'package:LiveChatFrontend/providers/socket_provider.dart';
import 'package:LiveChatFrontend/widgets/chats_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({
    Key key,
    @required this.screenSize,
  }) : super(key: key);

  final Size screenSize;

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentSection = 0;

  @override
  void initState() { 
    super.initState();
    Provider.of<SocketProvider>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 10.0, right: 10.0),
          height: widget.screenSize.height * .1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSection("Messages", 0, context),
              buildSection("Groups", 1, context),
              DropdownButton<String>(
                elevation: 0,
                hint: Text(
                  "Sections",
                  style: TextStyle(color: Colors.white),
                ),
                items: Sections.sections
                    .map(
                      (section) => DropdownMenuItem<String>(
                        value: section,
                        child: Row(
                          children: [
                            Text(section),
                            if (_currentSection == Sections.getIndex(section))
                              CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,
                                radius: 6.0,
                              ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (section) => _pageController.animateToPage(
                  Sections.getIndex(section),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                ),
              ),
              Flexible(
                child: FlatButton(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text(
                      "Create\nSection",
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  color: Colors.white.withOpacity(0.4),
                  onPressed: () async {
                    final String section = await _showDialog();
                    if (section != null && section.isNotEmpty)
                      setState(() => Sections.addSection(section));
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
            color: Colors.white,
          ),
          height: widget.screenSize.height * .6,
          child: PageView(
            physics: ClampingScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentSection = page;
              });
            },
            children: [
              ChatsList(),
              Center(
                child: Text("Groups"),
              ),
              ...Sections.sections
                  .map(
                    (section) => Center(
                      child: Text(section),
                    ),
                  )
                  .toList(),
            ],
          ),
        ),
      ],
    );
  }

  Future<String> _showDialog() async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        final _controller = TextEditingController();
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'New Section',
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: const Text('SAVE'),
                onPressed: () {
                  Navigator.of(context).pop(_controller.text);
                })
          ],
        );
      },
    );
  }

  FlatButton buildSection(String section, int page, BuildContext context) {
    return FlatButton(
      onPressed: () => _pageController.animateToPage(
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      ),
      child: Row(
        children: [
          if (_currentSection == page)
            CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              radius: 6.0,
            ),
          SizedBox(width: 5.0),
          Text(
            section,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
