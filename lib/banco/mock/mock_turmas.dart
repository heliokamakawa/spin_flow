import 'package:spin_flow/dto/dto_turma.dart';
import 'mock_salas.dart';

List<DTOTurma> mockTurmas = [
  DTOTurma(
    id: 1,
    nome: 'Spinning Iniciante 07h',
    descricao: 'Aula para iniciantes com foco em técnica e resistência',
    diasSemana: ['segunda', 'quarta', 'sexta'],
    horarioInicio: '07:00',
    duracaoMinutos: 45,
    sala: mockSalas[0], // Sala Spinning Principal
    ativo: true,
  ),
  DTOTurma(
    id: 2,
    nome: 'Spinning Intermediário 08h',
    descricao: 'Aula intermediária com intensidade moderada',
    diasSemana: ['terça', 'quinta'],
    horarioInicio: '08:00',
    duracaoMinutos: 50,
    sala: mockSalas[1], // Sala Spinning Compacta
    ativo: true,
  ),
  DTOTurma(
    id: 3,
    nome: 'Spinning Avançado 18h',
    descricao: 'Aula avançada com alta intensidade e intervalos',
    diasSemana: ['segunda', 'quarta', 'sexta'],
    horarioInicio: '18:00',
    duracaoMinutos: 60,
    sala: mockSalas[2], // Sala Spinning Premium
    ativo: true,
  ),
  DTOTurma(
    id: 4,
    nome: 'Spinning Express 12h',
    descricao: 'Aula rápida e intensa para horário de almoço',
    diasSemana: ['segunda', 'terça', 'quarta', 'quinta', 'sexta'],
    horarioInicio: '12:00',
    duracaoMinutos: 30,
    sala: mockSalas[3], // Sala Spinning Express
    ativo: true,
  ),
  DTOTurma(
    id: 5,
    nome: 'Spinning Elite 19h',
    descricao: 'Aula premium com música ao vivo e coreografia',
    diasSemana: ['terça', 'quinta'],
    horarioInicio: '19:00',
    duracaoMinutos: 75,
    sala: mockSalas[4], // Sala Spinning Elite
    ativo: true,
  ),
  DTOTurma(
    id: 6,
    nome: 'Spinning Studio 20h',
    descricao: 'Aula com foco em técnica e performance',
    diasSemana: ['segunda', 'quarta'],
    horarioInicio: '20:00',
    duracaoMinutos: 55,
    sala: mockSalas[5], // Sala Spinning Studio
    ativo: true,
  ),
  DTOTurma(
    id: 7,
    nome: 'Spinning Power 06h',
    descricao: 'Aula matinal para acordar com energia',
    diasSemana: ['segunda', 'terça', 'quarta', 'quinta', 'sexta'],
    horarioInicio: '06:00',
    duracaoMinutos: 45,
    sala: mockSalas[6], // Sala Spinning Power
    ativo: true,
  ),
  DTOTurma(
    id: 8,
    nome: 'Spinning Energy 17h',
    descricao: 'Aula para liberar energia após o trabalho',
    diasSemana: ['segunda', 'terça', 'quarta', 'quinta', 'sexta'],
    horarioInicio: '17:00',
    duracaoMinutos: 50,
    sala: mockSalas[7], // Sala Spinning Energy
    ativo: true,
  ),
  DTOTurma(
    id: 9,
    nome: 'Spinning Core 21h',
    descricao: 'Aula com foco em core e estabilização',
    diasSemana: ['terça', 'quinta'],
    horarioInicio: '21:00',
    duracaoMinutos: 40,
    sala: mockSalas[8], // Sala Spinning Core
    ativo: true,
  ),
  DTOTurma(
    id: 10,
    nome: 'Spinning Max 09h',
    descricao: 'Aula máxima com intensidade extrema',
    diasSemana: ['sábado'],
    horarioInicio: '09:00',
    duracaoMinutos: 90,
    sala: mockSalas[9], // Sala Spinning Max
    ativo: true,
  ),
  DTOTurma(
    id: 11,
    nome: 'Spinning Pro 14h',
    descricao: 'Aula profissional com técnicas avançadas',
    diasSemana: ['segunda', 'quarta', 'sexta'],
    horarioInicio: '14:00',
    duracaoMinutos: 60,
    sala: mockSalas[10], // Sala Spinning Pro
    ativo: true,
  ),
  DTOTurma(
    id: 12,
    nome: 'Spinning Fit 16h',
    descricao: 'Aula fitness com foco em resultados',
    diasSemana: ['terça', 'quinta'],
    horarioInicio: '16:00',
    duracaoMinutos: 45,
    sala: mockSalas[11], // Sala Spinning Fit
    ativo: true,
  ),
  DTOTurma(
    id: 13,
    nome: 'Spinning Turbo 10h',
    descricao: 'Aula turbo com velocidade e agilidade',
    diasSemana: ['sábado'],
    horarioInicio: '10:00',
    duracaoMinutos: 60,
    sala: mockSalas[12], // Sala Spinning Turbo
    ativo: true,
  ),
  DTOTurma(
    id: 14,
    nome: 'Spinning Rush 11h',
    descricao: 'Aula rush com intensidade crescente',
    diasSemana: ['domingo'],
    horarioInicio: '11:00',
    duracaoMinutos: 50,
    sala: mockSalas[13], // Sala Spinning Rush
    ativo: true,
  ),
  DTOTurma(
    id: 15,
    nome: 'Spinning Force 13h',
    descricao: 'Aula de força com resistência muscular',
    diasSemana: ['segunda', 'quarta', 'sexta'],
    horarioInicio: '13:00',
    duracaoMinutos: 55,
    sala: mockSalas[14], // Sala Spinning Force
    ativo: true,
  ),
  DTOTurma(
    id: 16,
    nome: 'Spinning Pulse 15h',
    descricao: 'Aula com batidas pulsantes e ritmo constante',
    diasSemana: ['terça', 'quinta'],
    horarioInicio: '15:00',
    duracaoMinutos: 45,
    sala: mockSalas[15], // Sala Spinning Pulse
    ativo: true,
  ),
  DTOTurma(
    id: 17,
    nome: 'Spinning Drive 22h',
    descricao: 'Aula noturna para quem trabalha até tarde',
    diasSemana: ['segunda', 'terça', 'quarta', 'quinta', 'sexta'],
    horarioInicio: '22:00',
    duracaoMinutos: 40,
    sala: mockSalas[16], // Sala Spinning Drive
    ativo: true,
  ),
  DTOTurma(
    id: 18,
    nome: 'Spinning Boost 08h30',
    descricao: 'Aula para dar boost na manhã',
    diasSemana: ['sábado'],
    horarioInicio: '08:30',
    duracaoMinutos: 45,
    sala: mockSalas[17], // Sala Spinning Boost
    ativo: true,
  ),
  DTOTurma(
    id: 19,
    nome: 'Spinning Charge 19h30',
    descricao: 'Aula para carregar as baterias',
    diasSemana: ['segunda', 'quarta', 'sexta'],
    horarioInicio: '19:30',
    duracaoMinutos: 50,
    sala: mockSalas[18], // Sala Spinning Charge
    ativo: true,
  ),
  DTOTurma(
    id: 20,
    nome: 'Spinning Peak 20h30',
    descricao: 'Aula para atingir o pico de performance',
    diasSemana: ['terça', 'quinta'],
    horarioInicio: '20:30',
    duracaoMinutos: 60,
    sala: mockSalas[19], // Sala Spinning Peak
    ativo: true,
  ),
]; 
