class AppDatabase {
  // Singleton para manter os dados vivos enquanto o app estiver aberto
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  
  AppDatabase._internal() {
    // Pré-cadastra um usuário padrão para teste imediato
    registerUser('teste@email.com', '123456', 'Usuário de Teste');
    addItem('teste@email.com', 'Carteira preta perdida perto do bloco A.');
  }

  // "Tabela" de usuários: chave = email, valor = dados do usuário (senha, nome)
  final Map<String, Map<String, String>> _users = {};

  // "Tabela" de itens perdidos/achados: chave = email, valor = lista de itens do usuário
  final Map<String, List<String>> _items = {};

  // Cadastrar usuário
  bool registerUser(String email, String password, String name) {
    if (_users.containsKey(email)) {
      return false; // Usuário já existe
    }
    _users[email] = {
      'password': password,
      'name': name,
    };
    _items[email] = []; // Inicializa a lista de itens vazia para essa chave
    return true;
  }

  // Validar login
  bool loginUser(String email, String password) {
    if (!_users.containsKey(email)) return false;
    return _users[email]?['password'] == password;
  }

  // Obter nome do usuário
  String getUserName(String email) {
    return _users[email]?['name'] ?? 'Usuário';
  }

  // Obter os itens daquela chave (usuário)
  List<String> getItems(String email) {
    return _items[email] ?? [];
  }

  // Adicionar novo item
  void addItem(String email, String item) {
    if (_items.containsKey(email)) {
      _items[email]!.insert(0, item); // Adiciona no topo
    }
  }
}