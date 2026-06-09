import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://localhost:8080';

void main() {
  runApp(const SmartGardenApp());
}

class SmartGardenApp extends StatelessWidget {
  const SmartGardenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartGarden',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'senha': senhaController.text,
      }),
    );

    if (response.body.contains('Login realizado com sucesso')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response.body)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SmartGarden - Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text('Entrar')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CadastroPage()),
                );
              },
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  Future<void> cadastrar() async {
    final response = await http.post(
      Uri.parse('$apiUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nomeController.text,
        'email': emailController.text,
        'senha': senhaController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário cadastrado com sucesso')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao cadastrar usuário')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Senha'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: cadastrar,
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String umidade = 'Carregando...';

  Future<void> carregarLeituras() async {
    final response = await http.get(Uri.parse('$apiUrl/leituras'));

    if (response.statusCode == 200) {
      final List dados = jsonDecode(response.body);

      if (dados.isNotEmpty) {
        setState(() {
          umidade = '${dados.last['umidade']}%';
        });
      } else {
        setState(() {
          umidade = 'Sem leituras';
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    carregarLeituras();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Umidade Atual', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            Text(
              umidade,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ControlePage()),
                );
              },
              child: const Text('Controle de Irrigação'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RelatorioPage()),
                );
              },
              child: const Text('Relatórios'),
            ),
          ],
        ),
      ),
    );
  }
}

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  bool irrigacaoLigada = false;

  Future<void> alterarIrrigacao(bool valor) async {
    final response = await http.post(
      Uri.parse('$apiUrl/irrigacoes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ligada': valor}),
    );

    if (response.statusCode == 200) {
      setState(() {
        irrigacaoLigada = valor;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Irrigação')),
      body: Center(
        child: SwitchListTile(
          title: const Text('Irrigação'),
          subtitle: Text(irrigacaoLigada ? 'Ligada' : 'Desligada'),
          value: irrigacaoLigada,
          onChanged: alterarIrrigacao,
        ),
      ),
    );
  }
}

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  Map<String, dynamic> relatorio = {};

  Future<void> carregarRelatorio() async {
    final response = await http.get(Uri.parse('$apiUrl/relatorios'));

    if (response.statusCode == 200) {
      setState(() {
        relatorio = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carregarRelatorio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: relatorio.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  ListTile(
                    title: const Text('Média de Umidade'),
                    trailing: Text('${relatorio['mediaUmidade']}%'),
                  ),
                  ListTile(
                    title: const Text('Máxima Umidade'),
                    trailing: Text('${relatorio['maximaUmidade']}%'),
                  ),
                  ListTile(
                    title: const Text('Mínima Umidade'),
                    trailing: Text('${relatorio['minimaUmidade']}%'),
                  ),
                  ListTile(
                    title: const Text('Total de Irrigações'),
                    trailing: Text('${relatorio['totalIrrigacoes']}'),
                  ),
                ],
              ),
      ),
    );
  }
}
