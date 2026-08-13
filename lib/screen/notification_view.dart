import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

// ================================================================
// NOTIFICATION MODEL
// ================================================================

class AppNotification {
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  final IconData icon;
  bool isRead;

  AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    required this.icon,
    this.isRead = false,
  });
}

enum NotificationType { service, account, promotion }

// ================================================================
// SCREEN
// ================================================================

class _NotificationScreenState extends State<NotificationScreen> {
  // ================================================================
  // COLORS
  // ================================================================

  static const Color primary = Color(0xFF031636);
  static const Color primaryContainer = Color(0xFF1A2B4C);

  static const Color background = Color(0xFFF6FAFF);
  static const Color surface = Color(0xFFF6FAFF);
  static const Color surfaceContainer = Color(0xFFE6EFF8);
  static const Color surfaceContainerHigh = Color(0xFFE0E9F2);

  static const Color onSurface = Color(0xFF141D23);
  static const Color onSurfaceVariant = Color(0xFF44474E);

  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);

  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color secondaryContainer = Color(0xFFFDCC52);
  static const Color onSecondaryContainer = Color(0xFF725500);

  // ================================================================
  // STATE
  // ================================================================

  String _selectedFilter = 'Semua';

  int _selectedBottomIndex = 3;

  // ================================================================
  // NOTIFICATIONS
  // ================================================================

  final List<AppNotification> _notifications = [
    AppNotification(
      title: 'MRT Laluan Kajang',
      message:
          'Gangguan teknikal di Stesen Bukit Bintang. '
          'Jangkaan kelewatan 10 minit.',
      time: '5 minit lalu',
      type: NotificationType.service,
      icon: Icons.warning,
    ),

    AppNotification(
      title: 'Kemas Kini Akaun',
      message: 'Akaun anda telah berjaya dikemas kini.',
      time: '2 jam lalu',
      type: NotificationType.account,
      icon: Icons.manage_accounts,
      isRead: true,
    ),

    AppNotification(
      title: 'Promosi Istimewa',
      message:
          'Nikmati diskaun 20% untuk perjalanan seterusnya '
          'hujung minggu ini!',
      time: '1 hari lalu',
      type: NotificationType.promotion,
      icon: Icons.star,
      isRead: true,
    ),

    AppNotification(
      title: 'LRT Kelana Jaya',
      message:
          'Penyelenggaraan landasan di antara Stesen KLCC '
          'dan Ampang Park pada hujung minggu ini.',
      time: '3 jam lalu',
      type: NotificationType.service,
      icon: Icons.engineering,
    ),

    AppNotification(
      title: 'Diskaun Awal Pagi',
      message:
          'Nikmati diskaun 50% untuk perjalanan sebelum '
          'jam 7:30 pagi setiap hari bekerja!',
      time: '5 jam lalu',
      type: NotificationType.promotion,
      icon: Icons.local_offer,
      isRead: true,
    ),

    AppNotification(
      title: 'Amaran Keselamatan',
      message:
          'Log masuk baharu dikesan dari peranti yang tidak '
          'dikenali. Sila sahkan identiti anda.',
      time: '12 jam lalu',
      type: NotificationType.service,
      icon: Icons.security,
    ),

    AppNotification(
      title: 'Kemas Kini Aplikasi',
      message:
          'Versi 2.4 kini tersedia! Nikmati ciri penjejakan '
          'masa nyata yang lebih tepat.',
      time: '1 hari lalu',
      type: NotificationType.account,
      icon: Icons.system_update,
      isRead: true,
    ),

    AppNotification(
      title: 'Peringatan Pas Bulanan',
      message:
          'Pas bulanan anda akan tamat dalam masa 3 hari. '
          'Perbaharui sekarang untuk perjalanan tanpa gangguan.',
      time: '2 hari lalu',
      type: NotificationType.account,
      icon: Icons.event_repeat,
      isRead: true,
    ),
  ];

  // ================================================================
  // FILTERED NOTIFICATIONS
  // ================================================================

  List<AppNotification> get _filteredNotifications {
    if (_selectedFilter == 'Semua') {
      return _notifications;
    }

    if (_selectedFilter == 'Perkhidmatan') {
      return _notifications
          .where(
            (notification) => notification.type == NotificationType.service,
          )
          .toList();
    }

    if (_selectedFilter == 'Akaun') {
      return _notifications
          .where(
            (notification) => notification.type == NotificationType.account,
          )
          .toList();
    }

    return _notifications;
  }

  // ================================================================
  // MARK ALL AS READ
  // ================================================================

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification.isRead = true;
      }
    });

    _showMessage('Semua notifikasi telah ditanda sebagai dibaca.');
  }

  // ================================================================
  // MARK SINGLE NOTIFICATION AS READ
  // ================================================================

  void _openNotification(AppNotification notification) {
    setState(() {
      notification.isRead = true;
    });

    debugPrint('Notification clicked: ${notification.title}');

    // TODO:
    // Navigate to notification detail if needed.
  }

  // ================================================================
  // FILTER
  // ================================================================

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  // ================================================================
  // BACK
  // ================================================================

  void _goBack() {
    Navigator.pop(context);
  }

  // ================================================================
  // BOTTOM NAVIGATION
  // ================================================================

  void _onBottomNavigationChanged(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;

      case 1:
        debugPrint('Navigate to station');
        Navigator.pushReplacementNamed(context, '/stationlist');
        break;

      case 2:
        Navigator.pushReplacementNamed(context, '/timetable');
        break;

      case 3:
        // Already on notification.
        break;

      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  // ================================================================
  // MESSAGE
  // ================================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.plusJakartaSans(fontSize: 13),
        ),
      ),
    );
  }

  // ================================================================
  // MAIN BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        bottom: false,

        child: Column(
          children: [
            // ========================================================
            // TOP BAR
            // ========================================================
            _buildTopBar(),

            // ========================================================
            // FILTERS
            // ========================================================
            _buildFilters(),

            // ========================================================
            // NOTIFICATION LIST
            // ========================================================
            Expanded(child: _buildNotificationList()),
          ],
        ),
      ),

      // ============================================================
      // BOTTOM NAVIGATION
      // ============================================================
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ================================================================
  // TOP BAR
  // ================================================================

  Widget _buildTopBar() {
    return SizedBox(
      height: 64,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: Row(
          children: [
            // --------------------------------------------------------
            // BACK
            // --------------------------------------------------------
            IconButton(
              onPressed: _goBack,

              padding: EdgeInsets.zero,

              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),

              icon: const Icon(Icons.arrow_back, color: primary, size: 22),
            ),

            // --------------------------------------------------------
            // TITLE
            // --------------------------------------------------------
            Expanded(
              child: Text(
                'Notifikasi',

                textAlign: TextAlign.center,

                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ),

            // --------------------------------------------------------
            // MARK AS READ
            // --------------------------------------------------------
            TextButton(
              onPressed: _markAllAsRead,

              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

                minimumSize: Size.zero,

                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),

              child: Text(
                'Tanda dibaca',

                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // FILTERS
  // ================================================================

  Widget _buildFilters() {
    const filters = ['Semua', 'Perkhidmatan', 'Akaun'];

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),

      decoration: const BoxDecoration(
        color: background,

        boxShadow: [
          BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),

      child: SizedBox(
        height: 40,

        child: ListView.separated(
          scrollDirection: Axis.horizontal,

          itemCount: filters.length,

          separatorBuilder: (_, __) {
            return const SizedBox(width: 8);
          },

          itemBuilder: (context, index) {
            final filter = filters[index];

            return _buildFilterChip(
              filter: filter,
              isSelected: _selectedFilter == filter,
            );
          },
        ),
      ),
    );
  }

  // ================================================================
  // FILTER CHIP
  // ================================================================

  Widget _buildFilterChip({required String filter, required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        _selectFilter(filter);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        decoration: BoxDecoration(
          color: isSelected ? primary : surfaceContainer,

          borderRadius: BorderRadius.circular(999),

          border: isSelected
              ? null
              : Border.all(color: outlineVariant.withOpacity(0.3)),

          boxShadow: isSelected
              ? const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),

        child: Text(
          filter,

          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,

            fontWeight: FontWeight.w600,

            color: isSelected ? Colors.white : onSurface,
          ),
        ),
      ),
    );
  }

  // ================================================================
  // NOTIFICATION LIST
  // ================================================================

  Widget _buildNotificationList() {
    final notifications = _filteredNotifications;

    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),

      itemCount: notifications.length,

      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        final notification = notifications[index];

        return _buildNotificationCard(notification);
      },
    );
  }

  // ================================================================
  // NOTIFICATION CARD
  // ================================================================

  Widget _buildNotificationCard(AppNotification notification) {
    final bool isService = notification.type == NotificationType.service;

    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          _openNotification(notification);
        },

        borderRadius: BorderRadius.circular(12),

        child: Container(
          width: double.infinity,

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(
              color: isService
                  ? error.withOpacity(0.10)
                  : outlineVariant.withOpacity(0.20),
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isService ? 0.06 : 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: [
                // ----------------------------------------------------
                // SERVICE LEFT INDICATOR
                // ----------------------------------------------------
                if (isService)
                  Container(
                    width: 4,

                    decoration: const BoxDecoration(
                      color: error,

                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),

                // ----------------------------------------------------
                // CONTENT
                // ----------------------------------------------------
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // ------------------------------------------------
                        // ICON
                        // ------------------------------------------------
                        _buildNotificationIcon(notification),

                        const SizedBox(width: 16),

                        // ------------------------------------------------
                        // TEXT
                        // ------------------------------------------------
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              // ------------------------------------------
                              // TITLE + TIME
                              // ------------------------------------------
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Expanded(
                                    child: Text(
                                      notification.title,

                                      maxLines: 2,

                                      overflow: TextOverflow.ellipsis,

                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: onSurface,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    notification.time,

                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: outline,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              // ------------------------------------------
                              // MESSAGE
                              // ------------------------------------------
                              Text(
                                notification.message,

                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.45,
                                  color: onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // NOTIFICATION ICON
  // ================================================================

  Widget _buildNotificationIcon(AppNotification notification) {
    Color backgroundColor;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.service:
        backgroundColor = errorContainer;
        iconColor = onErrorContainer;
        break;

      case NotificationType.account:
        backgroundColor = primaryContainer.withOpacity(0.10);
        iconColor = primary;
        break;

      case NotificationType.promotion:
        backgroundColor = secondaryContainer;
        iconColor = onSecondaryContainer;
        break;
    }

    return Container(
      width: 40,
      height: 40,

      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),

      alignment: Alignment.center,

      child: Icon(notification.icon, color: iconColor, size: 21),
    );
  }

  // ================================================================
  // EMPTY STATE
  // ================================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: 64,
              height: 64,

              decoration: const BoxDecoration(
                color: surfaceContainerHigh,
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.notifications_none,
                color: primary,
                size: 32,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Tiada notifikasi',

              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Tiada notifikasi dalam kategori ini.',

              textAlign: TextAlign.center,

              style: GoogleFonts.plusJakartaSans(fontSize: 13, color: outline),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // BOTTOM NAVIGATION
  // ================================================================

  Widget _buildBottomNavigation() {
    return SafeArea(
      top: false,

      child: Container(
        height: 76,

        decoration: const BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),

        child: Row(
          children: [
            _buildBottomNavItem(
              index: 0,
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Utama',
            ),

            _buildBottomNavItem(
              index: 1,
              icon: Icons.location_on_outlined,
              activeIcon: Icons.location_on,
              label: 'Stesen',
            ),

            _buildBottomNavItem(
              index: 2,
              icon: Icons.calendar_month_outlined,
              activeIcon: Icons.calendar_month,
              label: 'Jadual',
            ),

            _buildBottomNavItem(
              index: 3,
              icon: Icons.notifications_none,
              activeIcon: Icons.notifications,
              label: 'Notifikasi',
            ),

            _buildBottomNavItem(
              index: 4,
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // BOTTOM NAV ITEM
  // ================================================================

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool isSelected = _selectedBottomIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,

        child: InkWell(
          onTap: () {
            _onBottomNavigationChanged(index);
          },

          borderRadius: BorderRadius.circular(12),

          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),

                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),

                  decoration: BoxDecoration(
                    color: isSelected
                        ? primaryContainer.withOpacity(0.10)
                        : Colors.transparent,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    isSelected ? activeIcon : icon,

                    color: isSelected ? primary : outline,

                    size: 23,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  label,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,

                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,

                    color: isSelected ? primary : outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
