import 'package:buckettodoapp/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../authentication/authentication.dart';
import '../constants/custom_color.dart';
import '../firebase_storage/firebase_Storage.dart';
import '../provider/provider_theme.dart';
import '../widgets/textstyles.dart';

List<String> dynamicAddTasks = [];

class TodoBucketHomepage extends StatefulWidget {
  User user;
  static const String todoHomepage = "TodoBucketHomepage";
  TodoBucketHomepage({super.key, required this.user});

  @override
  State<TodoBucketHomepage> createState() => _TodoBucketHomepageState();
}

class _TodoBucketHomepageState extends State<TodoBucketHomepage> {
  /// addmytasks
  final addmytasksController = TextEditingController();
  String documentReferenceId = "";
  String getsnapshotId = "";
  DateTime? fetchedTime;
  bool orderByDate = false;
  bool completedTasks = false;

  List<String> defaultList = [
    "My Tasks",
  ];
  var connectivityStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    checkConnectivity();
    // Subscribe to changes in connectivity status
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        connectivityStatus = result.toString();
      });
    });
    _refreshData();
  }

  @override
  void dispose() {
    addmytasksController.dispose();
    super.dispose();
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        connectivityStatus = 'No Internet connection';
      });
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        connectivityStatus = 'Connected';
      });
    }
  }

  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SplashScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  //// datetime format
  String formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String day = DateFormat('d').format(dateTime);
    String month = DateFormat('MMMM').format(dateTime);
    String year = DateFormat('y').format(dateTime);
    String suffix = _getDaySuffix(int.parse(day));
    String time = DateFormat('h:mm a').format(dateTime);

    return '$day$suffix $month $year at $time';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String? userId = "";

  Future _refreshData() async {
    // Perform any asynchronous operation to fetch new data
    await FirebaseFirestore.instance
        .collection(widget.user.email ?? "")
        .doc(widget.user.uid)
        .collection(collectionName)
        .orderBy(orderByDate ? 'dateCreated' : 'todoName',
            descending: orderByDate ? false : true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: defaultList.length,
      child: Scaffold(
        appBar: AppBar(

            // backgroundColor: darkTheme
            //     ? AppColors.backgroundColor
            //     : AppColors.whiteColor,
            title: Text(
              'Bucket',
              style: TextStyle(
                  color: Provider.of<ThemeNotifier>(context).getTheme() ==
                          lightTheme
                      ? AppColors.backgroundColor
                      : AppColors.whiteColor,
                  fontWeight: Provider.of<ThemeNotifier>(context).getTheme() ==
                          lightTheme
                      ? FontWeight.w700
                      : FontWeight.w700,
                  fontSize: 22),
            ),
            centerTitle: true,
            // pinned: true,
            // floating: true,
            leading: Switch(
              value:
                  Provider.of<ThemeNotifier>(context).getTheme() != lightTheme,
              onChanged: (value) {
                Provider.of<ThemeNotifier>(context, listen: false)
                    .toggleTheme();
              },
            ),
            bottom: TabBar(
                indicatorColor:
                    Provider.of<ThemeNotifier>(context).getTheme() == lightTheme
                        ? AppColors.backgroundColor
                        : AppColors.whiteColor,
                indicatorWeight: 3.0,
                isScrollable: true,
                // labelStyle: TextStyle(
                //     color: AppColors.whiteColor, fontSize: 20.0),
                //    labelColor: AppColors.whiteColor,
                indicatorSize: TabBarIndicatorSize.tab,
                tabAlignment: TabAlignment.start,
                // unselectedLabelStyle: TextStyle(
                //     color: AppColors.whiteColor, fontSize: 20.0),
                tabs: List.generate(
                  defaultList.length,
                  (index) => Tab(
                      icon: Text(
                    defaultList[index],
                    style: TextStyle(
                        color: Provider.of<ThemeNotifier>(context).getTheme() ==
                                lightTheme
                            ? AppColors.backgroundColor
                            : AppColors.whiteColor,
                        fontWeight:
                            Provider.of<ThemeNotifier>(context).getTheme() ==
                                    lightTheme
                                ? FontWeight.w500
                                : FontWeight.w500,
                        fontSize: 20),
                  )),
                )),
            actions: [
              widget.user.photoURL != null
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.backgroundColor),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.network(
                            widget.user.photoURL!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.backgroundColor),
                        child: const ClipOval(
                          child: Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await Authentication.signOut(context: context);
                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context)
                        .pushReplacement(_routeToSignInScreen());
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, left: 10),
                    child: const Icon(
                      Icons.logout,
                      size: 30,
                    ),
                  ))
            ]),
        body: TabBarView(
            children: List.generate(
          defaultList.length,
          (index) => RefreshIndicator(
            backgroundColor: Colors.white,
            color: Colors.black,
            strokeWidth: 3,
            triggerMode: RefreshIndicatorTriggerMode.onEdge,
            onRefresh: _refreshData,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(widget.user.email ?? "")
                    .doc(widget.user.uid)
                    .collection(collectionName)
                    .orderBy(orderByDate ? 'dateCreated' : 'todoName',
                        descending: orderByDate ? false : true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 43),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "No Tasks yet !",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Provider.of<ThemeNotifier>(context)
                                            .getTheme() ==
                                        lightTheme
                                    ? AppColors.backgroundColor
                                    : AppColors.whiteColor,
                                fontWeight: Provider.of<ThemeNotifier>(context)
                                            .getTheme() ==
                                        lightTheme
                                    ? FontWeight.w700
                                    : FontWeight.w700,
                                fontSize: 18),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 22.0),
                            child: Text(
                              "Add your to-dos and keep track of them!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Provider.of<ThemeNotifier>(context)
                                              .getTheme() ==
                                          lightTheme
                                      ? AppColors.backgroundColor
                                      : AppColors.whiteColor,
                                  fontWeight:
                                      Provider.of<ThemeNotifier>(context)
                                                  .getTheme() ==
                                              lightTheme
                                          ? FontWeight.w700
                                          : FontWeight.w700,
                                  fontSize: 18),
                            ),
                          )
                        ],
                      ),
                    );
                  }

                  // Here you can safely access snapshot.data!
                  final List<DocumentSnapshot> docs = snapshot.data!.docs;

                  List uncompletedTodos =
                      docs.where((todo) => todo['isCompleted']).toList();
                  List completedTodos = docs
                      .where((todo) => todo['isCompleted'] == true)
                      .toList();

                  return Padding(
                    padding: const EdgeInsets.only(top: 26.0),
                    child: ListView.builder(
                        itemCount: docs.length,
                        shrinkWrap: true,
                        reverse: true,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, elementindex) {
                          var getdata = docs[elementindex].data() as Map;
                          Timestamp timestamp = getdata['dateCreated'];
                          String formattedDateTime = formatDateTime(timestamp);

                          userId = snapshot.data!.docs[elementindex].id;

                          return ListTile(
                            // leading: Checkbox(
                            //   activeColor: AppColors.backgroundColor,
                            //   checkColor: AppColors.whiteColor,
                            //   shape: const CircleBorder(),
                            //   value: getdata["isCompleted"],
                            //   onChanged: (value) {
                            //     setState(() {
                            //       completedTasks = value!;
                            //     });
                            //     updateTask(
                            //         snapshot.data!.docs[elementindex].id,
                            //         completedTasks);
                            //   },
                            // ),
                            title: Text(
                              getdata['todoName'].toString().isNotEmpty
                                  ? getdata['todoName'].toString()
                                  : "",
                              // style: TextStyle(
                              //     color: AppColors.backgroundColor,
                              //     fontSize: 18.0,
                              //     fontWeight: FontWeight.w500),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                formattedDateTime ?? "",
                                // style: TextStyle(
                                //     fontWeight: FontWeight.w400,
                                //     color: AppColors.backgroundColor,
                                //     fontSize: 16.0),
                              ),
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                setState(() {
                                  deleteTasks(widget.user,
                                      snapshot.data!.docs[elementindex].id);
                                });

                                // Then show a snackbar.
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        backgroundColor:
                                            AppColors.backgroundColor,
                                        content: Text(
                                          '${getdata['todoName'].toString()} has been successfully deleted',
                                          style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontSize: 18.0),
                                        )));
                              },
                              child: const Icon(
                                Icons.delete,
                                size: 30.0,
                              ),
                            ),
                          );
                        }),
                  );
                }),
          ),
        )),
        bottomNavigationBar: BottomAppBar(
          color: Provider.of<ThemeNotifier>(context).getTheme() == lightTheme
              ? AppColors.whiteColor
              : AppColors.backgroundColor,
          height: 80,
          elevation: 8.0,
          notchMargin: 3.0,
          child: Container(
            margin: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(Icons.sort,
                            size: 30.0,
                            color: Provider.of<ThemeNotifier>(context)
                                        .getTheme() ==
                                    lightTheme
                                ? AppColors.backgroundColor
                                : AppColors.whiteColor),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return Container(
                                margin: const EdgeInsets.all(20.0),
                                height: 100,
                                width: MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20.0),
                                    topRight: Radius.circular(20.0),
                                  ),
                                ),
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 14.0),
                                      child: Text(
                                        'Sort By',
                                        style: TextStyle(
                                            color: AppColors.backgroundColor,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    ListTile(
                                      onTap: () async {
                                        setState(() {
                                          orderByDate = !orderByDate;
                                        });

                                        FirebaseFirestore.instance
                                            .collection(widget.user.email ?? "")
                                            .doc(widget.user.uid)
                                            .collection(collectionName)
                                            .orderBy(
                                                orderByDate
                                                    ? 'dateCreated'
                                                    : 'todoName',
                                                descending: false);
                                        Navigator.pop(context);
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      leading: Icon(Icons.done,
                                          color: orderByDate
                                              ? AppColors.backgroundColor
                                              : AppColors.whiteColor,
                                          size: 30.0),
                                      title: Text(
                                        'Date',
                                        style: TextStyle(
                                            color: AppColors.backgroundColor,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }),
                  ],
                ),
                FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          backgroundColor: Colors.white, // <-- SEE HERE
                          builder: (context) {
                            return SingleChildScrollView(
                              physics: NeverScrollableScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextField(
                                      controller: addmytasksController,
                                      autofocus: true,
                                      enableSuggestions: true,
                                      keyboardType: TextInputType.text,
                                      maxLength: null,
                                      style: Provider.of<ThemeNotifier>(context)
                                                  .getTheme() ==
                                              lightTheme
                                          ? TextStyle(
                                              color: AppColors.backgroundColor)
                                          : TextStyle(
                                              color: AppColors.backgroundColor),
                                      clipBehavior: Clip.antiAlias,
                                      textInputAction: TextInputAction.done,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(18.0),
                                          alignLabelWithHint: true,
                                          border: InputBorder.none,
                                          hintText: "New Tasks",
                                          hintStyle: TextStyle(
                                              color: AppColors.backgroundColor)
                                          //     ? TodoTextStyles().textStyles(
                                          //         false, true, true, 14.0, true)
                                          //     : TodoTextStyles().textStyles(
                                          //         false, true, true, 14.0, true),
                                          ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addmytasksController.text
                                                .toString()
                                                .isEmpty
                                            ? Container()
                                            : setState(() {
                                                addTasks(
                                                    widget.user,
                                                    addmytasksController.text
                                                        .toString(),
                                                    Timestamp.now(),
                                                    completedTasks);
                                              });
                                        addmytasksController.clear();
                                        Navigator.pop(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 20.0, bottom: 15.0),
                                          child: Text("Done",
                                              style: TodoTextStyles()
                                                  .textStyles(false, true, true,
                                                      14.0, false)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    backgroundColor:
                        Provider.of<ThemeNotifier>(context).getTheme() ==
                                lightTheme
                            ? AppColors.backgroundColor
                            : AppColors.whiteColor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      // You can adjust the borderRadius to change the shape
                    ),
                    child: Icon(
                      Icons.add,
                      size: 30.0,
                      color: Provider.of<ThemeNotifier>(context).getTheme() ==
                              lightTheme
                          ? AppColors.whiteColor
                          : AppColors.backgroundColor,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
