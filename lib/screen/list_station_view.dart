import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

// ================================================================
// STATION MODEL
// ================================================================

class Station {
  final String name;
  final List<String> lines;
  final String distance;
  final IconData icon;

  const Station({
    required this.name,
    required this.lines,
    required this.distance,
    required this.icon,
  });
}

// ================================================================
// SCREEN
// ================================================================

class _StationListScreenState extends State<StationListScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedFilter = 'Semua';

  int _selectedBottomIndex = 1;

  // ================================================================
  // COLORS
  // ================================================================

  static const Color primary = Color(0xFF031636);
  static const Color primaryContainer = Color(0xFF1A2B4C);

  static const Color background = Color(0xFFF6FAFF);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color surfaceContainer = Color(0xFFE6EFF8);
  static const Color surfaceContainerHigh = Color(0xFFE0E9F2);

  static const Color onSurface = Color(0xFF141D23);
  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);

  // ================================================================
  // FILTERS
  // ================================================================

  final List<String> _filters = const [
    'Semua',
    'MRT',
    'LRT',
    'KTM',
    'BRT',
    'Bas',
  ];

  // ================================================================
  // STATIONS
  // ================================================================

  final List<Station> _stations = const [
    Station(
      name: 'KL Sentral',
      lines: ['KTM', 'LRT', 'MRT'],
      distance: '0.5 km',
      icon: Icons.train,
    ),
    Station(
      name: 'Bukit Bintang',
      lines: ['MRT', 'MRL'],
      distance: '1.2 km',
      icon: Icons.train,
    ),
    Station(
      name: 'Pasar Seni',
      lines: ['LRT', 'MRT'],
      distance: '1.8 km',
      icon: Icons.directions_subway,
    ),
    Station(
      name: 'Masjid Jamek',
      lines: ['LRT'],
      distance: '1.9 km',
      icon: Icons.directions_subway,
    ),
    Station(
      name: 'Bandaraya',
      lines: ['LRT'],
      distance: '2.3 km',
      icon: Icons.directions_subway,
    ),
    Station(
      name: 'Tun Sambanthan',
      lines: ['MRL'],
      distance: '2.6 km',
      icon: Icons.train,
    ),
  ];

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ================================================================
  // FILTERED STATIONS
  // ================================================================

  List<Station> get _filteredStations {
    final searchText = _searchController.text.trim().toLowerCase();

    return _stations.where((station) {
      // Search filter
      final matchesSearch =
          searchText.isEmpty ||
          station.name.toLowerCase().contains(searchText);

      // Transport filter
      final matchesFilter =
          _selectedFilter == 'Semua' ||
          station.lines.contains(_selectedFilter);

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ================================================================
  // FILTER SELECTION
  // ================================================================

  void _selectFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  // ================================================================
  // SEARCH
  // ================================================================

  void _onSearchChanged(String value) {
    setState(() {});
  }

  // ================================================================
  // STATION CLICK
  // ================================================================

  void _openStation(Station station) {
    debugPrint('Selected station: ${station.name}');

    // TODO:
    // Navigate to station detail screen.
    //
    // Example:
    //
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => StationDetailScreen(
    //       station: station,
    //     ),
    //   ),
    // );
  }

  // ================================================================
  // FILTER BUTTON
  // ================================================================

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              20,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pilih Jenis Pengangkutan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),

                const SizedBox(height: 16),

                ..._filters.map(
                  (filter) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,

                      title: Text(
                        filter,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: onSurface,
                        ),
                      ),

                      trailing: _selectedFilter == filter
                          ? const Icon(
                              Icons.check,
                              color: primary,
                            )
                          : null,

                      onTap: () {
                        _selectFilter(filter);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================================================================
  // BACK BUTTON
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

    debugPrint('Bottom navigation index: $index');

    // TODO:
    // Navigate to your different screens.
    //
    // 0 = Utama
    // 1 = Stesen
    // 2 = Jadual
    // 3 = Notifikasi
    // 4 = Profil
  }

  // ================================================================
  // MAIN BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // --------------------------------------------------------------
      // APP BAR
      // --------------------------------------------------------------

      appBar: _buildAppBar(),

      // --------------------------------------------------------------
      // BODY
      // --------------------------------------------------------------

      body: Column(
        children: [
          // Search + filters
          _buildSearchSection(),

          // Station list
          Expanded(
            child: _buildStationList(),
          ),
        ],
      ),

      // --------------------------------------------------------------
      // BOTTOM NAVIGATION
      // --------------------------------------------------------------

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ================================================================
  // APP BAR
  // ================================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: background,
      elevation: 0,

      centerTitle: true,

      leading: IconButton(
        onPressed: _goBack,
        icon: const Icon(
          Icons.chevron_left,
          color: primary,
          size: 28,
        ),
      ),

      title: Text(
        'Senarai Stesen',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
      ),

      actions: [
        IconButton(
          onPressed: _openFilter,
          icon: const Icon(
            Icons.filter_list,
            color: primary,
          ),
        ),

        const SizedBox(width: 8),
      ],
    );
  }

  // ================================================================
  // SEARCH SECTION
  // ================================================================

  Widget _buildSearchSection() {
    return Container(
      width: double.infinity,

      color: background,

      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        16,
      ),

      child: Column(
        children: [
          // ----------------------------------------------------------
          // SEARCH BAR
          // ----------------------------------------------------------

          TextField(
            controller: _searchController,

            onChanged: _onSearchChanged,

            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: onSurface,
            ),

            decoration: InputDecoration(
              hintText: 'Cari stesen...',

              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: outline,
              ),

              prefixIcon: const Icon(
                Icons.search,
                color: outline,
              ),

              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();

                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: outline,
                      ),
                    )
                  : null,

              filled: true,

              fillColor: surface,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: outlineVariant,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: primary,
                  width: 1,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ----------------------------------------------------------
          // FILTER CHIPS
          // ----------------------------------------------------------

          SizedBox(
            height: 34,

            child: ListView.separated(
              scrollDirection: Axis.horizontal,

              itemCount: _filters.length,

              separatorBuilder: (_, __) {
                return const SizedBox(width: 8);
              },

              itemBuilder: (context, index) {
                final filter = _filters[index];

                return _buildFilterChip(
                  filter: filter,
                  isSelected: _selectedFilter == filter,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // FILTER CHIP
  // ================================================================

  Widget _buildFilterChip({
    required String filter,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        _selectFilter(filter);
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),

        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 7,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? primary
              : surface,

          borderRadius: BorderRadius.circular(999),

          border: Border.all(
            color: isSelected
                ? primary
                : outlineVariant,
          ),

          boxShadow: isSelected
              ? [
                  const BoxShadow(
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
            fontSize: 12,
            fontWeight: FontWeight.w500,

            color: isSelected
                ? Colors.white
                : onSurface,
          ),
        ),
      ),
    );
  }

  // ================================================================
  // STATION LIST
  // ================================================================

  Widget _buildStationList() {
    final stations = _filteredStations;

    if (stations.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        20,
        8,
        20,
        24,
      ),

      itemCount: stations.length,

      separatorBuilder: (_, __) {
        return const SizedBox(height: 12);
      },

      itemBuilder: (context, index) {
        final station = stations[index];

        return _buildStationCard(station);
      },
    );
  }

  // ================================================================
  // STATION CARD
  // ================================================================

  Widget _buildStationCard(Station station) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: () {
          _openStation(station);
        },

        borderRadius: BorderRadius.circular(12),

        child: Container(
          width: double.infinity,

          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            color: surface,

            borderRadius: BorderRadius.circular(12),

            border: Border.all(
              color: outlineVariant.withOpacity(0.5),
            ),

            boxShadow: const [
              BoxShadow(
                color: Colors.black54,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),

          child: Row(
            children: [
              // ------------------------------------------------------
              // LEFT
              // ------------------------------------------------------

              Expanded(
                child: Row(
                  children: [
                    // Station icon
                    Container(
                      width: 40,
                      height: 40,

                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: surfaceContainerHigh,
                      ),

                      child: Icon(
                        station.icon,
                        color: primary,
                        size: 22,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Station information
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [
                          // Station name
                          Text(
                            station.name,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: onSurface,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // Transport badges
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,

                            children: station.lines.map(
                              (line) {
                                return _buildLineBadge(line);
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // ------------------------------------------------------
              // RIGHT
              // ------------------------------------------------------

              Row(
                mainAxisSize: MainAxisSize.min,

                children: [
                  Text(
                    station.distance,

                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: outline,
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Icon(
                    Icons.chevron_right,
                    color: outline,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // LINE BADGE
  // ================================================================

  Widget _buildLineBadge(String line) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
      ),

      decoration: BoxDecoration(
        color: _getLineColor(line),

        borderRadius: BorderRadius.circular(4),
      ),

      child: Text(
        line,

        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  // ================================================================
  // LINE COLORS
  // ================================================================

  Color _getLineColor(String line) {
    switch (line.toUpperCase()) {
      case 'KTM':
        return const Color(0xFF2169B0);

      case 'LRT':
        return const Color(0xFFDA2128);

      case 'MRT':
        return const Color(0xFF178253);

      case 'BRT':
        return const Color(0xFF8C9449);

      case 'MRL':
      case 'MONORAIL':
        return const Color(0xFF9EC021);

      case 'BAS':
        return const Color(0xFF785A00);

      default:
        return outline;
    }
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
                shape: BoxShape.circle,
                color: surfaceContainerHigh,
              ),

              child: const Icon(
                Icons.search_off,
                color: primary,
                size: 30,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Stesen tidak dijumpai',

              textAlign: TextAlign.center,

              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Cuba cari dengan nama stesen atau pilih kategori lain.',

              textAlign: TextAlign.center,

              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: outline,
              ),
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
          color: surface,

          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,

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
      child: InkWell(
        onTap: () {
          _onBottomNavigationChanged(index);
        },

        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),

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

                  color: isSelected
                      ? primary
                      : outline,

                  size: 24,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                label,

                maxLines: 1,

                overflow: TextOverflow.ellipsis,

                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,

                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w400,

                  color: isSelected
                      ? primary
                      : outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}