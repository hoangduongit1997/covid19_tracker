import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tgd_covid_tracker/datasorce.dart';
import 'package:tgd_covid_tracker/pages/countyPage.dart';
import 'package:tgd_covid_tracker/panels/infoPanel.dart';
import 'package:tgd_covid_tracker/panels/mosteffectedcountries.dart';
import 'package:tgd_covid_tracker/panels/worldwidepanel.dart';
import 'package:http/http.dart' as http;
import 'package:tgd_covid_tracker/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  Map worldData;
  fetchWorldWideData() async {
    http.Response response = await http.get('https://corona.lmao.ninja/v2/all');
    setState(() {
      worldData = json.decode(response.body);
    });
  }

  List countryData;
  fetchCountryData() async {
    http.Response response =
        await http.get('https://corona.lmao.ninja/v2/countries?sort=cases');
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  Future fetchData() async {
    await fetchWorldWideData();
    await fetchCountryData();
    setState(() {
      isLoading = false;
    });
    print('CALL API DONE');
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Covid-19 Tracker',
        ),
      ),
      body: (isLoading)
          ? ShimmerLoading()
          : RefreshIndicator(
              onRefresh: fetchData,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 100,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      color: Colors.orange[100],
                      child: Text(
                        DataSource.quote,
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Worldwide',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CountryPage(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryBlack,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                'Regional',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    worldData == null
                        ? Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom: 30.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : WorldwidePanel(
                            worldData: worldData,
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Most affected Countries',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),
                    countryData == null
                        ? Container()
                        : MostAffectedPanel(countryData: countryData),
                    InfoPanel(),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'WE ARE TOGETHER IN THE FIGHT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(height: 50)
                  ],
                ),
              ),
            ),
    );
  }
}
