# Arquitetura do Projeto Flutter ITech

## Estrutura de Pastas

```
lib/
├── main.dart                    # Ponto de entrada da aplicação
├── core/                        # Funcionalidades centrais
│   ├── constants/              # Constantes da aplicação
│   │   ├── app_colors.dart     # Cores do tema
│   │   └── app_strings.dart    # Strings/textos
│   └── utils/                  # Utilitários gerais
├── data/                       # Camada de dados
│   └── models/                 # Modelos de dados
│       └── user_model.dart     # Modelo do usuário
├── domain/                     # Lógica de negócio
└── presentation/               # Camada de apresentação
    ├── screens/                # Telas da aplicação
    │   ├── splash_screen.dart  # Tela de splash
    │   ├── login_screen.dart   # Tela de login
    │   └── cadastro_screen.dart # Tela de cadastro
    └── widgets/                # Widgets reutilizáveis
        ├── custom_text_field.dart # Campo de texto customizado
        └── custom_button.dart     # Botão customizado
```

## Camadas da Arquitetura

### 1. Presentation Layer (Apresentação)
- **Responsabilidade**: Interface do usuário e interações
- **Contém**: Screens (telas) e Widgets reutilizáveis
- **Exemplo**: `SplashScreen`, `LoginScreen`, `CustomButton`

### 2. Domain Layer (Domínio)
- **Responsabilidade**: Lógica de negócio e regras da aplicação
- **Contém**: Use cases, entidades e interfaces
- **Status**: Preparado para expansão futura

### 3. Data Layer (Dados)
- **Responsabilidade**: Acesso a dados e modelos
- **Contém**: Models, repositories e data sources
- **Exemplo**: `UserModel`

### 4. Core Layer (Núcleo)
- **Responsabilidade**: Funcionalidades compartilhadas
- **Contém**: Constantes, utilitários e configurações
- **Exemplo**: `AppColors`, `AppStrings`

## Funcionalidades Implementadas

### Splash Screen
- Timer automático de 2 segundos
- Navegação automática para tela de login
- Design com gradiente radial

### Sistema de Login/Cadastro
- Tela de login com campos de email e senha
- Tela de cadastro com campos nome, email e senha
- Navegação entre telas
- Widgets reutilizáveis para campos e botões

## Benefícios da Arquitetura

1. **Separação de Responsabilidades**: Cada camada tem uma função específica
2. **Reutilização de Código**: Widgets e constantes compartilhados
3. **Manutenibilidade**: Código organizado e fácil de manter
4. **Escalabilidade**: Estrutura preparada para crescimento
5. **Testabilidade**: Camadas isoladas facilitam testes

## Próximos Passos

1. Implementar lógica de autenticação na camada Domain
2. Adicionar validação de formulários
3. Implementar persistência de dados
4. Adicionar testes unitários
5. Implementar gerenciamento de estado (Provider/Bloc)