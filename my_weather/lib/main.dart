import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String apiKey =
      'f374fc264e09493612714f2f94164188'; // Replace with your own API key
  String city = ''; // Updated to allow user input

  String temperature = '';
  String description = '';
  String errorMessage = '';

  void fetchWeather() async {
    try {
      var url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var weatherData = jsonDecode(response.body);
        setState(() {
          temperature = weatherData['main']['temp'].toString();
          description = weatherData['weather'][0]['description'];
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch weather data';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to connect to the internet';
      });
    }
  }

  void updateCity(String input) {
    setState(() {
      city = input;
    });
  }

  Future<List<String>> getSuggestions(String pattern) async {
    // Implement the logic to fetch city suggestions based on the pattern.
    // You can use an API or a local data source to get the suggestions.
    // Return a list of suggestion strings.
    // For example, you can use a static list of cities:
    List<String> cities = ['New York', 'London', 'Paris', 'Tokyo', 'Kandy'];
    return cities
        .where((city) => city.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Weather App'),
        ),
        body: Container(
          color: Colors.lightBlue[100],
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                if (errorMessage.isEmpty)
                  Column(
                    children: [
                      Text(
                        'Temperature: $temperature°C',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Description: $description',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Text(
                  'Enter a city:',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TypeAheadField<String>(
                    textFieldConfiguration: TextFieldConfiguration(
                      autofocus: true,
                      onChanged: (value) {
                        updateCity(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'City name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      return await getSuggestions(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      setState(() {
                        city = suggestion;
                        fetchWeather();
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (city.isNotEmpty) {
                      fetchWeather();
                    }
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_typeahead/flutter_typeahead.dart';

// void main() => runApp(WeatherApp());

// class WeatherApp extends StatefulWidget {
//   @override
//   _WeatherAppState createState() => _WeatherAppState();
// }

// class _WeatherAppState extends State<WeatherApp> {
//   String apiKey =
//       'f374fc264e09493612714f2f94164188'; // Replace with your own API key
//   String city = ''; // Updated to allow user input

//   String temperature = '';
//   String description = '';
//   String errorMessage = '';

//   void fetchWeather() async {
//     try {
//       var url = Uri.parse(
//           'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
//       var response = await http.get(url);
//       if (response.statusCode == 200) {
//         var weatherData = jsonDecode(response.body);
//         setState(() {
//           temperature = weatherData['main']['temp'].toString();
//           description = weatherData['weather'][0]['description'];
//           errorMessage = '';
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to fetch weather data';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'Failed to connect to the internet';
//       });
//     }
//   }

//   void updateCity(String input) {
//     setState(() {
//       city = input;
//     });
//   }

//   Future<List<String>> getSuggestions(String pattern) async {
//     // Implement the logic to fetch city suggestions based on the pattern.
//     // You can use an API or a local data source to get the suggestions.
//     // Return a list of suggestion strings.
//     // For example, you can use a static list of cities:
//     List<String> cities = ['New York', 'London', 'Paris', 'Tokyo', 'Kandy'];
//     return cities
//         .where((city) => city.toLowerCase().contains(pattern.toLowerCase()))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Weather App',
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Weather App'),
//         ),
//         body: Container(
//           color: Colors.lightBlue[100],
//           padding: EdgeInsets.all(20),
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (errorMessage.isNotEmpty)
//                   Text(
//                     errorMessage,
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 if (errorMessage.isEmpty)
//                   Column(
//                     children: [
//                       Text(
//                         'Temperature: $temperature°C',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 10),
//                       Text(
//                         'Description: $description',
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 SizedBox(height: 20),
//                 Text(
//                   'Enter a city:',
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 10),
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 20),
//                   child: TypeAheadField<String>(
//                     textFieldConfiguration: TextFieldConfiguration(
//                       autofocus: true,
//                       onChanged: (value) {
//                         updateCity(value);
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'City name',
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                     suggestionsCallback: (pattern) async {
//                       return await getSuggestions(pattern);
//                     },
//                     itemBuilder: (context, suggestion) {
//                       return ListTile(
//                         title: Text(suggestion),
//                       );
//                     },
//                     onSuggestionSelected: (suggestion) {
//                       setState(() {
//                         city = suggestion;
//                         fetchWeather();
//                       });
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (city.isNotEmpty) {
//                       fetchWeather();
//                     }
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
