import 'package:flutter/material.dart';
import 'package:twain/constants.dart';
import 'package:twain/story.dart';
import 'package:loading_animations/loading_animations.dart';
import 'login_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StoryScreen extends StatefulWidget {
  final String username, password;
  StoryScreen(this.username, this.password);
  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  int selectedDestination = 0;
  late var node;
  Stream<int> swipe = Stream.value(0);
  late Story a;
  late String message;
  bool load = true;

  Future<void> initS() async {
    a = new Story(widget.username, widget.password);
    await a.constructTree();
    node = a.root;
    message = node.question;
    setState(() {});
  }

  void progress(int treeId) async {
    Map data = {"treeId": treeId};
    var auth = 'Basic ' +
        base64Encode(utf8.encode('${widget.username}:${widget.password}'));
    await http.post(Uri.http(url, 'api/createprogress'),
        headers: {"Content-Type": "application/json", 'authorization': auth},
        body: jsonEncode(data));
  }

  @override
  void initState() {
    super.initState();
    initS().whenComplete(() {
      setState(() {
        load = false;
      });
    });
  }

  ScrollController _effect = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  double pos = 0;
  final pageCntrler = PageController();

  _scrollDown() async {
    await pageCntrler.nextPage(
      duration: Duration(milliseconds: 314),
      curve: Curves.easeOutCubic,
    );
  }

  _scrollUp() async {
    await pageCntrler.previousPage(
      duration: Duration(milliseconds: 314),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kPowder,
        appBar: AppBar(
          backgroundColor: kCream,
          //It could be anything really, I could only think of Chapter 1 or choices that lead to this story.
          title: Text(
            'Twain',
            style:
                Theme.of(context).textTheme.headline6?.copyWith(color: kMatte),
          ),
        ),
        drawer: SafeArea(
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Twain',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle_sharp,
                    color: Colors.black,
                  ),
                  title: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Profile Bar is pressed'),
                      duration: const Duration(milliseconds: 1200),
                    ));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.not_started),
                  title: Text('New Game'),
                  onTap: () {
                    progress(1);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              StoryScreen(widget.username, widget.password)),
                      (route) => false,
                    );
                  },
                ),
                ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log Out'),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false,
                      );
                    }),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                ),
                ListTile(
                  leading: Icon(Icons.contact_support),
                  title: Text('About-Us'),
                  onTap: () {
                    aboutUs();
                  },
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: load
              ? Center(
                  child: LoadingBumpingLine.circle(
                    backgroundColor: kCastelon,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: new PageView(
                    controller: pageCntrler,
                    scrollDirection: Axis.vertical,
                    children: [
                      NotificationListener(
                        onNotification: (notification) {
                          if (notification is OverscrollNotification) {
                            if (notification.overscroll > 0) {
                              pos = _effect.offset;
                              _scrollDown();
                            } else {
                              _scrollUp();
                            }
                          }
                          return true;
                        },
                        child: Scrollbar(
                          radius: Radius.circular(4.0),
                          thickness: 8.0,
                          controller: _effect,
                          child: SingleChildScrollView(
                            controller: _effect,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  right: 24.0, bottom: 400),
                              child: Text(
                                node.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(color: kMatte),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Draggable(
                          axis: Axis.horizontal,
                          onDragEnd: (value) {
                            //switch page

                            if (message == "Start Again?") {
                              progress(1);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StoryScreen(
                                          widget.username, widget.password)));
                            } else if (node.left != null &&
                                message == node.left.value &&
                                ((value.offset.dx <
                                        -(MediaQuery.of(context).size.width /
                                            3.25)) ||
                                    (value.offset.dx >
                                        (MediaQuery.of(context).size.width /
                                            2.25)))) {
                              node = node.left;
                              progress(node.id);
                              _scrollUp();
                            } else if (node.right != null &&
                                message == node.right.value &&
                                ((value.offset.dx <
                                        -(MediaQuery.of(context).size.width /
                                            3.25)) ||
                                    (value.offset.dx >
                                        (MediaQuery.of(context).size.width /
                                            2.25)))) {
                              node = node.right;
                              progress(node.id);
                              _scrollUp();
                            }
                            setState(() {});
                          },
                          onDragUpdate: (value) {
                            if (message == "Start Again?") {
                            } else if (node.left != null &&
                                value.delta.dx < 0 &&
                                message != node.right.value) {
                              progress(1);
                              message = node.left.value;
                              swipe = Stream.value(1);
                            } else if (node.right != null &&
                                value.delta.dx > 0 &&
                                message != node.left.value) {
                              message = node.right.value;
                              swipe = Stream.value(2);
                            }
                            setState(() {});
                          },
                          onDraggableCanceled: (velocity, offset) {
                            setState(() {
                              message = node.question;
                            });
                          },
                          childWhenDragging: Container(),
                          feedback: StreamBuilder(
                              stream: swipe,
                              initialData: 0,
                              builder: (BuildContext context,
                                  AsyncSnapshot<int> snapshot) {
                                return Container(
                                  width: MediaQuery.of(context).size.width - 64,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: Card(
                                    color: kCamblue,
                                    elevation: 0,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(32.0),
                                        child: Text(
                                          message,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5
                                              ?.copyWith(color: kMatte),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 64,
                            height: MediaQuery.of(context).size.height / 2,
                            child: Card(
                              color: kOpal,
                              elevation: 0,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: Text(
                                    message,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(color: kMatte),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void selectDestination(int index) {
    setState(() {
      selectedDestination = index;
    });
  }

  Future<void> aboutUs() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Us'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Hey we are a bunch of students'),
                Text('who do such projects for fun'),
                SizedBox(height: 15),
                Text('If you have any suggestions'),
                Text('You can reach us at'),
                SizedBox(height: 10),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.phone),
                      SizedBox(width: 13),
                      Text('+91-1234567890'),
                    ],
                  ),
                  onTap: () {},
                ),
                SizedBox(height: 6),
                InkWell(
                  child: Row(
                    children: [
                      Icon(Icons.mail),
                      SizedBox(width: 13),
                      Text('abc@mail.com'),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              style: TextButton.styleFrom(
                primary: kCastelon,
                textStyle: Theme.of(context).textTheme.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
