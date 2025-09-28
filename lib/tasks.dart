import 'package:flutter/material.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();

  
}

class _TasksState extends State<Tasks> {
  final List<Map<String, String>> _tasks = [];

  
  // Função para abrir o modal de adicionar tarefa
  void _showAddTaskModal(BuildContext context) {

    
    String taskName = "";
    String description = "";

    void _addTask(String name, String desc) {
  setState(() {
    _tasks.add({'name': name, 'desc': desc});
  });
}


    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF232229),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Adicionar Tarefa",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2D2C33),
                      hintText: "Nome da tarefa",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() => taskName = value),
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Descrição",
                    style: TextStyle(fontSize: 16, color: Colors.white60),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    minLines: 3,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2D2C33),
                      hintText: "Digite aqui os detalhes...",
                      hintStyle: TextStyle(color: Colors.white54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) => setState(() => description = value),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.access_time, color: Colors.white70),
                        onPressed: () {}, // ação de horário
                      ),
                      IconButton(
                        icon: const Icon(Icons.label_outline, color: Colors.white70),
                        onPressed: () {}, // ação adicionar tag
                      ),
                      IconButton(
                        icon: const Icon(Icons.flag_outlined, color: Colors.white70),
                        onPressed: () {}, // ação flag/prioridade
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          if (taskName.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('Informe o nome da tarefa!'),
                              backgroundColor: Colors.redAccent,
                            ));
                            return;
                          }
                          // Aqui você pode salvar a tarefa
                          setState(() { // Este setState é do _TasksState, para atualizar a tela principal
                            _tasks.add({
                              'name': taskName,
                              'description': description,
                            });
                          });
                          Navigator.of(context).pop(); // Fecha o modal
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B5EC0),
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(14),
                          elevation: 0,
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF7B5EC0),
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu, size: 28),
            onPressed: () {
              // ação do menu
            },
          ),
          title: const Text('Tarefas'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/images/1-1.png'),
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/zeroitens.png',
                height: 220,
                width: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 42),
              const Text(
                'O que você quer fazer hoje?',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Toque em + para adicionar as suas tarefas.',
                style: TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskModal(context);
          },
          child: const Icon(
            Icons.add,
            size: 32,
          ),
          tooltip: 'Adicionar nova tarefa',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}