-- Queries 1-16. Run after schema.sql and data.sql.
-- Note: query 12 (UPDATE) and 13 (DELETE) modify the data.

--------------------------------------------------------
-- INTEROGARI (1–16)
--------------------------------------------------------

-- 1. Afisarea tuturor cartilor impreuna cu editura si categoria (JOIN pe 3 tabele)
SELECT b.title,
       p.name AS publisher,
       c.name AS category,
       b.publish_year
FROM books b
JOIN publishers p ON b.publisher_id = p.publisher_id
JOIN categories c ON b.category_id = c.category_id
ORDER BY b.title;

-- 2. Numarul de carti scrise de fiecare autor (LEFT JOIN + GROUP BY)
SELECT a.first_name
       , a.last_name, -- || ' ' || este operator de concatenare
       COUNT(ba.book_id) AS books_written
FROM authors a
LEFT JOIN book_authors ba ON a.author_id = ba.author_id
GROUP BY first_name, last_name
ORDER BY books_written DESC;

-- 3. Numarul total de imprumuturi pentru fiecare membru (LEFT JOIN + GROUP BY)
SELECT m.first_name || ' ' || m.last_name AS member_name,
       COUNT(l.loan_id) AS total_loans
FROM members m
LEFT JOIN loans l ON m.member_id = l.member_id
GROUP BY member_name
ORDER BY total_loans DESC;

-- 4. Lista imprumuturilor cu detalii despre membru si carte (JOIN pe 3 tabele + ORDER BY)
SELECT m.first_name || ' ' || m.last_name AS member_name,
       b.title,
       l.loan_date,
       l.due_date,
       l.return_date
FROM loans l
JOIN members m ON m.member_id = l.member_id
JOIN books b ON b.book_id = l.book_id
ORDER BY l.loan_date DESC;

-- 5. Lista cartilor nereturnate si membrii care le au imprumutate
SELECT b.title, m.first_name || ' ' || m.last_name AS member
FROM loans l
JOIN books b ON b.book_id = l.book_id
JOIN members m ON m.member_id = l.member_id
WHERE l.return_date IS NULL;

-- 6. Cartile din categoria 'Fantasy' publicate dupa 1950
SELECT b.title, b.publish_year,
       p.name AS publisher
FROM books b
JOIN categories c ON c.category_id = b.category_id
JOIN publishers p ON b.publisher_id = p.publisher_id
WHERE c.name = 'Fantasy'
  AND b.publish_year > 1950
ORDER BY b.publish_year;

-- 7. Numarul de carti existente pe fiecare categorie (GROUP BY)
SELECT c.name AS category,
       COUNT(b.book_id) AS total_books
FROM categories c
LEFT JOIN books b ON b.category_id = c.category_id
GROUP BY c.name
ORDER BY total_books DESC;

-- 8. Membrii care au mai mult de un imprumut (GROUP BY + HAVING)
SELECT m.first_name || ' ' || m.last_name AS member_name,
       COUNT(l.loan_id) AS nr_loans
FROM members m
JOIN loans l ON l.member_id = m.member_id
GROUP BY member_name
HAVING COUNT(l.loan_id) > 1
ORDER BY nr_loans DESC;

-- 9. Cartile care nu au fost niciodata imprumutate (LEFT JOIN + IS NULL)
SELECT b.book_id, b.title
FROM books b
LEFT JOIN loans l ON l.book_id = b.book_id
WHERE l.loan_id IS NULL;

-- 10. Imprumuturi intarziate (scadenta trecuta si carte nereturnata)
SELECT m.first_name || ' ' || m.last_name AS member_name,
       b.title,
       l.loan_date,
       l.due_date
FROM loans l
JOIN members m ON m.member_id = l.member_id
JOIN books b ON b.book_id = l.book_id
WHERE l.return_date IS NULL
  AND l.due_date < CURRENT_DATE
ORDER BY l.due_date;

-- 11. Top autori dupa numarul de imprumuturi ale cartilor lor
SELECT a.first_name || ' ' || a.last_name AS author_name,
       COUNT(*) AS total_loans
FROM loans l
JOIN book_authors ba ON ba.book_id = l.book_id
JOIN authors a ON a.author_id = ba.author_id
GROUP BY author_name
ORDER BY total_loans DESC;


-- Afisarea tabelului loans INAINTE de update
SELECT loan_id, member_id, book_id, loan_date, due_date, return_date
FROM loans
ORDER BY loan_id;

-- 12. UPDATE: prelungirea termenului de predare cu 7 zile pentru imprumuturile active
UPDATE loans
SET due_date = due_date + INTERVAL '7 days'
WHERE return_date IS NULL;

-- Afisarea tabelului loans DUPA update
SELECT loan_id, member_id, book_id, loan_date, due_date, return_date
FROM loans
ORDER BY loan_id;


-- 13. DELETE: stergerea unui membru fictiv care nu are imprumuturi
-- Afisarea tabelului members INAINTE de delete
SELECT *
FROM members
ORDER BY member_id;

DELETE FROM members
WHERE member_id = 999
  AND NOT EXISTS (
      SELECT 1
      FROM loans l
      WHERE l.member_id = members.member_id
  );

-- Afisarea tabelului members DUPA delete
SELECT *
FROM members
ORDER BY member_id;



-- 14. Membrii care au imprumutat carti din categoria 'Literatura romana' (subinterogare IN)
SELECT DISTINCT m.member_id,
       m.first_name,
       m.last_name
FROM members m
WHERE m.member_id IN (
    SELECT l.member_id
    FROM loans l
    JOIN books b ON b.book_id = l.book_id
    JOIN categories c ON c.category_id = b.category_id
    WHERE c.name = 'Literatura romana'
);

-- 15. Pentru fiecare membru, data ultimului imprumut (subinterogare corelata)
SELECT m.member_id,
       m.first_name,
       m.last_name,
       (
         SELECT MAX(l.loan_date)
         FROM loans l
         WHERE l.member_id = m.member_id
       ) AS last_loan_date
FROM members m
ORDER BY last_loan_date NULLS LAST;


-- 16. Afisarea tuturor tabelelor si a numarului de randuri din fiecare
SELECT
    relname AS table_name,
    n_live_tup AS estimated_row_count
FROM pg_stat_user_tables
ORDER BY relname;
