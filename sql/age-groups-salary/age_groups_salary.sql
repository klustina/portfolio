-- Итоговый запрос: год + возрастная группа + показатели

SELECT
    zp.period_year AS Год,

    -- Определяем возрастную группу на основе разницы между
    -- отчётным годом и годом рождения работника
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

    -- Считаем уникальных работников (один работник = одна запись)
    COUNT(DISTINCT zl.kod_zl) AS Кол_во_работников,

    -- Суммируем все выплаты по группе
    SUM(zp.zp) AS Выплаты,

    -- Средняя зарплата = среднее значение по всем выплатам группы
    AVG(zp.zp) AS Средняя_ЗП

-- Основная таблица — выплаты
FROM temp_ts_zp_202302011152 zp

-- Присоединяем таблицу работников по коду работника
JOIN temp_ts_zl_202302011152 zl ON zp.kod_zl = zl.kod_zl

-- Группируем результат по году и возрастной группе
GROUP BY Год, Возрастная_группа

-- Сортируем по году и группе для читаемости
ORDER BY Год, Возрастная_группа;
