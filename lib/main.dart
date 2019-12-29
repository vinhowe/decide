import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:uuid/uuid.dart';
import 'decision_option.dart';

void main() => runApp(Decide());

class Decide extends StatelessWidget {
  static const String title = 'decide';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Decide',
      theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.black,
          backgroundColor: Colors.black,
          canvasColor: Colors.black,
          accentColor: Colors.yellowAccent,
          brightness: Brightness.dark,
          cursorColor: Colors.yellowAccent,
          textSelectionColor: Colors.yellowAccent.withOpacity(0.5),
          textSelectionHandleColor: Colors.yellowAccent,
          textTheme: GoogleFonts.latoTextTheme(
            ThemeData.dark().textTheme,
          ),
          appBarTheme: AppBarTheme(
            elevation: 0,
          )),
      home: DecidePage(),
    );
  }
}

class DecidePage extends StatefulWidget {
  DecidePage({Key key}) : super(key: key);

  final uuid = Uuid();

  @override
  _DecidePageState createState() => _DecidePageState();
}

class _DecidePageState extends State<DecidePage> {
  List<_DecisionOptionListItem> decisionOptionsListItems = [];

//  TODO: add storage to allow state to be saved
//  TODO: make 'decide' into a constant
//  final LocalStorage storage = new LocalStorage('decide');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      bottomNavigationBar: BottomAppBar(
//        child: SizedBox(
//            height: kToolbarHeight,
//            child: AppBar(
//              title: Text(Decide.title),
//            )),
//        elevation: 0,
//      ),
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: <Widget>[
          ReorderableListView(
            onReorder: _onReorder,
            reverse: true,
            children:
                decisionOptionsListItems.map(_mapDecisionOptionWidget).toList(),
            padding: EdgeInsets.only(bottom: 112),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0).add(EdgeInsets.only(bottom: 16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.help),
                    onPressed: _showHelp,
                  ),
                  Spacer(),
                  MaterialButton(
                    child: Text(
                      'decide',
                      style: Theme.of(context)
                          .textTheme
                          .body1
                          .copyWith(fontSize: 18, color: Colors.black),
                    ),
                    height: 56,
                    color: Colors.yellowAccent,
                    textColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    onPressed: _decide,
                    shape: StadiumBorder(),
                  ),
                  SizedBox(width: 12),
                  FloatingActionButton(child: Icon(Icons.add), onPressed: _addDecisionOption)
                ],
              ),
            ),
          )
        ],
      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: _addDecisionOption,
//        tooltip: 'Increment',
//        child: Icon(Icons.add, size: 32),
//      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      // This needs to be done because newIndex (when newIndex > oldIndex) will
      // reference an incorrect index when the item at oldIndex is removed
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = decisionOptionsListItems.removeAt(oldIndex);
      decisionOptionsListItems.insert(newIndex, item);
    });

    assert(_debugClearFocus());
  }

  Widget _mapDecisionOptionWidget(
      _DecisionOptionListItem decisionOptionListItem) {
    TextEditingController textEditingController =
        decisionOptionListItem.textEditingController;

    return DecisionOptionListTile(
      textEditingController: textEditingController,
      key: Key(decisionOptionListItem.decisionOption.id),
      focusNode: decisionOptionListItem.focusNode,
      onDeleted: () =>
          _removeDecisionOption(decisionOptionListItem.decisionOption.id),
      onChanged: (decisionOption) => _onOptionDescriptionChanged(
          decisionOptionListItem.decisionOption,
          textEditingController,
          decisionOption.description),
    );
  }

  void _onOptionDescriptionChanged(DecisionOption decisionOption,
      TextEditingController controller, String text) {
    // Faster than comparing the whole object
    int editIndex = decisionOptionsListItems.indexWhere(
        (_DecisionOptionListItem optionListItem) =>
            optionListItem.decisionOption.id == decisionOption.id);

    DecisionOption updated =
        decisionOption.rebuild((b) => b..description = controller.text);

    setState(() {
      decisionOptionsListItems[editIndex].textEditingController = controller;
      decisionOptionsListItems[editIndex].decisionOption = updated;
    });
  }

  void _addDecisionOption() {
    FocusNode newDecisionOptionFocusNode = FocusNode();

    setState(() {
      decisionOptionsListItems.add(_DecisionOptionListItem(
          DecisionOption((DecisionOptionBuilder b) => b
            ..description = widget.uuid.v4()
            ..id = widget.uuid.v4()),
          GlobalKey(),
          newDecisionOptionFocusNode,
          TextEditingController()));
    });

    // Needs to be delayed in order to show keyboard when requested
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(newDecisionOptionFocusNode));
  }

  void _decide() {
    if (decisionOptionsListItems.length <= 1) {
      return;
    }

    _DecisionOptionListItem winner = decisionOptionsListItems.removeAt(0);

    for (_DecisionOptionListItem item in decisionOptionsListItems) {
      item.dispose();
    }

    setState(() {
      decisionOptionsListItems = [winner];
    });
  }

  void _showHelp() {
    // TODO: STUB for _showHelp
    print("STUB! No help");
  }

  bool _debugClearFocus() {
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(FocusNode()));
    return true;
  }

  void _removeDecisionOption(String id) {
    _DecisionOptionListItem toRemove = decisionOptionsListItems
        .firstWhere((item) => item.decisionOption.id == id, orElse: () => null);

    if (toRemove == null) {
      return;
    }

    assert(_debugClearFocus());

    setState(() {
      decisionOptionsListItems.remove(toRemove);
    });

    toRemove.dispose();
  }

  @override
  void dispose() {
    for (_DecisionOptionListItem listItem in decisionOptionsListItems) {
      listItem.dispose();
    }
    super.dispose();
  }
}

class _DecisionOptionListItem {
  DecisionOption decisionOption;
  GlobalKey textKey;
  TextEditingController textEditingController;
  FocusNode focusNode;

  _DecisionOptionListItem(this.decisionOption, this.textKey, this.focusNode,
      this.textEditingController);

  void dispose() {
    textEditingController.clear();
    textEditingController.dispose();
    focusNode.dispose();
  }
}

class DecisionOptionListTile extends StatelessWidget {
  final DecisionOption decisionOption;

  final ValueChanged<DecisionOption> onChanged;
  final VoidCallback onDeleted;
  final TextEditingController textEditingController;

  final GlobalKey textKey;
  final FocusNode focusNode;

  DecisionOptionListTile(
      {Key key,
      this.decisionOption,
      this.onChanged,
      this.onDeleted,
      this.focusNode,
      this.textEditingController,
      this.textKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        decoration:
            InputDecoration(border: UnderlineInputBorder(), filled: true),
        controller: textEditingController,
        focusNode: this.focusNode,
        onChanged: (value) =>
            onChanged(decisionOption.rebuild((b) => b..description = value)),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: InkResponse(
                onTap: onDeleted,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                )),
          ),
          Icon(Icons.drag_handle)
        ],
      ),
    );
  }
}
