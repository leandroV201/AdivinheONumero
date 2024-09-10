import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo do Número',
      home: NumberGameScreen(),
    );
  }
}

class NumberGameScreen extends StatefulWidget {
  @override
  _NumberGameScreenState createState() => _NumberGameScreenState();
}

class _NumberGameScreenState extends State<NumberGameScreen> {
  int _points = 0;
  int _numberLength = 1;
  String _randomNumber = '';
  bool _showNumber = false;
  bool _canAnswer = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateRandomNumber();
  }

  void _generateRandomNumber() {
    setState(() {
      _randomNumber = _generateNumber(_numberLength);
      _showNumber = true;
      _canAnswer = false; // Bloqueia a entrada de respostas enquanto o número está visível
    });

    // Número desaparece após 3 segundos
    Timer(const Duration(seconds: 2), () {
      setState(() {
        _showNumber = false;
        _canAnswer = true; // Permite a entrada de respostas após o número desaparecer
      });
    });
  }

  String _generateNumber(int length) {
    final random = Random();
    String number = '';
    for (int i = 0; i < length; i++) {
      number += random.nextInt(10).toString(); // Gera um número aleatório de 0 a 9
    }
    return number;
  }

  void _checkAnswer() {
    if (_controller.text == _randomNumber) {
      setState(() {
        _points += 10;
        _numberLength += 1;
      });
      _controller.clear();
      _generateRandomNumber();
    } else {
      // Se o usuário errar, redireciona para a tela de fim de jogo
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameOverScreen(points: _points),
        ),
      ).then((_) => _resetGame());
    }
  }

  void _resetGame() {
    setState(() {
      _points = 0;
      _numberLength = 1;
      _controller.clear();
      _generateRandomNumber();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adivinhe O Número'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_showNumber)
              Text(
                _randomNumber,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              )
            else
              Text('Qual foi o número que apareceu?'),
            SizedBox(height: 20),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Digite o número',
              ),
              enabled: _canAnswer, // Campo habilitado apenas após o número desaparecer
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _canAnswer ? _checkAnswer : null, // Botão habilitado apenas após o número desaparecer
              child: Text('Verificar'),
            ),
            SizedBox(height: 20),
            Text(
              'Pontos: $_points',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class GameOverScreen extends StatelessWidget {
  final int points;

  GameOverScreen({required this.points});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fim de Jogo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Você errou!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                'Pontuação Total: $points',
                style: TextStyle(fontSize: 24),
              ),
             const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Retorna para a tela principal
                },
                child:const Text('Tentar Novamente!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
