import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ================================================================
  // CONTROLLERS
  // ================================================================

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _originController = TextEditingController(
    text: 'Stesen Asal',
  );

  final TextEditingController _destinationController = TextEditingController(
    text: 'Destinasi',
  );

  // ================================================================
  // STATE
  // ================================================================

  int _selectedBottomIndex = 0;

  // ================================================================
  // COLORS
  // ================================================================

  static const Color primary = Color(0xFF031636);
  static const Color primaryContainer = Color(0xFF1A2B4C);

  static const Color background = Color(0xFFF6FAFF);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color surfaceContainerLow = Color(0xFFECF5FE);
  static const Color surfaceContainer = Color(0xFFE6EFF8);
  static const Color surfaceContainerHigh = Color(0xFFE0E9F2);

  static const Color onSurface = Color(0xFF141D23);
  static const Color onSurfaceVariant = Color(0xFF44474E);

  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);

  static const Color primaryFixedDim = Color(0xFFB6C6F0);
  static const Color secondary = Color(0xFF785A00);
  static const Color secondaryContainer = Color(0xFFFDCC52);
  static const Color secondaryFixedDim = Color(0xFFF1C048);

  static const Color tertiaryFixedDim = Color(0xFFC4C7CA);
  static const Color onTertiaryFixedVariant = Color(0xFF43474A);

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void dispose() {
    _searchController.dispose();
    _originController.dispose();
    _destinationController.dispose();

    super.dispose();
  }

  // ================================================================
  // SEARCH
  // ================================================================

  void _search() {
    final query = _searchController.text.trim();

    debugPrint('Search: $query');

    // TODO:
    // Implement station / route / destination search.
  }

  // ================================================================
  // SWAP ORIGIN / DESTINATION
  // ================================================================

  void _swapLocations() {
    final origin = _originController.text;
    final destination = _destinationController.text;

    setState(() {
      _originController.text = destination;
      _destinationController.text = origin;
    });
  }

  // ================================================================
  // FIND ROUTE
  // ================================================================

  void _findRoute() {
    final origin = _originController.text.trim();
    final destination = _destinationController.text.trim();

    debugPrint('Origin: $origin');
    debugPrint('Destination: $destination');

    // TODO:
    // Navigate to route result screen.
  }

  // ================================================================
  // NOTIFICATIONS
  // ================================================================

  void _openNotifications() {
    debugPrint('Open notifications');

    // TODO:
    // Navigate to notification screen.
  }

  // ================================================================
  // QUICK ACTION
  // ================================================================

  void _openNearbyStations() {
    debugPrint('Nearby stations');

    // TODO:
    // Navigate to station list.
  }

  void _openSchedule() {
    debugPrint('Schedule');

    // TODO:
    // Navigate to schedule screen.
  }

  void _openMap() {
    debugPrint('Map');

    // TODO:
    // Navigate to map screen.
  }

  void _openAnnouncements() {
    debugPrint('Announcements');

    // TODO:
    // Navigate to notification / announcement screen.
  }

  // ================================================================
  // VIEW ALL NOTICES
  // ================================================================

  void _viewAllNotices() {
    debugPrint('View all notices');

    // TODO:
    // Navigate to all notifications.
  }

  // ================================================================
  // BOTTOM NAVIGATION
  // ================================================================

  void _onBottomNavigationChanged(int index) {
    setState(() {
      _selectedBottomIndex = index;
    });

    debugPrint('Selected navigation: $index');

    // Navigate based on index
    switch (index) {
      case 0:
        // Utama (Home) - already on this page
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        // Stesen (Station List)
        Navigator.pushNamed(context, '/stationlist');
        break;
      case 2:
        // Jadual (Timetable)
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

        child: Column(children: [Expanded(child: _buildBody())]),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ================================================================
  // BODY
  // ================================================================

  Widget _buildBody() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final horizontalPadding = width >= 1000
            ? 40.0
            : width >= 600
            ? 32.0
            : 20.0;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          child: Column(
            children: [
              // ======================================================
              // HEADER
              // ======================================================
              _buildHeader(horizontalPadding: horizontalPadding),

              // ======================================================
              // MAIN CONTENT
              // ======================================================
              Transform.translate(
                offset: const Offset(0, -56),

                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),

                  child: Column(
                    children: [
                      _buildQuickJourneyCard(),

                      const SizedBox(height: 16),

                      _buildQuickActions(),

                      const SizedBox(height: 16),

                      _buildLatestNotice(),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _buildHeader({required double horizontalPadding}) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        40,
        horizontalPadding,
        92,
      ),

      decoration: const BoxDecoration(
        color: primary,

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),

      child: Column(
        children: [
          // ----------------------------------------------------------
          // GREETING
          // ----------------------------------------------------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Selamat pagi,',

                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFFB6C6F0),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'Aiman 👋',

                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Notification
              Material(
                color: Colors.transparent,

                child: InkWell(
                  onTap: _openNotifications,

                  borderRadius: BorderRadius.circular(30),

                  child: Container(
                    width: 44,
                    height: 44,

                    alignment: Alignment.center,

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),

                      shape: BoxShape.circle,
                    ),

                    child: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ----------------------------------------------------------
          // SEARCH
          // ----------------------------------------------------------
          _buildSearchBar(),
        ],
      ),
    );
  }

  // ================================================================
  // SEARCH BAR
  // ================================================================

  Widget _buildSearchBar() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: surface,

        borderRadius: BorderRadius.circular(30),

        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),

      child: TextField(
        controller: _searchController,

        textInputAction: TextInputAction.search,

        onSubmitted: (_) {
          _search();
        },

        style: GoogleFonts.plusJakartaSans(fontSize: 14, color: onSurface),

        decoration: InputDecoration(
          hintText: 'Cari stesen, laluan atau destinasi...',

          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 14, color: outline),

          prefixIcon: const Icon(Icons.search, color: outline),

          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();

                    setState(() {});
                  },

                  icon: const Icon(Icons.clear, color: outline),
                )
              : null,

          border: InputBorder.none,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  // ================================================================
  // PERJALANAN PANTAS
  // ================================================================

  Widget _buildQuickJourneyCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: surface,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: outlineVariant.withOpacity(0.5)),

        boxShadow: const [
          BoxShadow(
            color: Colors.black87,
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ----------------------------------------------------------
          // TITLE
          // ----------------------------------------------------------
          Text(
            'Perjalanan Pantas',

            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------------
          // ORIGIN + DESTINATION
          // ----------------------------------------------------------
          Stack(
            children: [
              // Timeline
              Positioned(
                left: 11,
                top: 12,
                bottom: 12,

                child: Column(
                  children: [
                    // Origin dot
                    Container(
                      width: 8,
                      height: 8,

                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),

                    Expanded(
                      child: Container(
                        width: 2,

                        margin: const EdgeInsets.symmetric(vertical: 4),

                        decoration: const BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: outlineVariant,
                              width: 1.5,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Destination dot
                    Container(
                      width: 8,
                      height: 8,

                      decoration: const BoxDecoration(
                        color: Color(0xFFBA1A1A),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),

              // Inputs
              Column(
                children: [
                  _buildLocationField(
                    label: 'Dari',
                    controller: _originController,
                    onSwap: _swapLocations,
                  ),

                  const SizedBox(height: 20),

                  _buildLocationField(
                    label: 'Ke',
                    controller: _destinationController,
                    onSwap: _swapLocations,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ----------------------------------------------------------
          // FIND ROUTE BUTTON
          // ----------------------------------------------------------
          SizedBox(
            width: double.infinity,
            height: 48,

            child: ElevatedButton(
              onPressed: _findRoute,

              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,

                elevation: 1,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              child: Text(
                'Cari Laluan',

                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // LOCATION FIELD
  // ================================================================

  Widget _buildLocationField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onSwap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            label,

            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: outline,
            ),
          ),

          const SizedBox(height: 4),

          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: outlineVariant, width: 1),
              ),
            ),

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,

                    readOnly: true,

                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: onSurface,
                    ),

                    decoration: const InputDecoration(
                      border: InputBorder.none,

                      contentPadding: EdgeInsets.only(bottom: 8),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: onSwap,

                  visualDensity: VisualDensity.compact,

                  icon: const Icon(Icons.swap_vert, size: 20, color: outline),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // QUICK ACTIONS
  // ================================================================

  Widget _buildQuickActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacing = 12;

        final double itemWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,

          children: [
            SizedBox(
              width: itemWidth,
              child: _buildQuickActionCard(
                icon: Icons.location_on,
                label: 'Stesen\nBerdekatan',
                iconColor: primary,
                iconBackground: primaryFixedDim.withOpacity(0.20),
                onTap: _openNearbyStations,
              ),
            ),

            SizedBox(
              width: itemWidth,
              child: _buildQuickActionCard(
                icon: Icons.calendar_month,
                label: 'Jadual\nPerjalanan',
                iconColor: secondary,
                iconBackground: secondaryFixedDim.withOpacity(0.20),
                onTap: _openSchedule,
              ),
            ),

            SizedBox(
              width: itemWidth,
              child: _buildQuickActionCard(
                icon: Icons.map,
                label: 'Peta Laluan',
                iconColor: const Color(0xFF725500),
                iconBackground: secondaryContainer.withOpacity(0.30),
                onTap: _openMap,
              ),
            ),

            SizedBox(
              width: itemWidth,
              child: _buildQuickActionCard(
                icon: Icons.campaign,
                label: 'Notis &\nMakluman',
                iconColor: onTertiaryFixedVariant,
                iconBackground: tertiaryFixedDim.withOpacity(0.30),
                onTap: _openAnnouncements,
              ),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // QUICK ACTION CARD
  // ================================================================

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color iconBackground,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(12),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: surfaceContainerLow,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(color: outlineVariant.withOpacity(0.3)),

            boxShadow: const [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 12,
                offset: Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),

                child: Icon(icon, color: iconColor, size: 21),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  label,

                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // LATEST NOTICE
  // ================================================================

  Widget _buildLatestNotice() {
    return Padding(
      padding: const EdgeInsets.only(top: 2),

      child: Column(
        children: [
          // ----------------------------------------------------------
          // TITLE
          // ----------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: Text(
                  'Notis Terkini',

                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: onSurface,
                  ),
                ),
              ),

              GestureDetector(
                onTap: _viewAllNotices,

                child: Text(
                  'Lihat semua',

                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ----------------------------------------------------------
          // NOTICE CARD
          // ----------------------------------------------------------
          Material(
            color: Colors.transparent,

            child: InkWell(
              onTap: _viewAllNotices,

              borderRadius: BorderRadius.circular(12),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: surface,

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: outlineVariant.withOpacity(0.5)),

                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black87,
                      blurRadius: 12,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          // MRT badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),

                            decoration: BoxDecoration(
                              color: const Color(0xFF059669),
                              borderRadius: BorderRadius.circular(4),
                            ),

                            child: Text(
                              'MRT',

                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Notice
                          Text(
                            'Perkhidmatan MRT Laluan Kajang '
                            'ditangguhkan 5 minit kerana '
                            'kerja-kerja penyelenggaraan.',

                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                              color: onSurface,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Time
                          Text(
                            '2 jam yang lalu',

                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: outline,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Icon(Icons.chevron_right, color: outline, size: 22),
                  ],
                ),
              ),
            ),
          ),
        ],
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
          color: surface,

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
  // BOTTOM NAVIGATION ITEM
  // ================================================================

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final bool selected = _selectedBottomIndex == index;

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
                    color: selected
                        ? primaryContainer.withOpacity(0.10)
                        : Colors.transparent,

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    selected ? activeIcon : icon,

                    color: selected ? primary : outline,

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

                    fontWeight: selected ? FontWeight.w700 : FontWeight.w400,

                    color: selected ? primary : outline,
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
