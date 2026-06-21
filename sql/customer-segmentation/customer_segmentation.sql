-- Сегментация клиентов: покупали и одежду, и обувь в офлайн-рознице за период,
-- сумма чека за период >= 2000, без учёта товаров маркетплейса

-- Выбираем ID клиентов, удовлетворяющих условиям сегментации
SELECT t."/BIC/ZMB_MBID" AS id_klient
FROM "SAPPBI"."trn_1" t

-- Подключаем справочник товаров для получения категории и флага маркетплейса
LEFT JOIN "_SYS_BIC"."ATV_MATERIAL" a ON t.material = a.material

-- Подключаем справочник магазинов для фильтрации по типу сети
LEFT JOIN "_SYS_BIC"."CV_PLANT" c ON t.plant = c.plant

WHERE (t.calday BETWEEN '20220822' AND '20220828') -- период с 22 по 28 августа 2022
AND (t.ship_cond = 'OF') -- только офлайн-покупки
AND (c.class_num = 'ALL_STORES') -- только регулярная сеть
AND (a.rpa_wgh3 IN ('T40', 'T45')) -- только одежда (T40) и обувь (T45)
AND (a.zmpinput = '' OR a.zmpinput IS NULL) -- исключаем товары маркетплейса

GROUP BY t."/BIC/ZMB_MBID"
HAVING SUM(t.rpa_sat) >= 2000 -- суммарные покупки клиента за период >= 2000
AND COUNT(DISTINCT CASE WHEN a.rpa_wgh3 IN ('T40', 'T45')
    THEN a.rpa_wgh3 END) = 2; -- клиент покупал и одежду, и обувь
