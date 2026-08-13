import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  bool isWeekday = true;
  bool showAll = false;
  int selectedBottomNav = 2;

  final List<List<String>> weekdayTimes = [
    ['05:30', '05:57'],
    ['05:45', '06:12'],
    ['06:00', '06:27'],
    ['06:15', '06:42'],
    ['06:30', '06:57'],
    ['06:45', '07:12'],
    ['07:00', '07:27'],
    ['07:15', '07:42'],
    ['07:30', '07:57'],
    ['07:45', '08:12'],
    ['08:00', '08:27'],
    ['08:15', '08:42'],
    ['08:30', '08:57'],
    ['08:45', '09:12'],
  ];

  final List<List<String>> weekendTimes = [
    ['06:00', '06:27'],
    ['06:20', '06:47'],
    ['06:40', '07:07'],
    ['07:00', '07:27'],
    ['07:20', '07:47'],
    ['07:40', '08:07'],
    ['08:00', '08:27'],
    ['08:20', '08:47'],
    ['08:40', '09:07'],
    ['09:00', '09:27'],
  ];

  static const Color primary = Color(0xFF031636);
  static const Color primaryContainer = Color(0xFF1A2B4C);

  static const Color background = Color(0xFFF6FAFF);
  static const Color surfaceContainerLow = Color(0xFFECF5FE);
  static const Color surfaceVariant = Color(0xFFDBE4ED);

  static const Color onSurface = Color(0xFF141D23);
  static const Color onSurfaceVariant = Color(0xFF44474E);
  static const Color outline = Color(0xFF75777F);

  @override
  Widget build(BuildContext context) {
    final currentTimes = isWeekday ? weekdayTimes : weekendTimes;

    final displayedTimes = showAll
        ? currentTimes
        : currentTimes.take(10).toList();

    return Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: const Icon(Icons.arrow_back, color: onSurface),
        ),
        title: const Text(
          'Jadual Perjalanan',
          style: TextStyle(
            color: primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.star_border, color: onSurface),
          ),
        ],
      ),

      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Column(
            children: [
              const SizedBox(height: 4),

              _buildRouteCard(),

              const SizedBox(height: 16),

              _buildTabs(),

              const SizedBox(height: 16),

              _buildTimetable(displayedTimes, currentTimes.length),

              const SizedBox(height: 18),

              _buildInfoBox(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Color(0xFFB6C6F0),
                size: 21,
              ),
              SizedBox(width: 8),
              Text(
                'KL Sentral',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const Row(
            children: [
              Icon(Icons.arrow_forward, color: Color(0xFFB6C6F0), size: 21),
              SizedBox(width: 8),
              Text(
                'Kajang',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'MRT Laluan Kajang',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: surfaceVariant)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTab(
              title: 'Hari Biasa',
              selected: isWeekday,
              onTap: () {
                setState(() {
                  isWeekday = true;
                  showAll = false;
                });
              },
            ),
          ),
          Expanded(
            child: _buildTab(
              title: 'Hujung Minggu',
              selected: !isWeekday,
              onTap: () {
                setState(() {
                  isWeekday = false;
                  showAll = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: selected ? 2 : 0,
              color: selected ? primary : Colors.transparent,
            ),
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
            color: selected ? primary : onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildTimetable(List<List<String>> times, int totalLength) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: surfaceVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            color: surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            child: const Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'Dari KL Sentral',
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Text(
                      'Kearah Kajang',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ...List.generate(times.length, (index) {
            final time = times[index];

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
              decoration: BoxDecoration(
                color: index.isOdd
                    ? background.withValues(alpha: 0.5)
                    : Colors.white,
                border: const Border(top: BorderSide(color: surfaceVariant)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      time[0],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      time[1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          if (totalLength > 10)
            InkWell(
              onTap: () {
                setState(() {
                  showAll = !showAll;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: surfaceVariant)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      showAll ? 'Lihat lebih sedikit' : 'Lihat lebih banyak',
                      style: const TextStyle(
                        color: primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      showAll ? Icons.expand_less : Icons.expand_more,
                      size: 18,
                      color: primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: surfaceVariant.withValues(alpha: 0.5)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.schedule, color: primary),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: onSurface,
                    ),
                    children: [
                      TextSpan(text: 'Anggaran masa perjalanan: '),
                      TextSpan(
                        text: '55 minit',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  '(KL Sentral → Kajang)',
                  style: TextStyle(fontSize: 11, color: onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: selectedBottomNav,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: primary,
      unselectedItemColor: outline,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      elevation: 12,
      onTap: (index) {
        setState(() {
          selectedBottomNav = index;
        });

        // Navigate based on index
        switch (index) {
          case 0:
            // Utama (Home)
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            // Stesen (Station List)
            Navigator.pushNamed(context, '/stationlist');
            break;
          case 2:
            // Jadual (Timetable) - already on this page
            Navigator.pushNamed(context, '/timetable');
            break;
          case 3:
            // Notifikasi (Notifications) - TODO: implement notification screen
            debugPrint('Navigate to notifications');
            break;
          case 4:
            // Profil (Profile)
            Navigator.pushNamed(context, '/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Utama',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.location_on_outlined),
          activeIcon: Icon(Icons.location_on),
          label: 'Stesen',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: 'Jadual',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications_outlined),
          activeIcon: Icon(Icons.notifications),
          label: 'Notifikasi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
    );
  }
}
