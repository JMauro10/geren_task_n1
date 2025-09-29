import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'category.dart';
import 'task.dart';



// --- Lista de Ícones e Cores Pré-definidos ---
final List<IconData> _availableIcons = [
  Icons.work, Icons.person, Icons.school, Icons.category,
  Icons.home, Icons.shopping_cart, Icons.fitness_center, Icons.travel_explore,
  Icons.lightbulb, Icons.health_and_safety, Icons.restaurant, Icons.event,
  Icons.favorite, Icons.star, Icons.check_box, Icons.book,
  Icons.code, Icons.build, Icons.directions_run, Icons.flight,
];

final List<Color> _availableColors = [
  Colors.blue, Colors.green, Colors.red, Colors.orange,
  Colors.purple, Colors.teal, Colors.brown, Colors.pink,
  Colors.indigo, Colors.amber, Colors.cyan, Colors.deepOrange,
  Colors.lightGreen, Colors.deepPurple,
];

// --- Widget Principal ---
class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  List<Task> tasks = [];
  List<Category> _categories = [];
  final List<String> priorities = ['Alta', 'Média', 'Baixa'];

  @override
  void initState() {
    super.initState();
    // Inicializa com algumas categorias padrão
    _categories.add(Category(name: 'Trabalho', icon: Icons.work, color: Colors.blue));
    _categories.add(Category(name: 'Pessoal', icon: Icons.person, color: Colors.green));
    _categories.add(Category(name: 'Estudos', icon: Icons.school, color: Colors.orange));
    _categories.add(Category(name: 'Outros', icon: Icons.category, color: Colors.grey));
    
    // Adiciona uma tarefa de exemplo para que a lista não comece vazia
    tasks.add(Task(
      title: 'Configurar sua tarefa teste',
      description: 'Edite essa tarefa para ser sua primeira',
      dateTime: DateTime.now().add(Duration(hours: 2)),
      priority: 'Alta',
      category: _categories[0], // Categoria Trabalho
    ));
    tasks.add(Task(
      title: 'Configurar sua segunda tarefa teste',
      description: 'Edite essa tarefa para ser sua segunda',
      dateTime: DateTime.now().add(Duration(minutes: 30)),
      priority: 'Média',
      category: _categories[1], // Categoria Pessoal
      isCompleted: true,
    ));
  }

  // --- Funções para Gerenciar Tarefas ---
  void _addTask(Task task) {
    setState(() => tasks.add(task));
  }

  void _editTask(int index, Task newTask) {
    setState(() => tasks[index] = newTask);
  }

  void _removeTask(int index) {
    setState(() => tasks.removeAt(index));
  }

  // --- Funções para Gerenciar Categorias ---
  void _addCategory(Category category) {
    setState(() => _categories.add(category));
  }

  void _editCategory(int index, Category newCategory) {
    setState(() {
      // Atualiza a categoria na lista
      _categories[index] = newCategory;
      // Atualiza todas as tarefas que usam a categoria antiga para a nova
      for (var task in tasks) {
        if (task.category.name == newCategory.name) { // Compara pelo nome ou outro identificador único
          task.category = newCategory;
        }
      }
    });
  }

  void _removeCategory(Category categoryToRemove) {
    setState(() {
      // Remove a categoria da lista
      _categories.removeWhere((c) => c == categoryToRemove);
      // Remove tarefas associadas ou as move para uma categoria padrão
      tasks.removeWhere((t) => t.category == categoryToRemove);
      // Opcional: atribuir a uma categoria padrão se a tarefa não for removida
      // if (_categories.isNotEmpty) {
      //   tasks.where((t) => t.category == categoryToRemove).forEach((t) => t.category = _categories.first);
      // }
    });
  }

  // --- Modais ---

  // Modal para Adicionar/Editar Categoria
  void _showAddEditCategoryModal({Category? category, int? index}) {
    final nameController = TextEditingController(text: category?.name ?? '');
    IconData selectedIcon = category?.icon ?? _availableIcons.first;
    Color selectedColor = category?.color ?? _availableColors.first;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category == null ? 'Nova Categoria' : 'Editar Categoria',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nome da Categoria'),
                ),
                SizedBox(height: 20),
                Text('Ícone:'),
                SizedBox(height: 8),
                SizedBox( // Usado para limitar a altura da grade de ícones
                  height: 100, // Altura fixa, pode ajustar
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableIcons.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 ícones por coluna
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (ctx, i) {
                      final icon = _availableIcons[i];
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedIcon = icon),
                        child: CircleAvatar(
                          backgroundColor: selectedIcon == icon ? Theme.of(context).primaryColor : Colors.grey[300],
                          child: Icon(icon, color: selectedIcon == icon ? Colors.white : Colors.black),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                Text('Cor:'),
                SizedBox(height: 8),
                SizedBox( // Usado para limitar a altura da grade de cores
                  height: 50, // Altura fixa, pode ajustar
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableColors.length,
                    itemBuilder: (ctx, i) {
                      final color = _availableColors[i];
                      return GestureDetector(
                        onTap: () => setModalState(() => selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: selectedColor == color
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final String name = nameController.text.trim();
                    if (name.isEmpty) return;

                    final newCat = Category(name: name, icon: selectedIcon, color: selectedColor);
                    if (category == null) {
                      _addCategory(newCat);
                    } else if (index != null) {
                      _editCategory(index, newCat);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(category == null ? 'Adicionar Categoria' : 'Salvar Categoria'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modal para Adicionar/Editar Tarefa
  void _showTaskModal({Task? task, int? index}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descController = TextEditingController(text: task?.description ?? '');
    DateTime selectedDateTime = task?.dateTime ?? DateTime.now();
    String selectedPriority = task?.priority ?? priorities.first;
    Category selectedCategory = task?.category ?? _categories.first; // Usa o objeto Category

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF20202C), // Fundo escuro para o modal
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  task == null ? 'Nova Tarefa' : 'Editar Tarefa',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    labelStyle: const TextStyle(color: Colors.white70),
                    ),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                     labelStyle: const TextStyle(color: Colors.white70),
                    ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text("Data/Hora: ", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    Text(DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.calendar_today, color: Colors.deepPurpleAccent),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDateTime,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                primary: Colors.deepPurpleAccent, // Cor para seleção
                                onPrimary: Colors.white,         // Cor do texto selecionado
                                surface: Color(0xFF20202C),      // Fundo do calendário
                                onSurface: Colors.white,         // Texto do calendário
                              ),
                              dialogBackgroundColor: const Color(0xFF20202C), // Fundo do dialog
                            ),
                            child: child!,
                        ));
                        if (pickedDate != null) {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                              builder: (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Colors.deepPurpleAccent, // Cor para seleção
                                  onPrimary: Colors.white,         // Cor do texto selecionado
                                  surface: Color(0xFF20202C),      // Fundo do TimePicker
                                  onSurface: Colors.white,         // Texto do TimePicker
                                ),
                                dialogBackgroundColor: const Color(0xFF20202C), // Fundo do dialog
                              ),
                              child: child!,
                            ),
                          );
                          if (pickedTime != null) {
                            setModalState(() {
                              selectedDateTime = DateTime(
                                pickedDate.year, pickedDate.month, pickedDate.day,
                                pickedTime.hour, pickedTime.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Prioridade:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(width: 10),
                    DropdownButton<String>(
                      value: selectedPriority,
                      dropdownColor: Colors.grey[850],
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.deepPurpleAccent,
                      items: priorities
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (value) => setModalState(() => selectedPriority = value!),
                    ),
                    Spacer(),
                    Text('Categoria:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    SizedBox(width: 10),
                    DropdownButton<Category>( // Dropdown para Category
                      value: selectedCategory,
                      dropdownColor: Colors.grey[850],
                      style: const TextStyle(color: Colors.white),
                      iconEnabledColor: Colors.deepPurpleAccent,
                      items: _categories.map((c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Icon(c.icon, color: c.color, size: 20),
                            SizedBox(width: 8),
                            Text(c.name),
                          ],
                        ),
                      )).toList(),
                      onChanged: (value) => setModalState(() => selectedCategory = value!),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    final String title = titleController.text.trim();
                    final String desc = descController.text.trim();
                    if (title.isEmpty) return;

                    final newTask = Task(
                      title: title,
                      description: desc,
                      dateTime: selectedDateTime,
                      priority: selectedPriority,
                      category: selectedCategory,
                      isCompleted: task?.isCompleted ?? false,
                    );

                    if (task == null) {
                      _addTask(newTask);
                    } else if (index != null) {
                      _editTask(index, newTask);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    task == null ? 'Adicionar' : 'Salvar',
                    style: const TextStyle(fontSize: 18, color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dialog de Confirmação para Excluir
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF20202C), // Fundo escuro
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text('Excluir Tarefa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Text('Deseja excluir esta tarefa?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancelar', style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () {
              _removeTask(index);
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            child: Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Dialog para Gerenciar Categorias
  void _showCategoryManagerDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder( // StatefulBuilder para atualizar a lista de categorias no dialog
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF20202C), // Fundo escuro
            title: Text('Gerenciar Categorias', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: double.maxFinite,
              child: _categories.isEmpty
                  ? Center(child: Text('Nenhuma categoria criada.', style: TextStyle(color: Colors.white54)))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _categories.length,
                      itemBuilder: (listCtx, i) {
                        final cat = _categories[i];
                        return ListTile(
                          leading: Icon(cat.icon, color: cat.color),
                          title: Text(cat.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.pop(context); // Fecha o dialog de gerenciamento
                                  _showAddEditCategoryModal(category: cat, index: i);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Confirmação para excluir categoria
                                  showDialog(
                                    context: context,
                                    builder: (deleteCtx) => AlertDialog(
                                      title: Text('Excluir Categoria'),
                                      content: Text('Deseja excluir a categoria "${cat.name}"? As tarefas associadas serão removidas.'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(deleteCtx), child: Text('Cancelar')),
                                        TextButton(
                                          onPressed: () {
                                            _removeCategory(cat);
                                            Navigator.pop(deleteCtx); // Fecha o dialog de confirmação
                                            setDialogState(() {}); // Atualiza o dialog de gerenciamento
                                          },
                                          child: Text('Excluir', style: TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Fechar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Fecha o dialog de gerenciamento
                  _showAddEditCategoryModal(); // Abre modal para adicionar nova categoria
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Adicionar Nova', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).maybePop();
          },
        ),
        title: Text(
          'Minhas Tarefas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        actions: [
          IconButton(
              icon: const Icon(Icons.folder_open_outlined, color: Colors.deepPurpleAccent), // Ícone roxo
            onPressed: _showCategoryManagerDialog, // Botão para gerenciar categorias
            tooltip: 'Gerenciar Categorias',
          ),
        ],
      ),
      body: tasks.isEmpty
          ? Center(child: Text('Nenhuma tarefa cadastrada'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (ctx, i) {
                final t = tasks[i];
                return Card(
                  color: const Color(0xFF24243B), // Cor do card mais escura
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), // Cantos arredondados
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: t.isCompleted,
                          onChanged: (val) => setState(() => t.isCompleted = val!),                         
                          checkColor: Colors.white,                         
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      t.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: t.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        color: t.isCompleted
                                            ? Colors.white
                                            : Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _showTaskModal(task: t, index: i),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _showDeleteDialog(i),
                                  ),
                                ],
                              ),
                              if (t.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    t.description,
                                    style: TextStyle(
                                      color: t.isCompleted
                                          ? Colors.white
                                          : Colors.white,
                                      fontSize: 13,
                                      decoration: t.isCompleted
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_today, size: 15, color: Colors.grey[600]),
                                  SizedBox(width: 4),
                                  Text(
                                    DateFormat('dd/MM/yyyy HH:mm').format(t.dateTime),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Icon(Icons.flag, size: 15, color:
                                    t.priority == 'Alta' ? Colors.red :
                                    t.priority == 'Média' ? Colors.orange :
                                    Colors.green),
                                  SizedBox(width: 3),
                                  Text(
                                    t.priority,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4), // Espaçamento entre as linhas
                              Row( // Nova linha para ícone e nome da categoria
                                children: [
                                  Icon(t.category.icon, size: 15, color: t.category.color), // Ícone da categoria
                                  SizedBox(width: 3),
                                  Text(
                                    t.category.name,
                                    style: TextStyle(
                                      color: t.category.color, // Cor da categoria
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskModal(),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 30),
         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), // Cantos arredondados
        elevation: 6,
      ),
    );
  }
}