import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hgeology_app/models/bookmark.dart';
import 'package:hgeology_app/models/review_log.dart';
import 'package:hgeology_app/provider/reviewLog_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hgeology_app/gen/strings.g.dart';
import 'package:hgeology_app/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class ReviewChart extends StatefulWidget {
  final List<ReviewLog> reviewLogs;

  ReviewChart(this.reviewLogs);

  @override
  _ReviewChartState createState() => _ReviewChartState();
}

class _ReviewChartState extends State<ReviewChart> {
  List<int> counts = List.filled(30, 0);
  // Generate randome mock data
  // List<int> counts = List.generate(30, (index) => Random().nextInt(10));

  @override
  void initState() {
    super.initState();
    DateTime today = DateTime.now();
    for (var log in widget.reviewLogs) {
      DateTime createDate = DateTime.parse(log.createDate);
      int difference = today.difference(createDate).inDays;
      if (difference < 30) {
        counts[29 - difference]++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int sum =
        counts.fold(0, (previousValue, element) => previousValue + element);

    if (sum < 10) {
      return Card(
        elevation: 0,
        color: Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.9),
        child: SizedBox(
          height: 200,
          child: Center(
            child: Text(t.statisticTab.noDataHint),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(mainBarData()),
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: Text(
                "Past Month",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
          color: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(30, (i) {
        return makeGroupData(i, counts[i].toDouble());
      });

  Widget getTitles(double value, TitleMeta meta) {
    DateTime today = DateTime.now();
    DateTime date = today.subtract(Duration(days: 29 - value.toInt()));

    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(
        date.day.toString(),
        style: style,
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barGroups: showingGroups(),
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
    );
  }
}

Map<DateTime, int> transformData(List<Bookmark> checkLogs) {
  Map<DateTime, int> data = {};

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  for (Bookmark log in checkLogs) {
    DateTime logDate = formatter.parse(log.createDate);
    if (!data.containsKey(logDate)) {
      data[logDate] = 1;
    } else {
      data[logDate] = data[logDate]! + 1; // Added null check here
    }
  }

  return data;
}

DateTime calculateStartDate(BuildContext context) {
  double width = MediaQuery.of(context).size.width;

  return DateTime.now()
      .subtract(Duration(days: min(180, ((width - 30) / 4).floor())));
}

class StatisticPage extends ConsumerStatefulWidget {
  StatisticPage();

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends ConsumerState<StatisticPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarkManager = ref.watch(bookmarkProvider);
    final reviewLogsManager = ref.watch(reviewLogsProvider);

    final Random _random = Random();

    final List<String> inspirationalTexts = t.statisticTab.quotes;

    Map<DateTime, int> transformedData =
        transformData(bookmarkManager.bookmarks);

    // print(reviewLogsManager.logs.length);

    return Scaffold(
      appBar: AppBar(title: Text(t.statisticTab.title)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(t.statisticTab.totalBookmark),
                        Text(
                          bookmarkManager.bookmarks.length.toString(),
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: HeatMap(
                  startDate: calculateStartDate(context),
                  endDate: DateTime.now(),
                  colorMode: ColorMode.opacity,
                  showText: false,
                  showColorTip: false,
                  datasets: transformedData,
                  colorsets: {
                    1: Theme.of(context).colorScheme.primary,
                  },
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.statisticTab.totalReview),
                      Text(
                        reviewLogsManager.logs.length.toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: double.maxFinite,
                child: ReviewChart(reviewLogsManager.logs),
              ),
              const SizedBox(
                height: 50,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 24, 10, 48),
                  child: Text(
                    inspirationalTexts[
                        _random.nextInt(inspirationalTexts.length)],
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center, // Add this line
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, int count) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: count.toDouble(),
          color: Colors.blue,
        ),
      ],
    );
  }
}
