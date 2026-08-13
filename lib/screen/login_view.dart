import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../database/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ================================================================
  // CONTROLLERS
  // ================================================================

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  // ================================================================
  // COLORS
  // ================================================================

  static const Color primary = Color(0xFF031636);
  static const Color primaryContainer = Color(0xFF1A2B4C);

  static const Color onSurface = Color(0xFF141D23);
  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);

  static const Color secondaryFixedDim = Color(0xFFF1C048);

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // ================================================================
  // LOGIN
  // ================================================================

  Future<void> _login() async {
    final username = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sila masukkan email/no. telefon dan kata laluan.'),
        ),
      );

      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await DatabaseHelper.instance.loginUser(
        username: username,
        password: password,
      );

      if (!mounted) return;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email/no. telefon atau kata laluan tidak sah.'),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selamat datang, ${user['name']}!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to home page.
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ralat semasa log masuk: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ================================================================
  // FORGOT PASSWORD
  // ================================================================

  void _forgotPassword() {
    debugPrint('Forgot password');

    // TODO:
    // Navigate to forgot password screen.
  }

  // ================================================================
  // GOOGLE LOGIN
  // ================================================================

  void _googleLogin() {
    debugPrint('Google login');

    // TODO:
    // Implement Google Sign-In.
  }

  // ================================================================
  // REGISTER
  // ================================================================

  void _register() {
    debugPrint('Register');
    Navigator.pushNamed(context, '/register');

    // TODO:
    // Navigate to registration screen.
  }

  // ================================================================
  // MAIN BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double screenHeight = constraints.maxHeight;

            // Header will occupy around 40% of the screen.
            //
            // Minimum: 300
            // Maximum: 500
            //
            // This prevents the header from becoming too small
            // on mobile or too large on desktop/tablet.
            final double headerHeight = (screenHeight * 0.40).clamp(
              300.0,
              500.0,
            );

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: screenHeight),

                child: Column(
                  children: [
                    // ==================================================
                    // HEADER
                    // ==================================================
                    SizedBox(
                      width: double.infinity,
                      height: headerHeight,
                      child: _buildHeader(),
                    ),

                    // ==================================================
                    // LOGIN
                    // ==================================================
                    _buildLoginContainer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.2,
          colors: [primaryContainer, primary],
        ),
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;

          // ----------------------------------------------------------
          // RESPONSIVE PADDING
          // ----------------------------------------------------------

          final double horizontalPadding = width < 600
              ? 20
              : width < 1000
              ? 40
              : 80;

          // ----------------------------------------------------------
          // RESPONSIVE LOGO
          // ----------------------------------------------------------

          final double logoSize = width < 600
              ? 64
              : width < 1000
              ? 72
              : 80;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 24,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                // =====================================================
                // LOGO
                // =====================================================
                Container(
                  width: logoSize,
                  height: logoSize,

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,

                    border: Border.all(color: Colors.white, width: 2),
                  ),

                  child: Icon(
                    Icons.directions_transit,
                    color: Colors.white,
                    size: logoSize * 0.55,
                  ),
                ),

                SizedBox(height: height < 450 ? 8 : 16),

                // =====================================================
                // APP NAME
                // =====================================================
                FittedBox(
                  fit: BoxFit.scaleDown,

                  child: Text(
                    'JomzGerak',

                    textAlign: TextAlign.center,

                    style: GoogleFonts.plusJakartaSans(
                      fontSize: width < 600 ? 24 : 30,
                      fontWeight: FontWeight.w700,
                      color: secondaryFixedDim,
                    ),
                  ),
                ),

                SizedBox(height: height < 450 ? 4 : 8),

                // =====================================================
                // TAGLINE
                // =====================================================
                Text(
                  'Jadual Tepat, Stesen Dekat,\nPerjalanan Mudah.',

                  textAlign: TextAlign.center,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: GoogleFonts.plusJakartaSans(
                    fontSize: width < 600 ? 14 : 16,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),

                SizedBox(height: height < 450 ? 8 : 16),

                // =====================================================
                // TRANSPORT IMAGE
                // =====================================================
                Flexible(
                  child: SizedBox(
                    width: width < 600
                        ? width * 0.85
                        : width < 1000
                        ? width * 0.65
                        : 500,

                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBx8X4vossI4LgFWaNOIaF2IX04IoSxALyqLePESYZ8OUJP63ggrGWfueFqfXnWtnXmh9wJICsB-nSBYCKLSKbI9m4lcnEkd_EN1unqhQheT0XoWRTgAVwebUMSi987iXlj2jSCfpAFZ_2f-q-z91eQgIuLgP2wWZw1aQQAAudo4ngy_P20COR78AqKftX_-H8yN9gSBQI5tjGbi8-zUIbpRS0Y758DonRA8pFVM3GCWvne3nwLPRMC',

                      fit: BoxFit.contain,

                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.train,
                          size: logoSize,
                          color: Colors.white,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================================================================
  // LOGIN CONTAINER
  // ================================================================

  Widget _buildLoginContainer() {
    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),

      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;

          // ----------------------------------------------------------
          // FORM WIDTH
          // ----------------------------------------------------------

          final double formWidth = width > 600 ? 500 : width;

          // ----------------------------------------------------------
          // RESPONSIVE PADDING
          // ----------------------------------------------------------

          final double horizontalPadding = width < 600
              ? 20
              : width < 1000
              ? 40
              : 60;

          return Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                28,
                horizontalPadding,
                40,
              ),

              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: formWidth),

                child: _buildLoginForm(),
              ),
            ),
          );
        },
      ),
    );
  }

  // ================================================================
  // LOGIN FORM
  // ================================================================

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        // ============================================================
        // LOGIN TITLE
        // ============================================================
        Row(
          children: [
            const Icon(Icons.person_outline, color: onSurface, size: 24),

            const SizedBox(width: 8),

            Text(
              'Log Masuk',

              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        // ============================================================
        // EMAIL / PHONE
        // ============================================================
        _buildTextField(
          controller: emailController,
          hintText: 'Email atau No. Telefon',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 16),

        // ============================================================
        // PASSWORD
        // ============================================================
        _buildPasswordField(),

        const SizedBox(height: 10),

        // ============================================================
        // FORGOT PASSWORD
        // ============================================================
        TextButton(
          onPressed: _forgotPassword,

          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),

          child: Text(
            'Lupa kata laluan?',

            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ============================================================
        // LOGIN BUTTON
        // ============================================================
        SizedBox(
          width: double.infinity,
          height: 54,

          child: ElevatedButton(
            onPressed: _isLoading ? null : _login,

            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,

              elevation: 2,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Log Masuk',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 24),

        // ============================================================
        // OR DIVIDER
        // ============================================================
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: outlineVariant.withOpacity(0.5),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Text(
                'atau',

                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: outline,
                ),
              ),
            ),

            Expanded(
              child: Container(
                height: 1,
                color: outlineVariant.withOpacity(0.5),
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // ============================================================
        // GOOGLE LOGIN
        // ============================================================
        SizedBox(
          width: double.infinity,
          height: 52,

          child: OutlinedButton(
            onPressed: _googleLogin,

            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: onSurface,

              side: const BorderSide(color: outlineVariant),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                _buildGoogleIcon(),

                const SizedBox(width: 12),

                Flexible(
                  child: Text(
                    'Log masuk dengan Google',

                    overflow: TextOverflow.ellipsis,

                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),

        // ============================================================
        // REGISTER
        // ============================================================
        Center(
          child: Wrap(
            alignment: WrapAlignment.center,

            children: [
              Text(
                'Belum ada akaun? ',

                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: onSurface,
                ),
              ),

              GestureDetector(
                onTap: _register,

                child: Text(
                  'Daftar di sini',

                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================================================================
  // EMAIL / PHONE TEXT FIELD
  // ================================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,

      keyboardType: keyboardType,

      style: GoogleFonts.plusJakartaSans(fontSize: 16, color: onSurface),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          color: onSurface.withOpacity(0.4),
        ),

        // Use the icon passed to the function.
        prefixIcon: Icon(icon, color: outline),

        filled: true,

        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }

  // ================================================================
  // PASSWORD FIELD
  // ================================================================

  Widget _buildPasswordField() {
    return TextField(
      controller: passwordController,

      obscureText: _obscurePassword,

      style: GoogleFonts.plusJakartaSans(fontSize: 16, color: onSurface),

      decoration: InputDecoration(
        hintText: 'Kata Laluan',

        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          color: onSurface.withOpacity(0.4),
        ),

        // Password icon
        prefixIcon: const Icon(Icons.lock_outline, color: outline),

        // Show / hide password
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },

          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,

            color: outline,
          ),
        ),

        filled: true,

        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),

          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }

  // ================================================================
  // GOOGLE ICON
  // ================================================================

  Widget _buildGoogleIcon() {
    return Text(
      'G',

      style: GoogleFonts.plusJakartaSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF4285F4),
      ),
    );
  }
}
