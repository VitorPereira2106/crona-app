import '../model/exercicio.dart';
import '../model/musculo.dart';

//
// BIBLIOTECA DE EXERCÍCIOS (dados estáticos da Parte 1)
// Percentuais de ativação são ESTIMATIVAS relativas, para fins de visualização.
//
const exerciciosMock = <Exercicio>[
  Exercicio(
    id: 'supino_reto',
    nome: 'Supino reto com barra',
    grupo: 'peito',
    equipamento: 'Barra',
    padrao: 'Empurrar horizontal',
    ativacao: {Musculo.peitoral: 85, Musculo.ombros: 50, Musculo.triceps: 40},
    frequencia: 78,
    porQueFunciona:
        'Multiarticular que permite carga alta e progressão constante. É a base de força do empurrar horizontal.',
    execucao:
        'Deitado, escápulas encaixadas, desça a barra até a linha do peito e empurre até estender os cotovelos.',
  ),
  Exercicio(
    id: 'supino_inclinado',
    nome: 'Supino inclinado com halteres',
    grupo: 'peito',
    equipamento: 'Halteres',
    padrao: 'Empurrar inclinado',
    ativacao: {Musculo.peitoral: 75, Musculo.ombros: 60, Musculo.triceps: 35},
    frequencia: 64,
    porQueFunciona:
        'A inclinação de 30–45° desloca o foco para a porção superior do peitoral; halteres dão amplitude maior.',
    execucao:
        'Banco inclinado, halteres na linha do peito, empurre para cima aproximando-os sem bater.',
  ),
  Exercicio(
    id: 'crucifixo',
    nome: 'Crucifixo com halteres',
    grupo: 'peito',
    equipamento: 'Halteres',
    padrao: 'Isolado',
    ativacao: {Musculo.peitoral: 80, Musculo.ombros: 30},
    frequencia: 41,
    porQueFunciona:
        'Isola a adução horizontal do ombro, alongando o peitoral sob carga sem depender do tríceps.',
    execucao:
        'Cotovelos levemente flexionados, abra os braços em arco até sentir o alongamento e feche.',
  ),
  Exercicio(
    id: 'desenvolvimento',
    nome: 'Desenvolvimento militar',
    grupo: 'ombros',
    equipamento: 'Barra',
    padrao: 'Empurrar vertical',
    ativacao: {Musculo.ombros: 85, Musculo.triceps: 50, Musculo.trapezio: 30},
    frequencia: 58,
    porQueFunciona:
        'Principal empurrar vertical: trabalha os deltoides com carga e exige estabilidade do core.',
    execucao:
        'Em pé, barra na altura da clavícula, empurre acima da cabeça sem arquear a lombar.',
  ),
  Exercicio(
    id: 'elevacao_lateral',
    nome: 'Elevação lateral',
    grupo: 'ombros',
    equipamento: 'Halteres',
    padrao: 'Isolado',
    ativacao: {Musculo.ombros: 90, Musculo.trapezio: 25},
    frequencia: 72,
    porQueFunciona:
        'Isola a porção lateral do deltoide, responsável pela largura dos ombros.',
    execucao:
        'Braços ao lado do corpo, eleve até a linha dos ombros com cotovelos levemente flexionados.',
  ),
  Exercicio(
    id: 'triceps_polia',
    nome: 'Tríceps na polia',
    grupo: 'tríceps',
    equipamento: 'Polia',
    padrao: 'Isolado',
    ativacao: {Musculo.triceps: 90, Musculo.antebraco: 20},
    frequencia: 81,
    porQueFunciona:
        'Tensão constante do cabo em toda a amplitude; fácil de progredir e seguro para os cotovelos.',
    execucao:
        'Cotovelos colados ao corpo, estenda os braços para baixo e volte devagar.',
  ),
  Exercicio(
    id: 'puxada_frente',
    nome: 'Puxada frontal',
    grupo: 'costas',
    equipamento: 'Polia',
    padrao: 'Puxar vertical',
    ativacao: {
      Musculo.dorsal: 85,
      Musculo.biceps: 50,
      Musculo.trapezio: 30,
      Musculo.ombros: 25,
    },
    frequencia: 83,
    porQueFunciona:
        'Alternativa à barra fixa que permite ajustar a carga; foco no latíssimo do dorso.',
    execucao:
        'Pegada pronada aberta, puxe a barra até a parte alta do peito levando os cotovelos para baixo.',
  ),
  Exercicio(
    id: 'remada_curvada',
    nome: 'Remada curvada',
    grupo: 'costas',
    equipamento: 'Barra',
    padrao: 'Puxar horizontal',
    ativacao: {
      Musculo.dorsal: 75,
      Musculo.trapezio: 55,
      Musculo.biceps: 40,
      Musculo.lombar: 35,
    },
    frequencia: 66,
    porQueFunciona:
        'Puxada horizontal pesada que trabalha espessura das costas e a estabilidade da lombar.',
    execucao:
        'Tronco inclinado a ~45°, coluna neutra, puxe a barra até o umbigo e controle a descida.',
  ),
  Exercicio(
    id: 'rosca_direta',
    nome: 'Rosca direta',
    grupo: 'bíceps',
    equipamento: 'Barra',
    padrao: 'Isolado',
    ativacao: {Musculo.biceps: 90, Musculo.antebraco: 45},
    frequencia: 85,
    porQueFunciona:
        'Flexão de cotovelo com carga alta; o exercício mais usado para bíceps nas fichas.',
    execucao:
        'Cotovelos fixos ao lado do corpo, suba a barra sem balançar o tronco.',
  ),
  Exercicio(
    id: 'rosca_martelo',
    nome: 'Rosca martelo',
    grupo: 'bíceps',
    equipamento: 'Halteres',
    padrao: 'Isolado',
    ativacao: {Musculo.biceps: 70, Musculo.antebraco: 65},
    frequencia: 52,
    porQueFunciona:
        'A pegada neutra recruta mais braquial e braquiorradial, engrossando braço e antebraço.',
    execucao:
        'Palmas voltadas uma para a outra, suba os halteres alternando ou juntos.',
  ),
  Exercicio(
    id: 'agachamento',
    nome: 'Agachamento livre',
    grupo: 'pernas',
    equipamento: 'Barra',
    padrao: 'Agachar',
    ativacao: {
      Musculo.quadriceps: 85,
      Musculo.gluteos: 70,
      Musculo.adutores: 45,
      Musculo.lombar: 35,
      Musculo.abdomen: 25,
    },
    frequencia: 74,
    porQueFunciona:
        'Movimento fundamental: trabalha quase toda a perna e o core, com grande transferência para o dia a dia.',
    execucao:
        'Barra nas costas, pés na largura dos ombros, desça com o quadril para trás até a coxa paralela.',
  ),
  Exercicio(
    id: 'leg_press',
    nome: 'Leg press 45°',
    grupo: 'pernas',
    equipamento: 'Máquina',
    padrao: 'Agachar',
    ativacao: {
      Musculo.quadriceps: 85,
      Musculo.gluteos: 55,
      Musculo.adutores: 35,
    },
    frequencia: 79,
    porQueFunciona:
        'Permite muita carga nas pernas sem sobrecarregar a coluna; ótimo para volume.',
    execucao:
        'Pés no centro da plataforma, desça até ~90° de joelho e empurre sem travar os joelhos.',
  ),
  Exercicio(
    id: 'stiff',
    nome: 'Stiff',
    grupo: 'pernas',
    equipamento: 'Barra',
    padrao: 'Dobrar quadril',
    ativacao: {
      Musculo.posteriores: 85,
      Musculo.gluteos: 60,
      Musculo.lombar: 50,
    },
    frequencia: 57,
    porQueFunciona:
        'Alonga os posteriores da coxa sob carga — o padrão "dobrar o quadril" que o agachamento não cobre.',
    execucao:
        'Joelhos quase estendidos, leve o quadril para trás descendo a barra rente às pernas.',
  ),
  Exercicio(
    id: 'cadeira_extensora',
    nome: 'Cadeira extensora',
    grupo: 'pernas',
    equipamento: 'Máquina',
    padrao: 'Isolado',
    ativacao: {Musculo.quadriceps: 95},
    frequencia: 70,
    porQueFunciona:
        'Isola o quadríceps, especialmente o reto femoral, que é pouco exigido nos agachamentos.',
    execucao: 'Estenda os joelhos até o fim, segure 1 s e desça controlando.',
  ),
  Exercicio(
    id: 'panturrilha_pe',
    nome: 'Panturrilha em pé',
    grupo: 'pernas',
    equipamento: 'Máquina',
    padrao: 'Isolado',
    ativacao: {Musculo.panturrilha: 95},
    frequencia: 68,
    porQueFunciona:
        'Com joelhos estendidos o gastrocnêmio trabalha em alongamento total.',
    execucao:
        'Na ponta dos pés, desça o calcanhar o máximo possível e suba até o topo.',
  ),
  Exercicio(
    id: 'prancha',
    nome: 'Prancha',
    grupo: 'core',
    equipamento: 'Peso corporal',
    padrao: 'Core',
    ativacao: {Musculo.abdomen: 80, Musculo.obliquos: 50, Musculo.ombros: 20},
    frequencia: 47,
    porQueFunciona:
        'Treina o core a resistir à extensão da coluna, que é sua função principal no dia a dia.',
    execucao:
        'Antebraços no chão, corpo em linha reta da cabeça aos pés, sem deixar o quadril cair.',
  ),
];
