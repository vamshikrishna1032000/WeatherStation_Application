import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:path_provider/path_provider.dart'
    show getApplicationSupportDirectory;
import 'dart:async';
import 'package:flutter/material.dart';



// * Once the onboarding process is completed you will be taken to this screen
class HomeScreen extends StatefulWidget  {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _HomeScreenState();


  void initState(){

  }


}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{
  String temperature = "Loading...";
  String humidity = "Loading...";
  double cent = 0.0;
  bool switchSelected = false;
  int centigrade = 0;
  int counter = 0;
  final String atSignPico = "@distinctiveblue";
  final String key = "temperature";
  AtClientManager atClientManager = AtClientManager.getInstance();
  Timer? timer;
  late AnimationController controller;

  void getWeather() async {
    final AtClient atClient = atClientManager.atClient;
    final AtKey atKey = AtKey.public(
        key, namespace: "group5", sharedBy: atSignPico).build();

    GetRequestOptions options = GetRequestOptions();
    options.bypassCache = true;
    AtValue atValue = await atClient.get(atKey, getRequestOptions: options);
    final String value = atValue.value;

    setState(() {
      temperature = value.split(",")[0];
      humidity = value.split(",")[1];
    });
    cent = (double.parse(temperature) - 32)*5/9;
    centigrade = cent.round();
  }

  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..addListener(() {
      setState(() {});
    });
    controller.repeat();

    // controller.repeat(reverse: true);

    timer = Timer.periodic(Duration(seconds: 2), (Timer t) {
      getWeather();
      // setState((){
      //   counter++;
      // });
    });
    controller.repeat();




  }
  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    // * Getting the AtClientManager instance to use below





    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather🌧'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // ElevatedButton(
                //   onPressed: getWeather,
                //   child: const Text("Get weather!"),
                // ),
                // Text('timer $counter'),
                Text('Show temperature in Centigrade:',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Switch(
                  value: switchSelected,
                  onChanged:(value){
                    setState(() {
                      switchSelected=value;
                    });
                  },
                ),
                Text(''),
                if (switchSelected == true)
                  Text('Temperature in Centigrade: $centigrade ℃',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                if (switchSelected == false)
                  Text('Temperature in Fahrenheit: $temperature ℉',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                Text('Humidity: $humidity %',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                LinearProgressIndicator(
                  value: controller.value,
                  semanticsLabel: 'Linear progress indicator',
                ),
                Text('Tips: '),
                if (centigrade > 35)
                  Text('Be careful of heatstroke!🔥🥵‍🔥'),
                if (26 <= centigrade && centigrade <= 35)
                  Text('Dress cooler!🎽'),
                if (16 <= centigrade && centigrade <= 25)
                  Text('T-shirt and trousers are good!👕👚'),
                if (0 <= centigrade && centigrade <= 15)
                  Text('Had better take your coat!🧥'),
                if (0 > centigrade)
                  Text('Wear the more the better! Unless you are a polar bear!❄🐻‍❄'),
              ]
          )



      ),
    );
  }
}
