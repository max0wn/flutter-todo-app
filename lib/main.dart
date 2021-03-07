import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:simple_animations/simple_animations.dart';

main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: DailyTasksPage(),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DailyTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Header(),
          Body(),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            'Daily Tasks',
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      padding: EdgeInsets.all(15.0),
    );
  }
}

class Day extends StatelessWidget {
  final int number;
  final String name;
  final bool active;

  final List<Color> colors = const [
    Color(0xff3400fe),
  ];

  const Day({this.name, this.number, this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(name,
              style: TextStyle(
                fontSize: 13.0,
                color: active ? Colors.white : colors[0],
              )),
          SizedBox(height: 5.0),
          Text(number.toString(),
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : Colors.black.withOpacity(0.7),
              )),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
      width: 55.0,
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        border: Border.all(color: colors[0]),
        color: active ? colors[0] : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.5)),
      ),
    );
  }
}

class Calendar extends StatefulWidget {
  final Function callback;

  final List<String> weekdays = const [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  const Calendar(this.callback);

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final List<Day> _days = [];

  int _index = 0;

  @override
  void initState() {
    super.initState();

    _refresh();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onClickDay(_index);
    });
  }

  void _refresh() {
    _days.clear();

    DateTime now = DateTime.now();

    for (var i = 0; i < 31; i++) {
      var duration = Duration(days: i);
      var datetime = now.add(duration);
      var day = Day(
        active: false,
        number: datetime.day,
        name: widget.weekdays[datetime.weekday - 1],
      );
      _days.add(day);
    }
  }

  void _onClickDay(int index) {
    setState(() {
      _days[_index] = Day(
        active: false,
        name: _days[_index].name,
        number: _days[_index].number,
      );
      _days[index] = Day(
        active: true,
        name: _days[index].name,
        number: _days[index].number,
      );
      _index = index;
      widget.callback(_days[index]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ScrollConfiguration(
        child: ListView.builder(
          itemCount: _days.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: _days[index],
              onTap: () {
                _onClickDay(index);
              },
            );
          },
          scrollDirection: Axis.horizontal,
        ),
        behavior: ScrollBehavior(),
      ),
      height: 60.0,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
    );
  }
}

class Task extends StatelessWidget {
  final Color color;
  final String title;
  final bool continued;
  final DateTime start;
  final DateTime finish;

  const Task({
    this.color,
    this.title,
    this.start,
    this.finish,
    this.continued,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: Text(
                  DateFormat('h a').format(start),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
                margin: EdgeInsets.only(left: 15.0, top: 5.0),
              ),
              Spacer(),
              Container(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 12.5,
                          height: 12.5,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                          ),
                        ),
                        SizedBox(width: 12.5),
                        Text(
                          DateFormat('h a').format(start) +
                              ' — ' +
                              DateFormat('h a').format(finish),
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.5),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.02),
                  border: Border.all(
                    color: color,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.5)),
                ),
                width: 320.0,
                height: 150.0,
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.only(left: 15, top: 12.5),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          if (continued)
            Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Container(
                          child: Text(
                            DateFormat('h a').format(
                              DateTime(
                                finish.year,
                                finish.month,
                                finish.day,
                                finish.hour - 1,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 15.0),
                        ),
                        Spacer(),
                        Container(
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10.0,
                                height: 10.0,
                                child: CustomPaint(painter: CirclePainter()),
                              ),
                              Expanded(
                                child: Container(
                                  height: 2.0,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                child: Text(
                                  'BREAK',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                              Expanded(
                                child: Container(
                                  height: 2.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          width: 335.0,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Spacer(),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 12.5,
                                  height: 12.5,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                  ),
                                ),
                                SizedBox(width: 12.5),
                                Text(
                                  'CONTINUED',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                              ],
                            ),
                            SizedBox(height: 7.5),
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.02),
                          border: Border.all(
                            color: color,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.5)),
                        ),
                        width: 320.0,
                        height: 120.0,
                        margin: EdgeInsets.only(right: 15),
                        padding: EdgeInsets.only(left: 15, top: 12.5),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ],
              ),
            ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 15.0),
    );
  }
}

class UpcomingTasks extends StatelessWidget {
  final List<Task> tasks;

  const UpcomingTasks({this.tasks});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ScrollConfiguration(
        child: FadeAnimation(
          1,
          ListView.builder(
            shrinkWrap: true,
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return tasks[index];
            },
            scrollDirection: Axis.vertical,
          ),
        ),
        behavior: ScrollBehavior(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<Task> _tasks = [];

  void _refresh() {
    _tasks.clear();

    final List<Color> colors = const [
      Color(0xca00a4fd),
      Color(0xca03302fa),
      Color(0xca0fc7907),
    ];

    final List<String> titles = const [
      'Create design proposal',
      'Go for shopping with family',
      'Friends Meetup',
    ];

    final List<DateTime> starts = [
      DateTime.utc(2021, 01, 01, 13),
      DateTime.utc(2021, 01, 01, 15),
      DateTime.utc(2021, 01, 01, 16),
    ];

    final List<DateTime> finishes = [
      DateTime.utc(2021, 01, 01, 15),
      DateTime.utc(2021, 01, 01, 16),
      DateTime.utc(2021, 01, 01, 18),
    ];

    _tasks.addAll([
      Task(
          continued: true,
          color: colors[0],
          title: titles[0],
          start: starts[0],
          finish: finishes[0]),
      Task(
          continued: false,
          color: colors[1],
          title: titles[1],
          start: starts[1],
          finish: finishes[1]),
      Task(
          continued: false,
          color: colors[2],
          title: titles[2],
          start: starts[2],
          finish: finishes[2]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Calendar((Day day) {
            setState(() {
              _refresh();
            });
          }),
          Container(
            child: Text(
              'Upcoming Tasks',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            padding: EdgeInsets.all(15.0),
            alignment: Alignment.centerLeft,
          ),
          UpcomingTasks(tasks: _tasks),
        ],
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final _paint = Paint()
    ..color = Colors.black
    ..strokeWidth = 2
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FadeAnimation extends StatelessWidget {
  final double _delay;
  final Widget _child;

  const FadeAnimation(this._delay, this._child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateY").add(
          Duration(milliseconds: 500), Tween(begin: -30.0, end: 0.0),
          curve: Curves.easeOut)
    ]);
    return ControlledAnimation(
      playback: Playback.START_OVER_FORWARD,
      delay: Duration(milliseconds: (500 * _delay).round()),
      duration: tween.duration,
      tween: tween,
      child: _child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(0, animation["translateY"]), child: child),
      ),
    );
  }
}
