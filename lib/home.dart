// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/Model/apod.dart';
// import 'package:intl/intl.dart';
// import 'Helper/apodHepler.dart';
// import 'appTheme.dart';

// class HomePage extends StatefulWidget {
//   static const String route = '/';

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   ScrollController _scrollController;
//   double _scrollPosition = 0;
//   double _opacity = 0;
//   DateTime selectedDate = DateTime.now();
//   DateTime time = DateTime.now();
//   var customFormat = DateFormat('yyyy-MM-dd');
//   String dateText;
//   Future future;
//   APOD apod;
//   bool disposed = false;
//   String url;

//   @override
//   void initState() {
//     Timer(Duration(seconds: 1), () {
//       if (!disposed)
//         setState(() {
//           time = time.add(Duration(seconds: -1));
//         });
//     });
//     super.initState();
//     dateText = '${customFormat.format(DateTime.now())}';
//     url = "";
//     future = getAPOD();
//   }

//   @override
//   void dispose() {
//     disposed = true;
//     super.dispose();
//   }

//   Future<bool> getAPOD() async {
//     await APODHelper().getAPOD(dateText).then((data) async {
//       setState(() {
//         apod = data;
//         print(apod);
//         url = apod.url;
//       });
//     }).catchError((error) async {
//       // showSnackBar(error['message']);
//       print(error);

//       return true;
//     });
//   }

//   showPicker(BuildContext context) async {
//     final DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: selectedDate,
//         firstDate: DateTime(2018),
//         lastDate: DateTime.now());

//     if (picked != null && picked != selectedDate)
//       setState(() {
//         selectedDate = picked;
//         print(selectedDate.millisecondsSinceEpoch);
//         dateText = '${customFormat.format(selectedDate)}';
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var screenSize = MediaQuery.of(context).size;
//     _opacity = _scrollPosition < screenSize.height * 0.40
//         ? _scrollPosition / (screenSize.height * 0.40)
//         : 1;

