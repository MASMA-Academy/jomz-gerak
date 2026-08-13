import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final bool isLoggedIn;
  final String? name;
  final String? email;
  final String? phone;

  const ProfileScreen({
    super.key,
    this.isLoggedIn = true,
    this.name,
    this.email,
    this.phone,
  });

  static const Color primary = Color(0xFF031636);
  static const Color background = Color(0xFFF6FAFF);
  static const Color surfaceLow = Color(0xFFECF5FE);
  static const Color textColor = Color(0xFF141D23);
  static const Color textSecondary = Color(0xFF44474E);
  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);
  static const Color error = Color(0xFFBA1A1A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 16),

                    isLoggedIn
                        ? _buildLoggedInProfile()
                        : _buildGuestProfile(context),

                    const SizedBox(height: 24),

                    if (isLoggedIn) ...[
                      _buildMenuCard(),
                      const SizedBox(height: 24),
                      _buildLogoutButton(context),
                    ] else ...[
                      _buildGuestMenuCard(),
                    ],

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            const _BottomNavigation(),
          ],
        ),
      ),
    );
  }

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
              onPressed: () {},
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

  Widget _buildLoggedInProfile() {
    return Column(
      children: [
        _buildAvatar(),

        const SizedBox(height: 16),

        Text(
          name ?? 'Pengguna',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        if (email != null && email!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            email!,
            style: const TextStyle(fontSize: 14, color: textSecondary),
          ),
        ],

        if (phone != null && phone!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            phone!,
            style: const TextStyle(fontSize: 14, color: textSecondary),
          ),
        ],
      ],
    );
  }

  Widget _buildGuestProfile(BuildContext context) {
    return Column(
      children: [
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

        const Text(
          'Tetamu',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Log masuk untuk melihat dan mengurus profil anda.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: textSecondary),
        ),

        const SizedBox(height: 18),

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
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFFE0E9F2),
                  alignment: Alignment.center,
                  child: const Icon(Icons.person, size: 55, color: primary),
                );
              },
            ),
          ),
        ),

        Positioned(
          right: -2,
          bottom: 0,
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
      ],
    );
  }

  Widget _buildMenuCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: surfaceLow),
      ),
      child: Column(
        children: [
          _ProfileMenuTile(
            icon: Icons.person_outline,
            title: 'Maklumat Peribadi',
            onTap: () {},
          ),
          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.favorite_border,
            title: 'Kegemaran Saya',
            onTap: () {},
          ),
          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.notifications_none,
            title: 'Notifikasi',
            onTap: () {},
          ),
          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.language,
            title: 'Bahasa',
            trailingText: 'Bahasa Melayu',
            onTap: () {},
          ),
          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan',
            onTap: () {},
          ),
          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.share_outlined,
            title: 'Kongsi Aplikasi',
            onTap: () {},
          ),
        ],
      ),
    );
  }

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
            onTap: () {},
          ),
          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.help_outline,
            title: 'Pusat Bantuan',
            onTap: () {},
          ),
          const _MenuDivider(),

          _ProfileMenuTile(
            icon: Icons.share_outlined,
            title: 'Kongsi Aplikasi',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
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
            Icon(icon, size: 24, color: ProfileScreen.outline),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: ProfileScreen.textColor,
                ),
              ),
            ),

            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 14,
                  color: ProfileScreen.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
            ],

            const Icon(
              Icons.chevron_right,
              size: 20,
              color: ProfileScreen.outlineVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 56,
      color: ProfileScreen.surfaceLow,
    );
  }
}

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
          _NavItem(
            icon: Icons.home_outlined,
            label: 'Utama',
            onTap: () {
              // Add /home route later
            },
          ),

          _NavItem(
            icon: Icons.location_on_outlined,
            label: 'Stesen',
            onTap: () {
              // Add /station route later
            },
          ),

          _NavItem(
            icon: Icons.calendar_month_outlined,
            label: 'Jadual',
            onTap: () {
              // Add /timetable route later
            },
          ),

          _NavItem(
            icon: Icons.notifications_none,
            label: 'Notifikasi',
            onTap: () {},
          ),

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
    final Color color = active ? ProfileScreen.primary : ProfileScreen.outline;

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
