import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Controladores dos campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Estado da aba selecionada (false = Entrar, true = Cadastrar)
  bool _isCadastrarSelected = true;

  // Cor principal do tema
  static const Color _primaryColor = Color(0xFF2563EB);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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

              // Campo NOME COMPLETO (Apenas visível se 'Cadastrar' estiver selecionado)
              if (_isCadastrarSelected) ...[
                _buildInputField(
                  label: 'NOME COMPLETO',
                  hintText: 'Seu nome completo',
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
              ],

              // Campo E-MAIL
              _buildInputField(
                label: 'E-MAIL',
                hintText: 'seu@email.com',
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              // Campo SENHA
              _buildInputField(
                label: 'SENHA',
                hintText: '••••••••',
                controller: _passwordController,
                isPassword: true,
              ),

              // Botão 'Esqueceu a senha?' (Apenas visível na aba 'Entrar')
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

  // --- Componentes da Interface ---

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
    return Column(
      children: const [
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
        onPressed: () {},
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
        onPressed: () {
          if (_isCadastrarSelected) {
            // Lógica de cadastro
          } else {
            // Lógica de login
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
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