-- Sample data. Run after schema.sql.

--------------------------------------------------------
-- INSERT DATE DE BAZA
--------------------------------------------------------

-- Autori (am adaugat si Franz Kafka)
INSERT INTO authors (first_name, last_name, birth_year) VALUES
('George', 'Orwell', 1903),
('J.K.', 'Rowling', 1965),
('J.R.R.', 'Tolkien', 1892),
('Haruki', 'Murakami', 1949),
('Gabriel', 'Garcia Marquez', 1927),
('Ion', 'Creanga', 1837),
('Mihai', 'Eminescu', 1850),
('Mircea', 'Cartarescu', 1956),
('Franz', 'Kafka', 1883);

-- Edituri
INSERT INTO publishers (name, city) VALUES
('Humanitas', 'Bucuresti'),
('Polirom', 'Iasi'),
('Nemira', 'Bucuresti'),
('RAO', 'Bucuresti'),
('Penguin Books', 'Londra');

-- Categorii
INSERT INTO categories (name) VALUES
('Fictiune'),
('Fantasy'),
('Clasici'),
('Eseu'),
('Literatura romana');

-- Carti (am adaugat mai multe titluri, inclusiv Metamorfoza)
INSERT INTO books (title, isbn, publish_year, publisher_id, category_id) VALUES
('1984', '9780451524935', 1949, 5, 1),
('Harry Potter si Piatra Filozofala', '9780439554930', 1997, 5, 2),
('Stapanul Inelelor: Fratia Inelului', '9780261103573', 1954, 5, 2),
('Cronica unei morti anuntate', '9789734601234', 1981, 2, 1),
('Morometii', '9789734609995', 1955, 2, 5),
('Amintiri din copilarie', '9789734608882', 1892, 1, 5),
('Orbitor', '9789734605553', 1996, 1, 5),
('Metamorfoza', '9780143105244', 1915, 5, 1),
('Animal Farm', '9780451526342', 1945, 5, 1),
('Norwegian Wood', '9780375704024', 1987, 5, 1),
('Kafka on the Shore', '9781400079278', 2002, 5, 1),
('Love in the Time of Cholera', '9780307389732', 1985, 5, 1),
('Un veac de singuratate', '9780307474722', 1967, 2, 1),
('Povesti', '9789734600001', 1892, 1, 5),
('Poezii', '9789734600002', 1883, 1, 5),
('Solenoid', '9789734650000', 2015, 1, 5);

-- Membri
INSERT INTO members (first_name, last_name, email, registration_date) VALUES
('Ana', 'Popescu', 'ana.popescu@example.com', '2023-10-01'),
('Andrei', 'Ionescu', 'andrei.ionescu@example.com', '2023-11-15'),
('Maria', 'Georgescu', 'maria.georgescu@example.com', '2024-01-10'),
('Alex', 'Dumitru', 'alex.dumitru@example.com', '2024-02-20'),
('Ioana', 'Stan', 'ioana.stan@example.com', '2024-03-05');

-- Carduri de membru (relatie 1-1 cu members)
INSERT INTO member_card (member_id, card_number, issue_date, expiration_date) VALUES
(1, 'CARD-0001', '2023-10-01', '2025-10-01'),
(2, 'CARD-0002', '2023-11-15', '2025-11-15'),
(3, 'CARD-0003', '2024-01-10', '2026-01-10'),
(4, 'CARD-0004', '2024-02-20', '2026-02-20'),
(5, 'CARD-0005', '2024-03-05', '2026-03-05');

-- Legaturi carte-autor (many-to-many)
-- se bazeaza pe faptul ca ID-urile sunt generate in ordinea INSERT-urilor de mai sus
INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1),  -- 1984 - Orwell
(2, 2),  -- Harry Potter - Rowling
(3, 3),  -- Stapanul Inelelor - Tolkien
(4, 5),  -- Cronica unei morti anuntate - Marquez
(5, 6),  -- Morometii - Creanga
(6, 6),  -- Amintiri din copilarie - Creanga
(7, 8),  -- Orbitor - Cartarescu
(8, 9),  -- Metamorfoza - Kafka
(9, 1),  -- Animal Farm - Orwell
(10, 4), -- Norwegian Wood - Murakami
(11, 4), -- Kafka on the Shore - Murakami
(12, 5), -- Love in the Time of Cholera - Marquez
(13, 5), -- Un veac de singuratate - Marquez
(14, 6), -- Povesti - Creanga
(15, 7), -- Poezii - Eminescu
(16, 8); -- Solenoid - Cartarescu

-- Imprumuturi
INSERT INTO loans (member_id, book_id, loan_date, due_date, return_date) VALUES
(1, 1, '2024-03-01', '2024-03-15', '2024-03-10'),
(1, 2, '2024-03-20', '2024-04-05', NULL),
(2, 3, '2024-02-10', '2024-02-25', '2024-02-22'),
(3, 4, '2024-01-05', '2024-01-20', NULL),
(4, 5, '2024-03-02', '2024-03-16', '2024-03-16'),
(4, 6, '2024-03-25', '2024-04-10', NULL),
(5, 7, '2024-04-01', '2024-04-15', NULL);
