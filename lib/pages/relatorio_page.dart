import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RelatorioPage extends StatefulWidget {
  const RelatorioPage({super.key});

  @override
  State<RelatorioPage> createState() => _RelatorioPageState();
}

class _RelatorioPageState extends State<RelatorioPage> {
  Map<String, dynamic> relatorio = {};

  Future<void> carregarRelatorio() async {
    final dados = await ApiService.buscarRelatorio();

    setState(() {
      relatorio = dados;
    });
  }

  @override
  void initState() {
    super.initState();
    carregarRelatorio();
  }

  Widget itemRelatorio(String titulo, String valor, IconData icone) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icone, color: Colors.green),
        title: Text(titulo),
        trailing: Text(
          valor,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = relatorio['mediaUmidade'] ?? 0;
    final maxima = relatorio['maximaUmidade'] ?? 0;
    final minima = relatorio['minimaUmidade'] ?? 0;
    final total = relatorio['totalIrrigacoes'] ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: relatorio.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  itemRelatorio('Média de Umidade', '$media%', Icons.analytics),
                  itemRelatorio(
                    'Máxima Umidade',
                    '$maxima%',
                    Icons.arrow_upward,
                  ),
                  itemRelatorio(
                    'Mínima Umidade',
                    '$minima%',
                    Icons.arrow_downward,
                  ),
                  itemRelatorio('Total de Irrigações', '$total', Icons.water),
                ],
              ),
      ),
    );
  }
}
