import 'package:flutter/material.dart';
// Importe o pacote de ícones Font Awesome
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/*
  ============================================================================
  INSTRUÇÕES PARA O CÓDIGO FUNCIONAR 100% (LEIA COM ATENÇÃO)
  ============================================================================

  PASSO 1: ADICIONAR PACOTE DE ÍCONES E IMAGEM DO LOGO

  Abra o arquivo `pubspec.yaml` e adicione as seguintes linhas, garantindo
  que a indentação (espaços) esteja correta:

  dependencies:
    flutter:
      sdk: flutter
    font_awesome_flutter: ^10.7.0

  flutter:
    uses-material-design: true
    assets:
      - assets/imagens/      # <--- CORRIGIDO PARA "imagens"

  PASSO 2: REINICIAR O APP COMPLETAMENTE

  PARE COMPLETAMENTE A EXECUÇÃO DO SEU APP E RODE DE NOVO.
  Um "Hot Reload" não é suficiente. Você precisa clicar no botão "Stop" (■)
  e depois no "Run" (▶) novamente.

  ============================================================================
*/

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // A tela inicial do app agora é a SplashScreen
      home: SplashScreen(),
    ),
  );
}

// --- NOVA TELA DE SPLASH ---
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        // O GestureDetector faz a tela inteira ser clicável
        onTap: () {
          // Navega para a HomePage, substituindo a SplashScreen na pilha
          // para que o usuário não possa voltar para ela.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            // Gradiente radial para simular o brilho no centro, como na imagem
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.7,
              colors: [
                Color(0xFF5b3a7e), // Cor mais clara no centro
                Color(0xFF2c0e4d), // Cor mais escura nas bordas
              ],
            ),
          ),
          child: Center(
            // Adiciona a imagem do logo a partir dos assets do projeto
            child: Image.asset(
              // ===== CAMINHO DA IMAGEM CORRIGIDO AQUI =====
              'assets/imagens/logo_itech.png',
              width: MediaQuery.of(context).size.width *
                  0.6, // 60% da largura da tela
            ),
          ),
        ),
      ),
    );
  }
}

// --- TELA DE LOGIN ---
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.purple[900]!, // Roxo mais escuro em cima
              Colors.purple[300]!, // Roxo mais claro para um degradê mais forte
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Bem vindo Novamente!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Não tem uma conta?",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                            ),
                            SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CadastroPage()),
                                );
                              },
                              child: Text(
                                "Cadastre-se",
                                style: TextStyle(
                                  color: Colors.purple[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFA626A6).withOpacity(0.2),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey[200]!))),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    hintText: "Digite aqui seu email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: "Senha",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                        ),
                        SizedBox(height: 40),
                        Text("Esqueci a Senha?",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 40),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.purple[800]),
                          child: Center(
                            child: Text("Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: 50),
                        Text("Continue com midias sociais",
                            style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 20),
                        _buildSocialBtn(
                          onTap: () => print('Login com Facebook'),
                          icon: FontAwesomeIcons.facebook,
                          label: 'Facebook',
                          color: Color(0xFF3b5998),
                        ),
                        SizedBox(height: 15),
                        _buildSocialBtn(
                          onTap: () => print('Login com Github'),
                          icon: FontAwesomeIcons.github,
                          label: 'Github',
                          color: Colors.black,
                        ),
                        SizedBox(height: 15),
                        _buildSocialBtn(
                          onTap: () => print('Login com Google'),
                          icon: FontAwesomeIcons.google,
                          label: 'Google',
                          color: Colors.white,
                          textColor: Colors.black,
                          hasBorder: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialBtn({
    required Function onTap,
    required IconData icon,
    required String label,
    required Color color,
    Color textColor = Colors.white,
    bool hasBorder = false,
  }) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          border: hasBorder ? Border.all(color: Colors.grey[300]!) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor, size: 20),
              SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- TELA DE CADASTRO ---
class CadastroPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.purple[900]!, // Roxo mais escuro em cima
                    Colors.purple[
                        300]!, // Roxo mais claro para um degradê mais forte
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, left: 10.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cadastro',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Crie sua conta',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 40),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFFA626A6).withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  _buildTextField(hint: "Nome completo"),
                                  _buildTextField(
                                      hint: "E-mail",
                                      inputType: TextInputType.emailAddress),
                                  _buildTextField(hint: "Senha", obscure: true),
                                  _buildTextField(
                                      hint: "Data de Nascimento (DD/MM/AAAA)",
                                      inputType: TextInputType.datetime,
                                      isLast: true),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            Container(
                              height: 50,
                              margin: EdgeInsets.symmetric(horizontal: 50),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.purple[800],
                              ),
                              child: Center(
                                child: Text(
                                  "Cadastrar",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String hint,
      TextInputType inputType = TextInputType.text,
      bool obscure = false,
      bool isLast = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: TextField(
        obscureText: obscure,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
