# Library Database (PostgreSQL)

A relational database for a library, written in **PostgreSQL**. It includes the schema, sample data and 16 queries (joins, aggregations, subqueries, UPDATE and DELETE).

Built for the **Databases** course (2025). The same domain is implemented as a Java desktop app in [library-management-java](https://github.com/bogdansusman-prog/library-management-java).

## Schema

```
authors ──< book_authors >── books >── publishers
                               │  └──> categories
                               │
members ──< loans >────────────┘
   │
   └── member_card   (1:1)
```

| Table | Description | Key constraints |
|---|---|---|
| `authors` | Book authors | — |
| `publishers` | Publishing houses | `name` UNIQUE |
| `categories` | Book genres | `name` UNIQUE |
| `books` | Book catalogue | `isbn` UNIQUE, FK to `publishers` and `categories` (ON DELETE RESTRICT) |
| `book_authors` | **Many-to-many** link between books and authors | composite PK `(book_id, author_id)` |
| `members` | Library members | `email` UNIQUE, `registration_date` defaults to `CURRENT_DATE` |
| `member_card` | Membership cards, **one-to-one** with members | `member_id` UNIQUE, ON DELETE CASCADE |
| `loans` | Book loans, linking members and books | `CHECK (due_date >= loan_date)`, `return_date` NULL while the book is still out |

## Queries ([`queries.sql`](queries.sql))

| # | Query | Technique |
|---|---|---|
| 1 | Books with publisher and category | 3-table JOIN |
| 2 | Number of books per author | LEFT JOIN + GROUP BY |
| 3 | Total loans per member | LEFT JOIN + GROUP BY |
| 4 | Loan history with member and book | JOIN + ORDER BY |
| 5 | Books not yet returned | JOIN + `IS NULL` |
| 6 | Fantasy books published after 1950 | JOIN + filters |
| 7 | Books per category | LEFT JOIN + GROUP BY |
| 8 | Members with more than one loan | GROUP BY + HAVING |
| 9 | Books never borrowed | LEFT JOIN + `IS NULL` (anti-join) |
| 10 | Overdue loans | date comparison with `CURRENT_DATE` |
| 11 | Top authors by number of loans | JOIN through the M:N table + GROUP BY |
| 12 | Extend active loans by 7 days | `UPDATE` with `INTERVAL` |
| 13 | Delete a member only if they have no loans | `DELETE` + `NOT EXISTS` |
| 14 | Members who borrowed Romanian literature | `IN` subquery |
| 15 | Each member's latest loan date | correlated subquery |
| 16 | Row count of every table | `pg_stat_user_tables` system view |

## Running

```bash
createdb biblioteca
psql -d biblioteca -f schema.sql    # creates the tables (re-runnable, drops existing ones)
psql -d biblioteca -f data.sql      # sample data: 9 authors, 16 books, 5 members, 7 loans
psql -d biblioteca -f queries.sql   # runs all 16 queries
```

Or open the files in DataGrip, pgAdmin or any other PostgreSQL client. Tested on PostgreSQL 16 and 18.

## Tech

PostgreSQL · SQL · DataGrip
