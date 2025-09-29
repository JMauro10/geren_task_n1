
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geren_task_n1/welcome.dart'; 

// Definindo os construtores da classe
class StepData {
  final String imagePath;
  final String title;
  final String subtitle;

  StepData({required this.imagePath, required this.title, required this.subtitle});
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentStep = 0;

  // Cores do ttela
  static const Color darkBackground = Color(0xFF1E1E1E); 
  static const Color textLight = Color(0xFFE0E0E0);      
  static const Color textMedium = Color(0xFFC0C0C0);     
  static const Color textAccent = Color(0xFF9E9E9E);    
  static const Color purpleButton = Color(0xFF8A2BE2); 
  static const Color inactiveDot = Color(0xFF4D4D4D); 

  // Definição de cada tela baseado no construtor criado
  final List<StepData> _onboardingSteps = [
    StepData(
      imagePath: 'assets/images/onboard-001.png', 
      title: 'Organize suas tarefas',
      subtitle: 'Você pode organizar suas tarefas diárias adicionando-as em categorias separadas.',
    ),
    StepData(
      imagePath: 'assets/images/onboard-002.png',
      title: 'Colabore em equipe',
      subtitle: 'Trabalhe em conjunto com sua equipe e atinjam resultados incríveis.',
    ),
    StepData(
      imagePath: 'assets/images/onboard-003.png',
      title: 'Alcance seus objetivos',
      subtitle: 'Com ferramentas intuitivas, seus objetivos estão ao seu alcance.',
    ),
  ];

  void _nextStep() {
    if (_currentStep < _onboardingSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Navegação para a tela de login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Welcome()));
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent, 
      statusBarIconBrightness: Brightness.light, 
      statusBarBrightness: Brightness.dark,      
    ));
  }

  @override
  Widget build(BuildContext context) {
    final currentStepData = _onboardingSteps[_currentStep];

    return Scaffold(
      backgroundColor: darkBackground, 
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botão do SKIP no canto direito em cima
              Align(
                alignment: Alignment.topRight,
                child: _currentStep < _onboardingSteps.length - 1
                    ? GestureDetector(
                        onTap: () {
                          // Navegção direta para a tela de login
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Welcome()));
                        },
                        child: Text(
                          'SKIP',
                          style: TextStyle(color: textAccent, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )
                    : const SizedBox.shrink(), 
              ),
              const SizedBox(height: 20),

              
              Image.asset(
                currentStepData.imagePath,
                height: MediaQuery.of(context).size.height * 0.35, 
                fit: BoxFit.contain, // Garante que a imagem caiba sem cortar
              ),
              const SizedBox(height: 40),

              
              Text(
                currentStepData.title,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                currentStepData.subtitle,
                style: TextStyle(fontSize: 16, color: textMedium),
                textAlign: TextAlign.center,
              ),
              const Spacer(), 

              // Indicadores da barra de navegação onboarding
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_onboardingSteps.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentStep == index ? 25 : 12,
                    height: 3,
                    decoration: BoxDecoration(
                      color: _currentStep == index ? textAccent : inactiveDot, 
                      borderRadius: BorderRadius.circular(1.5), 
                    ),
                  );
                }),
              ),
              const SizedBox(height: 40), 

              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _currentStep == 0 ? null : _previousStep,
                    child: Text(
                      'Voltar',
                      style: TextStyle(
                        color: _currentStep == 0 ? inactiveDot : textAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleButton,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _currentStep == _onboardingSteps.length - 1 ? 'FINALIZAR' : 'PRÓXIMO',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}