import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ControlePage extends StatefulWidget {
  const ControlePage({super.key});

  @override
  State<ControlePage> createState() => _ControlePageState();
}

class _ControlePageState extends State<ControlePage> {
  bool irrigacaoLigada = false;

  Future<void> alterarIrrigacao(bool valor) async {
    final sucesso = await ApiService.alterarIrrigacao(valor);

    if (sucesso) {
      setState(() {
        irrigacaoLigada = valor;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(valor ? 'Irrigação ligada' : 'Irrigação desligada'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle de Irrigação')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  irrigacaoLigada ? Icons.water : Icons.water_drop_outlined,
                  size: 80,
                  color: irrigacaoLigada ? Colors.green : Colors.grey,
                ),
                const SizedBox(height: 15),
                Text(
                  irrigacaoLigada ? 'Irrigação Ligada' : 'Irrigação Desligada',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                SwitchListTile(
                  title: const Text('Controle'),
                  value: irrigacaoLigada,
                  onChanged: alterarIrrigacao,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
