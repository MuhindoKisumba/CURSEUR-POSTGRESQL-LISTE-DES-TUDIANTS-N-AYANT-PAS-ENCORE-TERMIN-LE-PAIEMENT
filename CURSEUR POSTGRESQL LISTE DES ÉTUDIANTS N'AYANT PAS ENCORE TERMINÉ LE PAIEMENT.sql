/*****************************************************************************************
 CURSEUR POSTGRESQL
 LISTE DES ÉTUDIANTS N'AYANT PAS ENCORE TERMINÉ LE PAIEMENT
 Compatible PostgreSQL 11+
 Auteur : MUHINDO KISUMBA Abdiel
*****************************************************************************************/

---------------------------------------------------------
-- TABLE ETUDIANT
---------------------------------------------------------

CREATE TABLE etudiant
(
    id_etudiant SERIAL PRIMARY KEY,
    matricule VARCHAR(20) UNIQUE,
    nom VARCHAR(100),
    prenom VARCHAR(100)
);

---------------------------------------------------------
-- TABLE PAIEMENT
---------------------------------------------------------

CREATE TABLE paiement
(
    id_paiement SERIAL PRIMARY KEY,
    id_etudiant INT REFERENCES etudiant(id_etudiant),
    montant_total NUMERIC(12,2),
    montant_paye NUMERIC(12,2)
);

---------------------------------------------------------
-- CURSEUR
---------------------------------------------------------

DO
$$
DECLARE

    rec RECORD;

    curseur_etudiant CURSOR FOR

        SELECT
            e.matricule,
            e.nom,
            e.prenom,
            p.montant_total,
            p.montant_paye,
            (p.montant_total - p.montant_paye) AS reste
        FROM etudiant e
        INNER JOIN paiement p
            ON e.id_etudiant = p.id_etudiant
        WHERE p.montant_paye < p.montant_total
        ORDER BY e.nom;

BEGIN

    OPEN curseur_etudiant;

    LOOP

        FETCH curseur_etudiant INTO rec;

        EXIT WHEN NOT FOUND;

        RAISE NOTICE
        'Matricule : %, Nom : % %, Total : %, Payé : %, Reste : %',
        rec.matricule,
        rec.nom,
        rec.prenom,
        rec.montant_total,
        rec.montant_paye,
        rec.reste;

    END LOOP;

    CLOSE curseur_etudiant;

END;
$$;