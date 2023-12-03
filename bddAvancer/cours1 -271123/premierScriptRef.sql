drop table ref_Vol;
drop table O_REF_PILOTE;

drop type adresse_t force;
drop type Pilote_t force;

CREATE OR REPLACE TYPE adresse_t as object(
    Numero NUMBER(4),
    Rue VARCHAR2(20),
    Code_Postal NUMBER(5),
    Ville VARCHAR2(20)
);
/

CREATE OR REPLACE TYPE Pilote_t AS OBJECT(
    PL# NUMBER(4),
    nom VARCHAR2(12),
    adresse adresse_t,
    Tel VARCHAR2(12),
    dnaiss DATE,
    salaire NUMBER(7,2)
);
/

-- Création d’une table objet
CREATE TABLE O_REF_PILOTE OF Pilote_t;

-- Création d’une table relation avec une référence
CREATE TABLE ref_Vol (
    Vol# NUMBER(4) PRIMARY KEY,
    VD VARCHAR2(20),
    VA VARCHAR2(20),
    Pilote REF Pilote_t
);

INSERT INTO o_ref_pilote VALUES ( Pilote_t(2, 'Milou TINTIN',
 adresse_t(12, 'rue nord', 75000, 'Paris'), '0493825084', sysdate, 10000.5));

INSERT INTO ref_vol SELECT 300, 'Paris', 'Nice', REF(px)
from o_ref_pilote px  where px.nom = 'Milou TINTIN';
commit;


select * from ref_vol