CREATE OR REPLACE TABLE suporte_operacional.atendimentos AS
SELECT
  id_chamado,
  data_abertura,
  data_fechamento,
  status,
  unidade,
  tipo_servico,
  prioridade,
  sla_horas,

  CASE
    WHEN data_fechamento IS NOT NULL
    THEN ROUND(
      DATETIME_DIFF(data_fechamento, data_abertura, MINUTE) / 60.0,
      1
    )
    ELSE NULL
  END AS tempo_resolucao_horas,

  CASE
    WHEN data_fechamento IS NULL THEN NULL
    WHEN DATETIME_DIFF(data_fechamento, data_abertura, HOUR) <= sla_horas THEN TRUE
    ELSE FALSE
  END AS dentro_sla,

  CASE WHEN status = 'Concluído' THEN 1 ELSE 0 END AS flg_concluido,
  CASE WHEN status IN ('Aberto', 'Em andamento') THEN 1 ELSE 0 END AS flg_backlog,

  DATE(data_abertura) AS dt_abertura,
  EXTRACT(YEAR FROM data_abertura) AS ano,
  EXTRACT(MONTH FROM data_abertura) AS mes,
  FORMAT_DATETIME('%Y-%m', data_abertura) AS ano_mes

FROM suporte_operacional.atendimentos_raw;
