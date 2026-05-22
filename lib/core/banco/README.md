# SQLite - Spin Flow

## 📁 Estrutura de Arquivos

```
lib/banco/sqlite/
├── script.dart              # Comandos SQL para criar tabelas e inserir dados
├── conexao.dart             # Classe de conexão SQLite (Singleton)
├── exemplo_uso.dart         # Exemplos de uso dos DAOs
├── README.md               # Esta documentação
└── dao/                    # Data Access Objects
    ├── dao_fabricante.dart
    ├── dao_categoria_musica.dart
    ├── dao_tipo_manutencao.dart
    ├── dao_artista_banda.dart
    └── dao_aluno.dart
```

## 🗄️ Tabelas Criadas

### 1. **fabricante**
- `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
- `nome` (TEXT NOT NULL)
- `ativo` (INTEGER NOT NULL DEFAULT 1)

### 2. **categoria_musica**
- `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
- `nome` (TEXT NOT NULL)
- `ativa` (INTEGER NOT NULL DEFAULT 1)

### 3. **tipo_manutencao**
- `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
- `nome` (TEXT NOT NULL)
- `ativa` (INTEGER NOT NULL DEFAULT 1)

### 4. **artista_banda**
- `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
- `nome` (TEXT NOT NULL)
- `descricao` (TEXT)
- `link` (TEXT)
- `foto` (TEXT)
- `ativo` (INTEGER NOT NULL DEFAULT 1)

### 5. **aluno**
- `id` (INTEGER PRIMARY KEY AUTOINCREMENT)
- `nome` (TEXT NOT NULL)
- `email` (TEXT NOT NULL)
- `data_nascimento` (TEXT NOT NULL) - Formato ISO 8601
- `genero` (TEXT NOT NULL)
- `telefone` (TEXT NOT NULL)
- `url_foto` (TEXT)
- `instagram` (TEXT)
- `facebook` (TEXT)
- `tiktok` (TEXT)
- `observacoes` (TEXT)
- `ativo` (INTEGER NOT NULL DEFAULT 1)

## 🔧 Adaptações Realizadas

### **Tipos de Dados**
- **Booleanos**: Convertidos para INTEGER (0/1)
- **Datas**: Convertidas para TEXT (formato ISO 8601)
- **Textos longos**: Mantidos como TEXT
- **URLs**: Mantidas como TEXT

### **Conversões Automáticas**
- **Para salvar**: `bool` → `int` (true=1, false=0)
- **Para ler**: `int` → `bool` (1=true, 0=false)
- **Para salvar**: `DateTime` → `String` (ISO 8601)
- **Para ler**: `String` → `DateTime` (parse ISO 8601)

## 🚀 Como Usar

### **1. Inicializar Conexão**
```dart
final db = await ConexaoSQLite.database;
```

### **2. Usar DAOs**
```dart
// Salvar (criar ou atualizar)
final fabricante = DTOFabricante(nome: 'Novo Fabricante', ativo: true);
final id = await DAOFabricante.salvar(fabricante);

// Buscar todos
final fabricantes = await DAOFabricante.buscarTodos();

// Buscar por ID
final fabricante = await DAOFabricante.buscarPorId(1);

// Excluir
await DAOFabricante.excluir(1);
```

### **3. Testar Funcionalidade**
```dart
await ExemploUsoSQLite.exemploCompleto();
```

## 📱 Suporte Multiplataforma

- ✅ **Mobile**: sqflite padrão
- ✅ **Desktop**: sqflite_common_ffi
- ✅ **Web**: sqflite_common_ffi_web

## 🎯 Próximos Passos

1. **Tabelas Associativas**: Para relacionamentos N:N
2. **Chaves Estrangeiras**: Para relacionamentos 1:N
3. **Índices**: Para otimização de consultas
4. **Migrations**: Para atualizações de schema

## 📋 Dependências

```yaml
dependencies:
  sqflite: ^2.3.0
  sqflite_common_ffi: ^2.3.2
  sqflite_common_ffi_web: ^0.4.2
  path: ^1.8.0
``` 