//     return Scaffold(
//       body: FutureBuilder(
//         future: future,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState != ConnectionState.waiting) {
//             return SingleChildScrollView(
//                 controller: _scrollController,
//                 physics: ClampingScrollPhysics(),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.only(left: 4, right: 4),
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16)),
//                         child: Container(
//                           height: MediaQuery.of(context).size.width / 1.5,
//                           width: MediaQuery.of(context).size.width / 2,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[900],
//                             borderRadius: BorderRadius.circular(16),
//                             image: DecorationImage(
//                               image: (NetworkImage(apod.url)),
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           // child : Image.network(apod.url)
//                         ),
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width / 3,
//                               padding: const EdgeInsets.all(16.0),
//                               child: Text(
//                                 apod.title,
//                                 style: TextStyle(
//                                     fontFamily: "Montserrat",
//                                     color: Colors.black,
//                                     fontSize: 200,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   GestureDetector(
//                                       onTap: () async {
//                                         await showPicker(context);
//                                       },
//                                       child: Container(
//                                         decoration: new BoxDecoration(
//                                             color: Colors.white,
//                                             border: new Border.all(
//                                               color: appTheme.primaryColor,
//                                               width: 2.0,
//                                             ),
//                                             borderRadius:
//                                                 new BorderRadius.circular(
//                                                     15.0)),
//                                         child: Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Container(
//                                                 width: 100,
//                                                 child: Padding(
//                                                   padding: EdgeInsets.only(
//                                                       left: 16.0, top: 12.0),
//                                                   child: GestureDetector(
//                                                       onTap: () async {
//                                                         await showPicker(
//                                                             context);
//                                                       },
//                                                       child: Text(
//                                                         dateText,
//                                                         style: TextStyle(
//                                                             fontFamily:
//                                                                 "Montserrat",
//                                                             fontSize: 14,
//                                                             color:
//                                                                 Colors.black),
//                                                       )),
//                                                 )),
//                                             Container(
//                                               width: 40.0,
//                                               height: 40.0,
//                                               decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12.0),
//                                                 color: Colors.white,
//                                               ),
//                                               child: GestureDetector(
//                                                   onTap: () async {
//                                                     await showPicker(context);
//                                                   },
//                                                   child: Icon(
//                                                     Icons.event,
//                                                     size: 25,
//                                                     color:
//                                                         appTheme.primaryColor,
//                                                   )),
//                                             )
//                                             //												)
//                                           ],
//                                         ),
//                                       )),
//                                   Container(
//                                     padding: EdgeInsets.only(
//                                         top: 16, bottom: 0, left: 8, right: 40),
//                                     child: ElevatedButton(
//                                       style: ElevatedButton.styleFrom(
//                                         primary: appTheme
//                                             .primaryColorDark, // background
//                                         onPrimary: appTheme.primaryColorDark,
//                                         // foreground
//                                       ),
//                                       // color: appTheme.primaryColorDark,
//                                       onPressed: () {
//                                         future = getAPOD();
//                                       },
//                                       child: Text("FIND",
//                                           style: TextStyle(
//                                               fontFamily: "Montserrat",
//                                               color: Colors.white,
//                                               fontSize: 18.0)),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width / 3,
//                           padding: EdgeInsets.all(16),
//                           child: Text(
//                             apod.explanation,
//                             style: TextStyle(
//                               fontFamily: "Montserrat",
//                               color: Colors.black,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                         Container(
//                           padding: EdgeInsets.only(top: 8, left: 16),
//                           child: Text(
//                             "Service Version : " + apod.serviceVersion,
//                             style: TextStyle(
//                                 fontFamily: "Montserrat",
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Container(
//                           padding:
//                               EdgeInsets.only(top: 8, left: 16, bottom: 32),
//                           child: Text(
//                             "Media Type : " + apod.mediaType,
//                             style: TextStyle(
//                                 fontFamily: "Montserrat",
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         )
//                       ],
//                     )
//                   ],
//                 ));
//           }
//           return Container(
//             child: Center(
//               child: CircularProgressIndicator(
//                 color: appTheme.accentColor,
//                 backgroundColor: appTheme.primaryColor,
//                 strokeWidth: 3,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Model/apod.dart';
import 'package:intl/intl.dart';
import 'Helper/apodHepler.dart';
import 'appTheme.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;
  DateTime selectedDate = DateTime.now();
  DateTime time = DateTime.now();
  var customFormat = DateFormat('yyyy-MM-dd');
  String dateText;
  Future future;
  APOD apod;
  bool disposed = false;
  bool hd = true;

  @override
  void initState() {
    Timer(Duration(seconds: 1), () {
      if (!disposed)
        setState(() {
          time = time.add(Duration(seconds: -1));
        });
    });
    super.initState();
    dateText = '${customFormat.format(DateTime.now())}';
    future = getAPOD();
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }

  Future<bool> getAPOD() async {
    await APODHelper().getAPOD(dateText).then((data) async {
      setState(() {
        apod = data;
        print(apod);
      });
      //  apod.url = await ImageDownloader.downloadImage(data.url);
      //  setState(() {
      //     print("*************************");
      //   print(apod.url);
      //  });
    }).catchError((error) async {
      // showSnackBar(error['message']);
      print(error);

      return true;
    });
  }

  showPicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2018),
        lastDate: DateTime.now());

    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print(selectedDate.millisecondsSinceEpoch);
        dateText = '${customFormat.format(selectedDate)}';
      });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.waiting) {
            return SingleChildScrollView(
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return LinearGradient(
                              begin: Alignment(0.0, 0.4),
                              end: Alignment(0.0, 1.0),
                              colors: [
                                Colors.transparent,
                                Colors.white.withOpacity(0.2)
                              ],
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.srcATop,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Container(
                                height: 600,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(16),
                                  image: DecorationImage(
                                    image: (NetworkImage(hd ? apod.hdurl : apod.url)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                // child : Image.network(apod.url)
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 16.0,
                            right: 20.0,
                            child: GestureDetector(
                                onTap: () async {
                                  await showPicker(context);
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                      color: Colors.white,
                                      border: new Border.all(
                                        color: appTheme.primaryColor,
                                        width: 2.0,
                                      ),
                                      borderRadius:
                                          new BorderRadius.circular(15.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: 100,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 16.0, top: 12.0),
                                            child: GestureDetector(
                                                onTap: () async {
                                                  await showPicker(context);
                                                },
                                                child: Text(
                                                  dateText,
                                                  style: TextStyle(
                                                      fontFamily: "Montserrat",
                                                      fontSize: 14,
                                                      color: Colors.black),
                                                )),
                                          )),
                                      Container(
                                        width: 40.0,
                                        height: 40.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          color: Colors.white,
                                        ),
                                        child: GestureDetector(
                                            onTap: () async {
                                              await showPicker(context);
                                            },
                                            child: Icon(
                                              Icons.event,
                                              size: 25,
                                              color: appTheme.primaryColor,
                                            )),
                                      )
                                      //												)
                                    ],
                                  ),
                                ))),
                        Positioned(
                          top: 55,
                          right: 50,
                          child: Container(
                            padding: EdgeInsets.only(
                                top: 16, bottom: 0, left: 8, right: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary:
                                    appTheme.primaryColorDark, // background
                                onPrimary: appTheme.primaryColorDark,
                                // foreground
                              ),
                              // color: appTheme.primaryColorDark,
                              onPressed: () {
                                future = getAPOD();
                              },
                              child: Text("FIND",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.white,
                                      fontSize: 18.0)),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 100,
                            right: 25,
                            child: Row(
                              children: [
                                Text(
                                  "HD : ",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  value: hd,
                                  onChanged: (value) {
                                    setState(() {
                                      hd = value;
                                      print(hd);
                                    });
                                  },
                                  activeTrackColor: Colors.blueGrey[200],
                                  activeColor: appTheme.primaryColor,
                                ),
                              ],
                            )),
                        Positioned(
                            bottom: 16,
                            left: 32,
                            child: Text(
                              apod.title,
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Colors.white,
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold),
                            )),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        apod.explanation,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8, left: 16),
                      child: Text(
                        "Service Version : " + apod.serviceVersion,
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8, left: 16, bottom: 32),
                      child: Text(
                        "Media Type : " + apod.mediaType,
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ));
          }
          return Container(
            child: Center(
              child: CircularProgressIndicator(
                color: appTheme.accentColor,
                backgroundColor: appTheme.primaryColor,
                strokeWidth: 3,
              ),
            ),
          );
        },
      ),
    );
  }
}
