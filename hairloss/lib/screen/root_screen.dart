import 'package:flutter/material.dart';
import 'package:hairloss/component/main_calendar.dart';
import 'package:hairloss/component/schedule_card.dart';
import 'package:hairloss/component/today_banner.dart';
import 'package:hairloss/component/schedule_bottom_sheet.dart';
import 'package:hairloss/const/colors.dart';
import 'package:get_it/get_it.dart';
import 'package:hairloss/database/drift_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BottomNavi extends StatefulWidget {
  const BottomNavi({Key? key});

  @override
  State<BottomNavi> createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  XFile? _imageFile;
  int _selectedTabIndex = 0;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('반로썸'),
            backgroundColor: Colors.green,
          ),
          floatingActionButton: _selectedTabIndex == 3
              ? FloatingActionButton(
            backgroundColor: PRIMARY_COLOR,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isDismissible: true,
                builder: (_) => ScheduleBottomSheet(
                  selectedDate: selectedDate,
                ),
                isScrollControlled: true,
              );
            },
            child: Icon(
              Icons.add,
            ),
          )
              : null,
          body: TabBarView(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _imageFile != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 380,
                        height: 380,
                        color: Colors.grey[300],
                        child: Image.file(
                          File(_imageFile!.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Container(
                      width: 380,
                      height: 380,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '이미지를 업로드하세요.',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.lightGreen),
                      ),
                      child: Text('이미지 선택'),
                    ),
                  ],
                ),
              ),
              Center(
                child: Text("Info"),
              ),
              Center(
                child: Text("home"),
              ),
              SafeArea(
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return MainCalendar(
                        selectedData: selectedDate,
                        onDaySelected: onDaySelected,
                      );
                    } else if (index == 1) {
                      return StreamBuilder<List<Schedule>>(
                        stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                        builder: (context, snapshot) {
                          return TodayBanner(
                            selectedDate: selectedDate,
                            count: snapshot.data?.length ?? 0,
                          );
                        },
                      );
                    } else if (index == 2) {
                      return StreamBuilder<List<Schedule>>(
                        stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          return Column(
                            children: snapshot.data!.map((schedule) {
                              return Dismissible(
                                key: ObjectKey(schedule.id),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (DismissDirection direction) {
                                  GetIt.I<LocalDatabase>().removeSchedule(schedule.id);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                                  child: ScheduleCard(
                                    startTime: schedule.startTime,
                                    endTime: schedule.endTime,
                                    content: schedule.content,
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Center(
                child: Text("Soln"),
              ),
            ],
          ),
          extendBodyBehindAppBar: true,
          bottomNavigationBar: Container(
            color: Colors.white,
            child: Container(
              height: 70,
              padding: EdgeInsets.only(bottom: 10, top: 5),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.greenAccent,
                indicatorWeight: 2,
                labelColor: Colors.greenAccent,
                unselectedLabelColor: Colors.black38,
                labelStyle: TextStyle(
                  fontSize: 13,
                ),
                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.search,
                    ),
                    text: 'Analysis',
                  ),
                  Tab(
                    icon: Icon(Icons.collections_bookmark),
                    text: 'Info',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    text: 'home',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.science,
                    ),
                    text: 'care',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.local_hospital,
                    ),
                    text: 'Soln',
                  ),
                ],
                onTap: (index) {
                  // 탭이 선택될 때 _selectedTabIndex 업데이트
                  setState(() {
                    _selectedTabIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}