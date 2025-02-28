DECLARE i INTEGER := 0;
-- Ticket 523216
BEGIN
  i := 1;
  FOR t IN (SELECT SEQFAMILIA
  FROM MAP_FAMILIA X WHERE LENGTH(X.CODCEST) = 6)
  
  LOOP
    i := i+1;
  UPDATE MAP_FAMILIA X SET X.CODCEST = LPAD(CODCEST,7,0),
                           X.USUARIOALTERACAO = 'TKT523216',
                           X.DTAHORALTERACAO = SYSDATE - 2
                     WHERE X.SEQFAMILIA = T.SEQFAMILIA;
    IF i = 25 THEN COMMIT;
    i := 0;
    END IF;
  END LOOP;
  COMMIT;
END;
