# Crona

> *"Eu não sei lidar com isso..."*: o Crona organiza o seu treino e a sua alimentação por você.

Aplicativo Flutter com duas áreas: **Treinos**, onde você monta a ficha da semana e vê o **percentual de ativação de cada músculo**, e **Nutrição**, onde você monta refeições com alimentos da **Tabela TACO** e vê as calorias e o **percentual de proteína, carboidrato e gordura**. Visual inspirado em *Soul Eater*.

Projeto prático (Parte 1) de **Programação para Dispositivos Móveis**, Fatec Ribeirão Preto, Prof. Rodrigo Plotze.
Equipe: **Luis Henrique Paziani** e **João Vitor Pereira Delaspora**.

## Como executar

```bash
flutter pub get
flutter run            # escolha um emulador, Chrome ou Windows
```

**Conta de teste:** `demo@crona.app` · senha `crona123` (ou crie uma conta nova).
Os dados ficam em memória nesta etapa: ao reiniciar o app, eles voltam ao estado inicial.

## Requisitos da Parte 1

| Requisito | Onde está |
|---|---|
| **RF001 Login**: e-mail, senha, logotipo, Entrar, Cadastro, Esqueceu a senha; valida preenchimento e formato do e-mail | `lib/view/login_view.dart`, `lib/controller/login_controller.dart` |
| **RF002 Cadastro**: nome, e-mail, telefone, senha e confirmação; valida campos, e-mail e senhas iguais | `lib/view/cadastro_usuario_view.dart`, `lib/controller/cadastro_usuario_controller.dart` |
| **RF003 Esqueceu a senha**: valida e-mail e confirma o envio das instruções | `lib/view/recuperar_senha_view.dart`, `lib/controller/recuperar_senha_controller.dart` |
| **RF004 Sobre**: objetivo, equipe, disciplina, instituição, professor, versão | `lib/view/sobre_view.dart` (no login e no menu lateral) |
| **RF005 Perfil**: nome editável (mín. 3 caracteres), e-mail só leitura, Salvar/Cancelar; o nome novo aparece no "Oi, ..." da tela Treinos e no menu lateral; só com login | `lib/view/perfil_view.dart` + rotas protegidas em `lib/main.dart` |
| **RF006 Funcionalidades do tema** (9, cada uma com tela e arquivo próprios) | ver abaixo |
| **RF007 Listagem**: `ListView` (Treinos, Nutrição, Tabela de alimentos) e `GridView` (Exercícios), com dados estáticos | `treinos_view.dart`, `nutricao_view.dart`, `alimentos_view.dart`, `exercicios_view.dart` |
| **Gerenciamento de estado**: `ChangeNotifier` + `get_it` | `lib/controller/`, `lib/service/usuario_service.dart` |

### Funcionalidades do tema (RF006)

**Treinos** (aba da barra inferior):

1. **Rotina de treinos** (`treinos_view.dart`): lista, edição e exclusão com "Desfazer".
2. **Cadastrar/editar treino** (`treino_form_view.dart`): dias, horário, duração sugerida e exercícios. **Avisa quando o horário bate com outro treino.**
3. **Treino do dia** (`treino_detalhe_view.dart`): exercícios em cards expansíveis com embasamento teórico e o **percentual de ativação de cada músculo** no treino inteiro.
4. **Biblioteca de exercícios** (`exercicios_view.dart`): busca e filtro por músculo. Abre pelo botão da aba Treinos ou pelo menu lateral.
5. **Detalhe do exercício** (`exercicio_detalhe_view.dart`): execução, frequência nas rotinas e percentual de ativação por músculo.

**Nutrição** (aba da barra inferior), com valores da Tabela TACO (4ª ed., NEPA/UNICAMP): 30 alimentos do dia a dia com kcal e macros por 100 g.

6. **Nutrição** (`nutricao_view.dart`): cardápios salvos, cada um com as kcal do dia, o gráfico de macros e quanto cada refeição pesa no dia.
7. **Tabela de alimentos** (`alimentos_view.dart`): busca sem acento e filtro por tipo; detalhe por 100 g.
8. **Montar refeição** (`refeicao_form_view.dart`): alimentos da TACO com gramas e horário; o gráfico atualiza ao vivo.
9. **Montar o dia (cardápio)** (`cardapio_form_view.dart`): junta as refeições num grupo ("Segunda", "Terça a sexta") e escolhe os dias da semana; refeições com horário sobreposto não são aceitas.

O **gráfico composto de macros** (`widgets/grafico_macros.dart`) aparece em todo card de refeição e de cardápio. Ele tem uma faixa 100% com o percentual de cada macro na energia (4/4/9 kcal por grama) e uma barra por macro com os gramas.

## Trechos apresentados no vídeo

Os pontos do código ligados aos critérios de avaliação estão marcados com o comentário `[VÍDEO]` (busque por ele no editor): validações do RF001 a RF005, rotas protegidas, navegação, gerenciamento de estado com ChangeNotifier, as listas do RF007, o início de cada funcionalidade do RF006 e os cálculos de percentual (ativação muscular e macronutrientes).

## Estrutura

```
lib/
├── main.dart            rotas, guarda de login, injeção de dependências
├── controller/          estado (ChangeNotifier) de cada funcionalidade
├── service/             estado compartilhado da conta
├── model/               Usuario, Treino, Exercicio, Musculo, Alimento, Refeicao
├── data/                dados estáticos (exercícios e alimentos)
├── theme/               cores e tema da marca
├── util/                validações e formatação
├── widgets/             componentes (logo, barras de ativação, gráfico de macros...)
└── view/                telas
```
