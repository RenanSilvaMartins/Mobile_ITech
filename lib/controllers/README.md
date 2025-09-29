# Technician Controller

Controller para gerenciar operações CRUD dos técnicos via API REST.

## Endpoints da API

- **Base URL**: `http://localhost:8082/tecnico`

### Operações Disponíveis

#### 1. Buscar todos os técnicos
```dart
List<TechnicianModel> technicians = await TechnicianController.getAllTechnicians();
```

#### 2. Buscar técnico por ID
```dart
TechnicianModel? technician = await TechnicianController.getTechnicianById('123');
```

#### 3. Criar novo técnico
```dart
TechnicianModel newTechnician = TechnicianModel(/* dados */);
TechnicianModel created = await TechnicianController.createTechnician(newTechnician);
```

#### 4. Atualizar técnico
```dart
TechnicianModel updated = await TechnicianController.updateTechnician('123', technician);
```

#### 5. Deletar técnico
```dart
bool success = await TechnicianController.deleteTechnician('123');
```

## Tratamento de Erros

Todas as operações podem lançar exceções que devem ser tratadas:

```dart
try {
  final technicians = await TechnicianController.getAllTechnicians();
  // Usar os dados
} catch (e) {
  // Tratar erro
  print('Erro: $e');
}
```

## Códigos de Status HTTP

- **200**: Sucesso (GET, PUT)
- **201**: Criado com sucesso (POST)
- **204**: Deletado com sucesso (DELETE)
- **404**: Não encontrado
- **500**: Erro interno do servidor