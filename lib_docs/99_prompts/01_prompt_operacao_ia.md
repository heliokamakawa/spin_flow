# Prompt Operacional (IA)

Use este prompt como base para manutenção técnica contínua do projeto SpinFlow.

## Objetivo

Sincronizar código com:
1. DTOs (fonte da verdade)
2. requisitos funcionais (`docs/sections/06-requisitos_funcionais.tex`)
3. padrão existente do projeto

## Regras de execução

- não refatorar arquitetura
- não criar camadas novas
- manter padrão atual de UI e rotas
- aplicar mudanças mínimas e objetivas
- atualizar documentação em `lib_docs/`

## Ordem obrigatória

1. ler DTOs
2. ler DAOs
3. ler forms/listas/rotas
4. cruzar com requisitos
5. corrigir inconsistências
6. atualizar `01_requisitos/01_mapeamento_requisitos.md`
7. atualizar `03_execucao/01_log_execucao.md`
8. registrar pendências de requisito neste arquivo (se houver)

## Critérios de decisão

- DTO prevalece sobre implementação antiga
- requisito prevalece sobre implementação incompleta
- padrão existente prevalece sobre redesign

## Saída esperada

- código ajustado
- mapeamento RF atualizado com localização exata
- log com feito/falta

## Comandos úteis

```bash
rg --files lib
rg -n "mock_|TODO|RF|Rotas" lib docs
```

```bash
dart analyze
```

```bash
dart format lib
```

## Estado atual do processo

- cobertura funcional mapeada em 56/56 RF do documento atual
- fluxo aluno com check-in no dia e mapa gráfico atualizado
- fluxo professora com mapa operacional e cancelamento administrativo
- mapeamento principal em `lib_docs/01_requisitos/01_mapeamento_requisitos.md`

## Pendências para adicionar ao documento de requisitos

> Itens solicitados e implementados no código, mas ainda não formalizados explicitamente no `06-requisitos_funcionais.tex`.

1. **Regra temporal de reserva (janela de 30 minutos)**
- descrição: reserva do aluno só pode ser realizada a partir de 30 minutos antes do horário de início da aula.
- impacto: bloqueia reservas muito antecipadas.

2. **Fila de espera de check-in por turma/data**
- descrição: quando não houver vagas, aluno pode entrar em fila de espera; ao cancelar um check-in, o primeiro da fila é promovido automaticamente.
- impacto: continuidade operacional com regra FIFO.

3. **Identificação da bike no mapa de reserva**
- descrição: cada posição deve exibir identificador da bike posicionada (id e/ou número de série).
- impacto: escolha de bike com rastreabilidade visual.

4. **Fluxo de check-in do aluno sem seleção de aluno manual**
- descrição: aluno autenticado reserva apenas para si; o sistema não deve solicitar seleção de aluno no fluxo do aluno.
- impacto: coerência de segurança e melhor UX.
