# Сегментация клиентов

Запрос для выбора клиентов, удовлетворяющих условиям сегментации: офлайн-покупки в рознице за период, чек на одежду + обувь от 2000 руб, без учёта маркетплейса.

## Что внутри

JOIN со справочниками товаров и магазинов, фильтрация по периоду и типу доставки, агрегация через GROUP BY + HAVING с двумя условиями.

## Инструменты

SQL (SAP HANA)

## Запрос

```sql
SELECT t."/BIC/ZMB_MBID" AS id_klient
FROM "SAPPBI"."trn_1" t

LEFT JOIN "_SYS_BIC"."ATV_MATERIAL" a ON t.material = a.material
LEFT JOIN "_SYS_BIC"."CV_PLANT" c ON t.plant = c.plant

WHERE (t.calday BETWEEN '20220822' AND '20220828')
AND (t.ship_cond = 'OF')
AND (c.class_num = 'ALL_STORES')
AND (a.rpa_wgh3 IN ('T40', 'T45'))
AND (a.zmpinput = '' OR a.zmpinput IS NULL)

GROUP BY t."/BIC/ZMB_MBID"
HAVING SUM(t.rpa_sat) >= 2000
AND COUNT(DISTINCT CASE WHEN a.rpa_wgh3 IN ('T40', 'T45')
    THEN a.rpa_wgh3 END) = 2;
```

Файл запроса: [customer_segmentation.sql](customer_segmentation.sql)
