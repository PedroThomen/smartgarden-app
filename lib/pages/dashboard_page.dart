import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'controle_page.dart';
import 'relatorio_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String umidade = 'Carregando...';

  Future<void> carregarLeituras() async {
    final dados = await ApiService.buscarLeituras();

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

  @override
  void initState() {
    super.initState();
    carregarLeituras();
  }

  Widget cardInfo(String titulo, String valor, IconData icone) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: ListTile(
        leading: Icon(icone, color: Colors.green, size: 36),
        title: Text(titulo),
        subtitle: Text(
          valor,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard SmartGarden')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          cardInfo('Umidade Atual', umidade, Icons.water_drop),
          cardInfo('Status do Sistema', 'Online', Icons.cloud_done),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.power_settings_new),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ControlePage()),
                      );
                    },
                    label: const Text('Controle de Irrigação'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.bar_chart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RelatorioPage(),
                        ),
                      );
                    },
                    label: const Text('Relatórios'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
