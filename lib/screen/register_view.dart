import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jomzgerak/database/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ================================================================
  // CONTROLLERS
  // ================================================================

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // ================================================================
  // STATE
  // ================================================================

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false; // shows spinner on the button while inserting

  // ================================================================
  // COLORS
  // ================================================================

  static const Color primary = Color(0xFF031636);
  static const Color primaryContainer = Color(0xFF1A2B4C);

  static const Color background = Color(0xFFF6FAFF);
  static const Color surface = Color(0xFFF6FAFF);

  static const Color surfaceContainerLow = Color(0xFFECF5FE);
  static const Color surfaceContainerHigh = Color(0xFFE0E9F2);

  static const Color onSurface = Color(0xFF141D23);
  static const Color onSurfaceVariant = Color(0xFF44474E);

  static const Color outline = Color(0xFF75777F);
  static const Color outlineVariant = Color(0xFFC5C6CF);

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // ================================================================
  // REGISTER
  // ================================================================

  Future<void> _register() async {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String phone = _phoneController.text.trim();
    final String password = _passwordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    // ================================================================
    // VALIDATION
    // ================================================================

    if (name.isEmpty) {
      _showMessage('Sila masukkan nama penuh.');
      return;
    }

    if (email.isEmpty) {
      _showMessage('Sila masukkan email.');
      return;
    }

    if (phone.isEmpty) {
      _showMessage('Sila masukkan no. telefon.');
      return;
    }

    if (password.isEmpty) {
      _showMessage('Sila masukkan kata laluan.');
      return;
    }

    if (confirmPassword.isEmpty) {
      _showMessage('Sila sahkan kata laluan.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Kata laluan dan pengesahan kata laluan tidak sama.');
      return;
    }

    if (!_agreeToTerms) {
      _showMessage('Sila bersetuju dengan Terma & Syarat dan Polisi Privasi.');
      return;
    }

    // ================================================================
    // START LOADING
    // ================================================================

    setState(() {
      _isLoading = true;
    });

    try {
      // ================================================================
      // CHECK EMAIL
      // ================================================================

      final bool alreadyExists = await DatabaseHelper.instance.emailExists(
        email,
      );

      if (!mounted) return;

      if (alreadyExists) {
        setState(() {
          _isLoading = false;
        });

        _showMessage('Email ini telah didaftarkan. Sila log masuk.');

        return;
      }

      // ================================================================
      // INSERT USER INTO SQLITE
      // ================================================================

      final int newUserId = await DatabaseHelper.instance.registerUser(
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      // ================================================================
      // REGISTRATION SUCCESS
      // ================================================================

      if (newUserId > 0) {
        debugPrint('================================');
        debugPrint('REGISTRATION SUCCESS');
        debugPrint('================================');
        debugPrint('User ID: $newUserId');
        debugPrint('Name: $name');
        debugPrint('Email: $email');
        debugPrint('Phone: $phone');
        debugPrint('================================');

        _showMessage('Pendaftaran berjaya. Sila log masuk.');

        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/login');

        return;
      }

      // ================================================================
      // EMAIL DUPLICATE
      // ================================================================

      if (newUserId == -1) {
        _showMessage('Email ini telah didaftarkan. Sila log masuk.');

        return;
      }

      // ================================================================
      // DATABASE ERROR
      // ================================================================

      if (newUserId == -2) {
        _showMessage('Ralat pangkalan data. Sila cuba lagi.');

        return;
      }

      // ================================================================
      // UNKNOWN ERROR
      // ================================================================

      _showMessage('Pendaftaran gagal. Sila cuba lagi.');
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      debugPrint('Registration error: $e');

      _showMessage('Ralat berlaku semasa pendaftaran.');
    }
  }

  // ================================================================
  // SHOW MESSAGE
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
  // BACK
  // ================================================================

  void _goBack() {
    Navigator.pop(context);
  }

  // ================================================================
  // LOGIN
  // ================================================================

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  // ================================================================
  // TERMS
  // ================================================================

  void _showTerms() {
    debugPrint('Terms & Conditions');

    // TODO:
    // Navigate to Terms & Conditions page.
  }

  // ================================================================
  // PRIVACY
  // ================================================================

  void _showPrivacy() {
    debugPrint('Privacy Policy');

    // TODO:
    // Navigate to Privacy Policy page.
  }

  // ================================================================
  // MAIN BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;

            final double horizontalPadding = width < 600
                ? 20
                : width < 1000
                ? 40
                : 60;

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Center(
                  child: Container(
                    width: double.infinity,

                    constraints: const BoxConstraints(maxWidth: 600),

                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      0,
                      horizontalPadding,
                      32,
                    ),

                    child: Column(
                      children: [
                        _buildHeader(),
                        _buildAvatar(),

                        const SizedBox(height: 24),

                        _buildRegistrationForm(),

                        const SizedBox(height: 32),

                        _buildLoginLink(),
                      ],
                    ),
                  ),
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
    return SizedBox(
      height: 64,

      child: Row(
        children: [
          IconButton(
            onPressed: _goBack,

            padding: EdgeInsets.zero,

            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),

            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: primary,
              size: 20,
            ),
          ),

          Expanded(
            child: Text(
              'Daftar Akaun',

              textAlign: TextAlign.center,

              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: primary,
              ),
            ),
          ),

          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ================================================================
  // AVATAR
  // ================================================================

  Widget _buildAvatar() {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 8),

      width: 112,
      height: 112,

      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: surfaceContainerHigh,

        border: Border.all(color: primary.withOpacity(0.10), width: 2),

        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),

      child: ClipOval(
        child: Image.network(
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDSWM_dnYEUS-okz6ePhMDJkUY16J-QF1VvqMYnZ7CQovJK1Q9WqmSKIdLEouLAu6EtNs2tIYwVrkfBlo9Vp6Ad2_0Z61Q-NMkGCA9nr4wLDUpUmJ2h4RKG9xwIY5hJfzMADDvf6qdw0VN2lYzlzuHVomwXO_gaBq4cP-8WQlMl_9CmagjVXgwKANXdr4mqVHpuzGCHq0_JWzPfmfI_8hVqe7PRWqPZrxC1N5mcPZ0esPA5MrSzaPsY',

          fit: BoxFit.cover,

          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.directions_transit,
              color: primary,
              size: 52,
            );
          },
        ),
      ),
    );
  }

  // ================================================================
  // REGISTRATION FORM
  // ================================================================

  Widget _buildRegistrationForm() {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          hintText: 'Nama Penuh',
          icon: Icons.person_outline,
          textInputType: TextInputType.name,
        ),

        const SizedBox(height: 16),

        _buildTextField(
          controller: _emailController,
          hintText: 'Email',
          icon: Icons.mail_outline,
          textInputType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 16),

        _buildTextField(
          controller: _phoneController,
          hintText: 'No. Telefon',
          icon: Icons.call_outlined,
          textInputType: TextInputType.phone,
        ),

        const SizedBox(height: 16),

        _buildPasswordField(
          controller: _passwordController,
          hintText: 'Kata Laluan',
          obscureText: _obscurePassword,
          onToggle: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),

        const SizedBox(height: 16),

        _buildPasswordField(
          controller: _confirmPasswordController,
          hintText: 'Sahkan Kata Laluan',
          obscureText: _obscureConfirmPassword,
          onToggle: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),

        const SizedBox(height: 12),

        _buildTerms(),

        const SizedBox(height: 24),

        // ----------------------------------------------------------
        // REGISTER BUTTON (disabled + spinner while inserting)
        // ----------------------------------------------------------
        SizedBox(
          width: double.infinity,
          height: 56,

          child: ElevatedButton(
            onPressed: _isLoading ? null : _register,

            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,

              elevation: 3,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            child: _isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    'Daftar',

                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // NORMAL TEXT FIELD
  // ================================================================

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType textInputType,
  }) {
    return TextField(
      controller: controller,

      keyboardType: textInputType,

      textInputAction: TextInputAction.next,

      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: outline,
        ),

        prefixIcon: Icon(icon, color: outline, size: 22),

        filled: true,

        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: const BorderSide(color: outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
      ),
    );
  }

  // ================================================================
  // PASSWORD FIELD
  // ================================================================

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,

      obscureText: obscureText,

      textInputAction: TextInputAction.next,

      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: outline,
        ),

        prefixIcon: const Icon(Icons.lock_outline, color: outline, size: 22),

        suffixIcon: IconButton(
          onPressed: onToggle,

          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,

            color: outline,
            size: 21,
          ),
        ),

        filled: true,

        fillColor: Colors.white,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: const BorderSide(color: outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),

          borderSide: const BorderSide(color: primary, width: 1.2),
        ),
      ),
    );
  }

  // ================================================================
  // TERMS & CONDITIONS
  // ================================================================

  Widget _buildTerms() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(
          width: 24,
          height: 24,

          child: Checkbox(
            value: _agreeToTerms,

            activeColor: primary,

            checkColor: Colors.white,

            side: const BorderSide(color: outlineVariant),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),

            onChanged: (value) {
              setState(() {
                _agreeToTerms = value ?? false;
              });
            },
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Wrap(
            children: [
              Text(
                'Saya bersetuju dengan ',

                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.4,
                  color: onSurfaceVariant,
                ),
              ),

              GestureDetector(
                onTap: _showTerms,

                child: Text(
                  'Terma & Syarat',

                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primary,
                    height: 1.4,
                  ),
                ),
              ),

              Text(
                ' dan ',

                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: onSurfaceVariant,
                  height: 1.4,
                ),
              ),

              GestureDetector(
                onTap: _showPrivacy,

                child: Text(
                  'Polisi Privasi',

                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: primary,
                    height: 1.4,
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
  // LOGIN LINK
  // ================================================================

  Widget _buildLoginLink() {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,

        children: [
          Text(
            'Sudah ada akaun? ',

            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: onSurfaceVariant,
            ),
          ),

          GestureDetector(
            onTap: _goToLogin,

            child: Text(
              'Log masuk di sini',

              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}