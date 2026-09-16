# Student Clubs Relational Database — Flatt Falls College (Case Study)

End-to-end relational database design for a fictional college's student-clubs office, completed for ISM 310 (Database Analysis, Modeling, and Design) at Northern Arizona University, Spring 2025. The project moved from a stakeholder interview and legacy spreadsheets to a normalized conceptual model, a fully specified EER diagram, and a working Oracle SQL schema with tested constraints.

## Problem

The clubs finance coordinator tracked memberships, dues payments, club details, advisors, and expenses across inherited spreadsheets with heavy redundant entry. The goal was a small transaction-processing database that removes that redundancy and enforces the office's business rules.

## Design

**Phase 1 — Conceptual model (3NF).** Identified entities, attributes, keys, and relationships from the interview notes and sample documents; resolved repeating groups and transitive dependencies to third normal form.

**Phase 2 — EER diagram (Lucidchart).** Fully specified model with data types and lengths, NOT NULL designations, primary and foreign keys, crow's-foot cardinalities, and a `Club` supertype with `AffiliatedClub` and `SponsoredClub` subtypes (optional, disjoint).

**Phase 3 — Physical schema (Oracle SQL).** `CREATE TABLE` statements for `Student`, `Club`, `ClubDuesPayment`, and `ClubExpenses` with:

- Primary and foreign key constraints (`Club.PresidentID → Student`, `ClubDuesPayment → Student, Club`, `ClubExpenses → Club`)
- `NOT NULL` on required attributes
- `CHECK` constraints enforcing enumerated club types (`Honorary | Professional | Social`), enumerated expense types (`Dues | Food | Travel | Supplies | Misc`), and an expense amount range of $0–$1,000

Each constraint was verified with deliberate violating inserts — duplicate keys, invalid enumerations, out-of-range amounts, and orphaned foreign keys — to confirm the database rejects bad data.

## Tools

Lucidchart (EER modeling) · Oracle SQL (DDL, constraints, inserts)

## Files

| File | Description |
|---|---|
| `schema.sql` | DROP/CREATE TABLE statements with all constraints, plus the valid and intentionally invalid test inserts |
| `eer_diagram.pdf` | Fully specified EER diagram (Phase 2) |
| `docs/Project_Phase_1.docx` | Case description and stakeholder interview |
| `docs/ISM_Semester_Project_Phase_2.pdf` | Phase 2 requirements and instructor blueprint |
| `docs/Project_Phase_3.docx` | Phase 3 requirements |

## Notes

Student and club records in the test inserts are placeholders, not real data.
