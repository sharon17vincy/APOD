import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/appTheme.dart';
import 'package:flutter_application_1/home.dart';



class SplashScreen extends StatefulWidget
{
	@override
	State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen>
{
	var _scaffoldKey = GlobalKey<ScaffoldState>();

	@override
	Widget build(BuildContext context)
	{
		return initScreen(context);
    
	}
	
	
	@override
	void initState()
	{
		super.initState();
    new Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    });

	}


	void showSnackbar(message)
	{
		_scaffoldKey.currentState.showSnackBar(SnackBar(
			content: Text(message.toString()),
			action: SnackBarAction(
				label: 'Dismiss',
				onPressed: () {
					Scaffold.of(context).hideCurrentSnackBar();
				},
			),
		));
	}
	
	initScreen(BuildContext context)
	{
		return Scaffold(
			backgroundColor: Colors.white,
			key: _scaffoldKey,
			body: Center(
				child: Column(
					mainAxisAlignment: MainAxisAlignment.center,
					mainAxisSize: MainAxisSize.max,

					children: <Widget>[
            	Container(
							child:Text("Welcome!" + "\n", style: TextStyle(fontFamily: "Montserrat",fontWeight :FontWeight.bold,fontSize : 32, color: appTheme.primaryColorDark),),
						),
						Container(
							child:Text(" Astrology Picture Of the Day (APOD)", style: TextStyle(fontFamily: "Montserrat",fontWeight :FontWeight.bold,fontSize : 24, color: appTheme.primaryColorDark),),
						),
						Padding(padding: EdgeInsets.only(top: 40.0)),
						CircularProgressIndicator(
              color: appTheme.accentColor,
							backgroundColor: Colors.white,
							strokeWidth: 3,
						),
					],
				),
			),

		);
	}


}