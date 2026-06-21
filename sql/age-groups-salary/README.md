# Возрастные группы и зарплаты

Запрос для расчёта средней зарплаты по возрастным группам работников.

## Что внутри

Возрастная группа определяется через CASE WHEN на основе разницы между годом выплаты и годом рождения. Считаем количество уникальных работников, сумму выплат и среднюю зарплату по группам.

## Инструменты

SQL (SQLite)

## Запрос

```sql
SELECT
    zp.period_year AS Год,

    CASE
        WHEN (zp.period_year - CAST(strftime('%Y', zl.birth_date) AS INT)) < 18
            THEN '14-17 лет'
        WHEN (zp.period_year - CAST(strftime('%Y', zl.birth_date) AS INT)) < 44
            THEN '18-44 лет'
        WHEN (zp.period_year - CAST(strftime('%Y', zl.birth_date) AS INT)) < 60
            THEN '44-60 лет'
        WHEN (zp.period_year - CAST(strftime('%Y', zl.birth_date) AS INT)) < 75
            THEN '60-75 лет'
        ELSE '75-90 лет'
    END AS Возрастная_группа,

    COUNT(DISTINCT zl.kod_zl) AS Кол_во_работников,
    SUM(zp.zp) AS Выплаты,
    AVG(zp.zp) AS Средняя_ЗП

FROM temp_ts_zp_202302011152 zp
JOIN temp_ts_zl_202302011152 zl ON zp.kod_zl = zl.kod_zl

GROUP BY Год, Возрастная_группа
ORDER BY Год, Возрастная_группа;
```

Файл запроса: [age_groups_salary.sql](age_groups_salary.sql)
