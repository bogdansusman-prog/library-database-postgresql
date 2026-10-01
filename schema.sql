-- ===============================================
--  Library database - schema (PostgreSQL)
-- ===============================================
-- Re-runnable: drops the tables first.
DROP TABLE IF EXISTS book_authors, loans, member_card, members, books, categories, publishers, authors CASCADE;

-- 1. Tabelul autorilor
CREATE TABLE authors (
    author_id   SERIAL PRIMARY KEY,
    first_name  VARCHAR(50) NOT NULL,
    last_name   VARCHAR(50) NOT NULL,
    birth_year  INTEGER
);

-- 2. Tabelul editurilor
CREATE TABLE publishers (
    publisher_id SERIAL PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE,
    city         VARCHAR(100)
);

-- 3. Tabelul categoriilor
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE
);

-- 4. Tabelul cartilor
CREATE TABLE books (
    book_id       SERIAL PRIMARY KEY,
    title         VARCHAR(200) NOT NULL,
    isbn          VARCHAR(20) UNIQUE,
    publish_year  INTEGER,
    publisher_id  INTEGER REFERENCES publishers (publisher_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    category_id   INTEGER REFERENCES categories (category_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT
);

-- 5. Membrii bibliotecii
CREATE TABLE members (
    member_id         SERIAL PRIMARY KEY,
    first_name        VARCHAR(50) NOT NULL,
    last_name         VARCHAR(50) NOT NULL,
    email             VARCHAR(100) UNIQUE,
    registration_date DATE NOT NULL DEFAULT CURRENT_DATE
);

-- 6. Carduri de membru (relatie 1-1 cu members)
CREATE TABLE member_card (
    card_id          SERIAL PRIMARY KEY,
    member_id        INTEGER NOT NULL UNIQUE
        REFERENCES members (member_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    card_number      VARCHAR(20) NOT NULL UNIQUE,
    issue_date       DATE NOT NULL,
    expiration_date  DATE NOT NULL
);

-- 7. Imprumuturi (relatii 1-N members-books)
CREATE TABLE loans (
    loan_id      SERIAL PRIMARY KEY,
    member_id    INTEGER NOT NULL
        REFERENCES members (member_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    book_id      INTEGER NOT NULL
        REFERENCES books (book_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    loan_date    DATE NOT NULL DEFAULT CURRENT_DATE,
    due_date     DATE NOT NULL,
    return_date  DATE,
    CONSTRAINT loans_check_dates
        CHECK (due_date >= loan_date)
);

-- 8. Legatura many-to-many intre carti si autori
CREATE TABLE book_authors (
    book_id   INTEGER NOT NULL
        REFERENCES books (book_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    author_id INTEGER NOT NULL
        REFERENCES authors (author_id)
        ON UPDATE RESTRICT ON DELETE RESTRICT,
    PRIMARY KEY (book_id, author_id)
);
