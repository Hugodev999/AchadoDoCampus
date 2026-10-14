import 'package:flutter/material.dart';
import 'app_database.dart';
import 'home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isCadastrarSelected = false; // Começa na aba Entrar para facilitar o teste
  bool _isLoading = false;
  final AppDatabase _db = AppDatabase();

  static const Color _primaryColor = Color(0xFF2563EB);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitAuth() async {
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Preencha todos os campos obrigatórios.', Colors.red);
      return;
    }

    if (_isCadastrarSelected && name.isEmpty) {
      _showSnackBar('Por favor, informe seu nome completo.', Colors.red);
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    if (_isCadastrarSelected) {
      bool success = _db.registerUser(email, password, name);

      setState(() => _isLoading = false);

      if (!success) {
        _showSnackBar('Este e-mail já está cadastrado.', Colors.red);
        return;
      }

      _showSnackBar('Conta criada com sucesso! Faça login.', Colors.green);
      setState(() {
        _isCadastrarSelected = false;
        _passwordController.clear();
      });
    } else {
      bool success = _db.loginUser(email, password);

      setState(() => _isLoading = false);

      if (!success) {
        _showSnackBar('E-mail ou senha incorretos.', Colors.red);
        return;
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userEmail: email),
        ),
      );
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildHeaderIcon(),
              const SizedBox(height: 16),
              _buildTitleSection(),
              const SizedBox(height: 28),
              _buildTabSelector(),
              const SizedBox(height: 24),
              if (_isCadastrarSelected) ...[
                _buildInputField(
                  label: 'NOME COMPLETO',
                  hintText: 'Seu nome completo',
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
              ],
              _buildInputField(
                label: 'E-MAIL',
                hintText: 'teste@email.com',
                controller: _emailController,
              ),
              const SizedBox(height: 20),
              _buildInputField(
                label: 'SENHA',
                hintText: '••••••••',
                controller: _passwordController,
                isPassword: true,
              ),
              if (!_isCadastrarSelected) ...[
                const SizedBox(height: 8),
                _buildForgotPasswordButton(),
              ],
              const SizedBox(height: 24),
              _buildSubmitButton(),
              const SizedBox(height: 20),
              _buildToggleAuthLink(),
              const SizedBox(height: 40),
              _buildFooter(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.school_outlined,
          color: Colors.black87,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return const Column(
      children: [
        Text(
          'Achados do Campus',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Conectando quem perdeu com quem encontrou',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildTabSelector() {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTabOption(
            title: 'Entrar',
            isSelected: !_isCadastrarSelected,
            onTap: () => setState(() => _isCadastrarSelected = false),
          ),
          _buildTabOption(
            title: 'Cadastrar',
            isSelected: _isCadastrarSelected,
            onTap: () => setState(() => _isCadastrarSelected = true),
          ),
        ],
      ),
    );
  }

  Widget _buildTabOption({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? _primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          _showSnackBar('Dica: Use teste@email.com e 123456', Colors.blue);
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Esqueceu a senha?',
          style: TextStyle(
            color: _primaryColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitAuth,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                _isCadastrarSelected ? 'CRIAR CONTA' : 'ENTRAR',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
      ),
    );
  }

  Widget _buildToggleAuthLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _isCadastrarSelected ? 'Já tem conta? ' : 'Não possui conta? ',
          style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isCadastrarSelected = !_isCadastrarSelected;
            });
          },
          child: Text(
            _isCadastrarSelected ? 'Entrar' : 'Cadastre-se',
            style: const TextStyle(
              color: _primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Text(
      'UnDF — Universidade do Distrito Federal',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFCBD5E1),
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}