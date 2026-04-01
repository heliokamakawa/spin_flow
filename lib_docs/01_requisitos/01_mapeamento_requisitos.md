# Mapeamento de Requisitos Funcionais (RF001-RF056)

## Resumo

- Atende: 56
- Parcial: 0
- Nao atende: 0

> Critério: `Atende` = implementação funcional direta no código atual. `Parcial` = cobertura incompleta. `Nao atende` = sem fluxo implementado.

| RF | Status | Arquivo | Classe | Método/Atributo | Descrição curta |
|---|---|---|---|---|---|
| RF001 | Atende | `lib/widget/aluno/tela_agenda_aluno.dart` | `TelaAgendaAluno` | `_gradeSemanal` | Exibe grade semanal com recorrência de turmas por dia e horário. |
| RF002 | Atende | `lib/widget/aluno/tela_agenda_aluno.dart` | `TelaAgendaAluno` | `_carregar` | Exibe horário, sala, vagas em tempo real e mix vigente por turma/data. |
| RF003 | Atende | `lib/banco/sqlite/dao/dao_turma.dart` | `DAOTurma` | `buscarAtivas` | Agenda usa apenas turmas ativas, bloqueando seleção de turma inativa. |
| RF004 | Atende | `lib/widget/aluno/tela_agenda_aluno.dart` | `TelaAgendaAluno` | `_selecionarData`, `_abrirMapa` | Seleção de turma e data para avançar ao mapa/reserva. |
| RF005 | Atende | `lib/widget/aluno/tela_agenda_aluno.dart` | `TelaAgendaAluno` | `_dataCompativelComTurma` | Valida data contra `Turma.diasSemana`. |
| RF006 | Atende | `lib/widget/aluno/tela_agenda_aluno.dart` | `TelaAgendaAluno` | `build` (chip/cta) | Sinaliza lotação e bloqueia ação de reservar quando sem vagas. |
| RF007 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `GridView.builder` | Exibe mapa em grade por filas e colunas da sala. |
| RF008 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_estadoPosicao` | Identifica livre/ocupada/bloqueada por manutenção/professora/minha reserva. |
| RF009 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_estadoPosicao` | Ocupação de terceiros sem identificação nominal. |
| RF010 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_estadoPosicao` (`_EstadoPosicao.minha`) | Destaca reserva do próprio aluno. |
| RF011 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_estadoPosicao`, `onTap` | Bloqueia seleção de posições ocupadas, da professora e em manutenção. |
| RF012 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `onTap` | Reserva apenas posições livres. |
| RF013 | Atende | `lib/banco/sqlite/dao/dao_checkin.dart` | `DAOCheckin` | `reservarComValidacao` | Valida aluno ativo antes da reserva. |
| RF014 | Atende | `lib/banco/sqlite/dao/dao_checkin.dart` | `DAOCheckin` | `reservarComValidacao` | Bloqueia reserva para data passada. |
| RF015 | Atende | `lib/banco/sqlite/dao/dao_checkin.dart` | `DAOCheckin` | `existeCheckinAtivoAluno` | Impede reserva duplicada (aluno/turma/data). |
| RF016 | Atende | `lib/banco/sqlite/dao/dao_checkin.dart` | `DAOCheckin` | `existeCheckinAtivoPosicao` | Impede dupla ocupação da posição. |
| RF017 | Atende | `lib/banco/sqlite/dao/dao_checkin.dart` | `DAOCheckin` | `salvar` | Persiste turma, data, fila e coluna do check-in. |
| RF018 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_carregar` pós reserva | Recarrega mapa após reserva confirmada. |
| RF019 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_reservar` | Exibe feedback de sucesso. |
| RF020 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_reservar` (catch) | Exibe feedback de erro de reserva. |
| RF021 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_cancelarMeuCheckin` | Permite cancelar o próprio check-in. |
| RF022 | Atende | `lib/banco/sqlite/dao/dao_checkin.dart` | `DAOCheckin` | `cancelar` (`ativo=0`) | Preserva histórico por cancelamento lógico. |
| RF023 | Atende | `lib/widget/aluno/tela_mapa_checkin.dart` | `TelaMapaCheckin` | `_cancelarMeuCheckin` + `_carregar` | Atualiza mapa após cancelamento. |
| RF024 | Atende | `lib/banco/sqlite/dao/*.dart` | múltiplas | `excluir` | Exclusão padronizada para inativação lógica (`ativo/ativa = 0`) nos DAOs de domínio. |
| RF025 | Atende | `lib/widget/form_*.dart` | múltiplas | validações de formulário | Validação de obrigatórios e tipos nos formulários. |
| RF026 | Atende | `lib/widget/form_*.dart` | múltiplas | `_carregarDadosEdicao`, `_preencherCampos` | Edição controlada com dados pré-carregados. |
| RF027 | Atende | `lib/widget/componentes/campos/*` | `CampoOpcoes`, `CampoMultiSelecao` | seleção controlada | Associações entre entidades por seleção controlada. |
| RF028 | Atende | `lib/widget/form_sala.dart` | `FormSala` | `_salvar`, `_criarDTO` | Mantém salas (cadastro/edição/ativação). |
| RF029 | Atende | `lib/widget/form_sala.dart` | `FormSala` | `_salvar` | Impede reduzir grade quando existem posições de bike fora do novo limite. |
| RF030 | Atende | `lib/widget/form_bike.dart` | `FormBike` | `_salvar` | Mantém bikes com fabricante associado. |
| RF031 | Atende | `lib/widget/professora/tela_posicionamento_bikes.dart` | `TelaPosicionamentoBikes` | `_abrirAtribuicao`, `_carregar` | Permite associar, remover e reposicionar bikes no mapa da sala. |
| RF032 | Atende | `lib/widget/form_turma.dart` | `FormTurma` | `_salvar` | Mantém turmas com sala/dias/horário/duração/status. |
| RF033 | Atende | `lib/banco/sqlite/dao/dao_turma.dart` | `DAOTurma` | `_validarAtivacaoTurma` | Bloqueia ativação de turma com conflito de horário na mesma sala e dias coincidentes. |
| RF034 | Atende | `lib/widget/form_manutencao.dart` | `FormManutencao` | `_salvar` | Registra manutenção com bike/tipo/datas/descrição. |
| RF035 | Atende | `lib/widget/aluno/tela_agenda_aluno.dart` | `TelaAgendaAluno` | `_carregar` | Recalcula disponibilidade subtraindo bikes bloqueadas por manutenção ativa. |
| RF036 | Atende | `lib/widget/professora/tela_mapa_operacional_professora.dart` | `TelaMapaOperacionalProfessora` | `build`, `_checkinNaPosicao` | Mapa operacional nominal por turma/data para perfil professora. |
| RF037 | Atende | `lib/widget/professora/tela_mapa_operacional_professora.dart` | `TelaMapaOperacionalProfessora` | `_cancelarCheckin` | Permite cancelamento administrativo de check-ins de terceiros com confirmação. |
| RF038 | Atende | `lib/widget/aluno/tela_mix_turma_aluno.dart` | `TelaMixTurmaAluno` | `_carregar` | Consulta mix atual da turma em tela dedicada a partir da agenda. |
| RF039 | Atende | `lib/banco/sqlite/dao/dao_turma_mix.dart` | `DAOTurmaMix` | `buscarAtivoPorTurma` | Determina mix atual por vínculo aberto (`data_fim` nula/vazia) com fallback por vigência. |
| RF040 | Atende | `lib/widget/aluno/tela_mix_turma_aluno.dart` | `TelaMixTurmaAluno` | `build` | Exibe nome e período de uso do mix para a turma selecionada. |
| RF041 | Atende | `lib/widget/aluno/tela_mix_turma_aluno.dart` | `TelaMixTurmaAluno` | `build` | Exibe lista de músicas do mix atual no fluxo do aluno. |
| RF042 | Atende | `lib/widget/aluno/tela_mix_turma_aluno.dart` | `TelaMixTurmaAluno` | `build` | Exibe artista e categorias para cada música do mix. |
| RF043 | Atende | `lib/widget/aluno/tela_mix_turma_aluno.dart` | `TelaMixTurmaAluno` | `build` | Exibe links de vídeo-aula associados às músicas quando disponíveis. |
| RF044 | Atende | `lib/widget/aluno/tela_agenda_aluno.dart` | `TelaAgendaAluno` | `build` (`Sem mix ativo`) | Informa ausência de mix ativo. |
| RF045 | Atende | `lib/widget/aluno/tela_mix_turma_aluno.dart` | `TelaMixTurmaAluno` | `_carregar` | Consulta e exibe histórico de mixes por turma. |
| RF046 | Atende | `lib/widget/aluno/tela_mix_turma_aluno.dart` | `TelaMixTurmaAluno` | `_carregar`, `build` | UI musical exibe vigência por período do vínculo turma-mix no contexto consultado. |
| RF047 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | `_carregar`, `build` | Consulta histórico de presença do aluno. |
| RF048 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | `_buscarAlunoLogado` | Histórico restrito ao aluno autenticado por e-mail de sessão, sem fallback global. |
| RF049 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | cálculo `concluidas/agendadas` | Distingue check-ins futuros e concluídos. |
| RF050 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | métrica `concluidas.length` | Total de aulas concluídas. |
| RF051 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | métrica `concluidasAno` | Aulas concluídas no ano. |
| RF052 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | métrica `concluidasMes` | Aulas concluídas no mês. |
| RF053 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | métrica `agendadas` | Aulas agendadas (futuras/hoje). |
| RF054 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | filtro `ativos` | Métricas desconsideram check-ins cancelados. |
| RF055 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | cálculos de recorrência | Exibe padrões de uso por recorrência de presença e comportamento de reserva. |
| RF056 | Atende | `lib/widget/aluno/tela_historico_aluno.dart` | `TelaHistoricoAluno` | `posicaoMaisRecorrente`, `turmaPosicaoMaisRecorrente` | Calcula posição mais recorrente e turma/posição mais frequente. |

## Rotas x requisitos

- rotas implementadas para fluxo aluno: `agendaAluno`, `mapaCheckin`, `historicoAluno`
- rotas de cadastros/listas operacionais da professora estão registradas em `SpinFlowApp`
- rotas dedicadas implementadas: `mixTurmaAluno`, `mapaOperacionalProfessora` e `posicionamentoBikes`


