import 'package:flutter/material.dart';

import '../database/database_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // ================================================================
  // COLORS
  // ================================================================

  static const Color primary = Color(0xFF031636);
  static const Color background = Color(0xFFF6FAFF);
  static const Color surfaceLow = Color(0xFFECF5FE);
  static const Color textColor = Color(0xFF141D23);
  static const Color textSecondary = Color(0xFF44474E);
  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);
  static const Color error = Color(0xFFBA1A1A);

  // ================================================================
  // USER DATA
  // ================================================================

  Map<String, dynamic>? _user;

  bool _isLoading = true;

  bool get isLoggedIn => _user != null;

  String get name {
    return _user?['name']?.toString() ?? 'Pengguna';
  }

  String get email {
    return _user?['email']?.toString() ?? '';
  }

  String get phone {
    return _user?['phone']?.toString() ?? '';
  }

  // ================================================================
  // INIT
  // ================================================================

  @override
  void initState() {
    super.initState();

    _loadProfile();
  }

  // ================================================================
  // LOAD PROFILE
  // ================================================================

  Future<void> _loadProfile() async {
    try {
      final user = await DatabaseHelper.instance.getUserProfile();

      if (!mounted) return;

      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _user = null;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ralat mendapatkan profil: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  Future<void> _logout() async {
    try {
      await DatabaseHelper.instance.logout();

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ralat semasa log keluar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ================================================================
  // MAIN BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Center(child: CircularProgressIndicator(color: primary)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: background,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadProfile,

                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  padding: const EdgeInsets.symmetric(horizontal: 20),

                  child: Column(
                    children: [
                      // ==============================================
                      // HEADER
                      // ==============================================
                      _buildHeader(),

                      const SizedBox(height: 16),

                      // ==============================================
                      // USER / GUEST PROFILE
                      // ==============================================
                      isLoggedIn
                          ? _buildLoggedInProfile()
                          : _buildGuestProfile(context),

                      const SizedBox(height: 24),

                      // ==============================================
                      // MENU
                      // ==============================================
                      if (isLoggedIn) ...[
                        _buildMenuCard(),

                        const SizedBox(height: 24),

                        _buildLogoutButton(),
                      ] else ...[
                        _buildGuestMenuCard(),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),

            // ========================================================
            // BOTTOM NAVIGATION
            // ========================================================
            const _BottomNavigation(),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _buildHeader() {
    return SizedBox(
      height: 64,

      child: Row(
        children: [
          const SizedBox(width: 48),

          const Expanded(
            child: Text(
              'Profil Saya',
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),

          SizedBox(
            width: 48,

            child: IconButton(
              onPressed: () {
                debugPrint('Settings');
              },

              icon: const Icon(
                Icons.settings_outlined,
                color: textSecondary,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // LOGGED IN PROFILE
  // ================================================================

  Widget _buildLoggedInProfile() {
    return Column(
      children: [
        // ============================================================
        // AVATAR
        // ============================================================
        _buildAvatar(),

        const SizedBox(height: 16),

        // ============================================================
        // NAME
        // ============================================================
        Text(
          name,

          textAlign: TextAlign.center,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        // ============================================================
        // EMAIL
        // ============================================================
        if (email.isNotEmpty) ...[
          const SizedBox(height: 4),

          Text(
            email,

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 14, color: textSecondary),
          ),
        ],

        // ============================================================
        // PHONE
        // ============================================================
        if (phone.isNotEmpty) ...[
          const SizedBox(height: 4),

          Text(
            phone,

            textAlign: TextAlign.center,

            style: const TextStyle(fontSize: 14, color: textSecondary),
          ),
        ],
      ],
    );
  }

  // ================================================================
  // GUEST PROFILE
  // ================================================================

  Widget _buildGuestProfile(BuildContext context) {
    return Column(
      children: [
        // ============================================================
        // GUEST AVATAR
        // ============================================================
        Container(
          width: 96,
          height: 96,

          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE0E9F2),
          ),

          child: const Icon(Icons.person_outline, size: 52, color: primary),
        ),

        const SizedBox(height: 16),

        // ============================================================
        // GUEST TITLE
        // ============================================================
        const Text(
          'Tetamu',

          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        const SizedBox(height: 6),

        // ============================================================
        // DESCRIPTION
        // ============================================================
        const Text(
          'Log masuk untuk melihat dan mengurus profil anda.',

          textAlign: TextAlign.center,

          style: TextStyle(fontSize: 14, color: textSecondary),
        ),

        const SizedBox(height: 18),

        // ============================================================
        // LOGIN BUTTON
        // ============================================================
        SizedBox(
          width: double.infinity,
          height: 48,

          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,

              elevation: 0,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            icon: const Icon(Icons.login, size: 20),

            label: const Text(
              'Log Masuk',

              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // ============================================================
        // REGISTER
        // ============================================================
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },

          child: const Text(
            'Belum mempunyai akaun? Daftar',

            style: TextStyle(
              color: primary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // AVATAR
  // ================================================================

  Widget _buildAvatar() {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        Container(
          width: 96,
          height: 96,

          padding: const EdgeInsets.all(4),

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,

            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
            ],
          ),

          child: ClipOval(
            child: Image.asset(
              'assets/images/profile.png',

              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFFE0E9F2),

                  alignment: Alignment.center,

                  child: const Icon(Icons.person, size: 55, color: primary),
                );
              },
            ),
          ),
        ),

        // ============================================================
        // CAMERA BUTTON
        // ============================================================
        Positioned(
          right: -2,
          bottom: 0,

          child: InkWell(
            onTap: () {
              debugPrint('Change profile image');
            },

            borderRadius: BorderRadius.circular(50),

            child: Container(
              width: 32,
              height: 32,

              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,

                border: Border.all(color: surfaceLow),
              ),

              child: const Icon(Icons.photo_camera, size: 16, color: primary),
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // USER MENU
  // ================================================================

  Widget _buildMenuCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: surfaceLow),
      ),

      child: Column(
        children: [
          // ==========================================================
          // PERSONAL INFO
          // ==========================================================
          _ProfileMenuTile(
            icon: Icons.person_outline,
            title: 'Maklumat Peribadi',

            onTap: () {
              debugPrint('Maklumat Peribadi');
            },
          ),

          const _MenuDivider(),

          // ==========================================================
          // FAVORITES
          // ==========================================================
          _ProfileMenuTile(
            icon: Icons.favorite_border,
            title: 'Kegemaran Saya',

            onTap: () {
              debugPrint('Kegemaran Saya');
            },
          ),

          const _MenuDivider(),

          // ==========================================================
          // NOTIFICATION
          // ==========================================================
          _ProfileMenuTile(
            icon: Icons.notifications_none,
            title: 'Notifikasi',

            onTap: () {
              debugPrint('Notifikasi');
            },
          ),

          const _MenuDivider(),

          // ==========================================================
          // LANGUAGE
          // ==========================================================
          _ProfileMenuTile(
            icon: Icons.language,
            title: 'Bahasa',
            trailingText: 'Bahasa Melayu',

            onTap: () {
              debugPrint('Bahasa');
            },
          ),

          const _MenuDivider(),

          // ==========================================================
          // HELP
          // ==========================================================
          _ProfileMenuTile(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan',

            onTap: () {
              debugPrint('Pusat Bantuan');
            },
          ),

          const _MenuDivider(),

          // ==========================================================
          // SHARE
          // ==========================================================
          _ProfileMenuTile(
            icon: Icons.share_outlined,
            title: 'Kongsi Aplikasi',

            onTap: () {
              debugPrint('Kongsi Aplikasi');
            },
          ),
        ],
      ),
    );
  }

  // ================================================================
  // GUEST MENU
  // ================================================================

  Widget _buildGuestMenuCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: surfaceLow),
      ),

      child: Column(
        children: [
          _ProfileMenuTile(
            icon: Icons.language,
            title: 'Bahasa',
            trailingText: 'Bahasa Melayu',

            onTap: () {
              debugPrint('Bahasa');
            },
          ),

          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan',

            onTap: () {
              debugPrint('Pusat Bantuan');
            },
          ),

          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.share_outlined,
            title: 'Kongsi Aplikasi',

            onTap: () {
              debugPrint('Kongsi Aplikasi');
            },
          ),
        ],
      ),
    );
  }

  // ================================================================
  // LOGOUT BUTTON
  // ================================================================

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,

      child: OutlinedButton.icon(
        onPressed: _logout,

        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: error,

          side: const BorderSide(color: outlineVariant),

          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),

        icon: const Icon(Icons.logout, size: 20),

        label: const Text(
          'Log Keluar',

          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// ==================================================================
// PROFILE MENU TILE
// ==================================================================

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailingText;
  final VoidCallback onTap;

  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailingText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        child: Row(
          children: [
            Icon(icon, size: 24, color: _ProfileScreenState.outline),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,

                style: const TextStyle(
                  fontSize: 16,
                  color: _ProfileScreenState.textColor,
                ),
              ),
            ),

            if (trailingText != null) ...[
              Text(
                trailingText!,

                style: const TextStyle(
                  fontSize: 14,
                  color: _ProfileScreenState.textSecondary,
                ),
              ),

              const SizedBox(width: 8),
            ],

            const Icon(
              Icons.chevron_right,
              size: 20,
              color: _ProfileScreenState.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}

// ==================================================================
// MENU DIVIDER
// ==================================================================

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: _ProfileScreenState.surfaceLow,
    );
  }
}

// ==================================================================
// BOTTOM NAVIGATION
// ==================================================================

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),

            blurRadius: 12,

            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [
          // ==========================================================
          // HOME
          // ==========================================================
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Utama',

            onTap: () {
              Navigator.pushNamed(context, '/home');
            },
          ),

          // ==========================================================
          // STATION
          // ==========================================================
          _NavItem(
            icon: Icons.location_on_outlined,
            label: 'Stesen',

            onTap: () {
              Navigator.pushNamed(context, '/stationlist');
            },
          ),

          // ==========================================================
          // TIMETABLE
          // ==========================================================
          _NavItem(
            icon: Icons.calendar_month_outlined,
            label: 'Jadual',

            onTap: () {
              Navigator.pushNamed(context, '/timetable');
            },
          ),

          // ==========================================================
          // NOTIFICATION
          // ==========================================================
          _NavItem(
            icon: Icons.notifications_none,
            label: 'Notifikasi',

            onTap: () {
              debugPrint('Navigate to notifications');
            },
          ),

          // ==========================================================
          // PROFILE
          // ==========================================================
          _NavItem(
            icon: Icons.person,
            label: 'Profil',
            active: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ==================================================================
// NAVIGATION ITEM
// ==================================================================

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = active
        ? _ProfileScreenState.primary
        : _ProfileScreenState.outline;

    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(12),

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),

        decoration: active
            ? BoxDecoration(
                color: const Color(0x1A1A2B4C),

                borderRadius: BorderRadius.circular(12),
              )
            : null,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Icon(icon, size: 24, color: color),

            const SizedBox(height: 4),

            Text(
              label,

              style: TextStyle(
                fontSize: 11,
                color: color,

                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
