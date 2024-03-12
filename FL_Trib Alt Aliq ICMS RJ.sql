ALTER SESSION SET CURRENT_SCHEMA = CONSINCO;

call dbms_application_info.set_action('DROP')

DROP TABLE NAGT_MAP_TRIBUTACAOUF_BKP;

-- Backup

CREATE TABLE CONSINCO.NAGT_MAP_TRIBUTACAOUF_BKP AS
SELECT * FROM CONSINCO.MAP_TRIBUTACAOUF

-- Loop de Retorno do Backup caso a alteracao nao esteja correta

DECLARE 
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT DISTINCT X.NROTRIBUTACAO, X.PERALIQUOTA, X.PERALIQUOTAST, X.PERALIQICMSCALCPRECO, X.PERTRIBUTADO, 
                              X.PERISENTO, X.UFCLIENTEFORNEC, X.TIPTRIBUTACAO, X.NROREGTRIBUTACAO, X.UFEMPRESA
                              
                FROM NAGT_MAP_TRIBUTACAOUF_BKP X INNER JOIN MAP_TRIBUTACAOUF Q ON X.NROTRIBUTACAO = Q.NROTRIBUTACAO
                                                                              AND X.UFEMPRESA     = Q.UFEMPRESA
                                                                              AND X.UFCLIENTEFORNEC = Q.UFCLIENTEFORNEC
                                                                              AND X.TIPTRIBUTACAO = Q.TIPTRIBUTACAO
                                                                              AND X.NROREGTRIBUTACAO = Q.NROREGTRIBUTACAO
                      WHERE Q.PERALIQUOTA    != X.PERALIQUOTA
                         OR Q.PERALIQUOTAST  != X.PERALIQUOTAST
                         OR Q.PERALIQICMSCALCPRECO != X.PERALIQICMSCALCPRECO
                         OR Q.PERISENTO      != X.PERISENTO)
  LOOP
    BEGIN
       i := i+1;
    UPDATE CONSINCO.MAP_TRIBUTACAOUF U SET U.PERALIQUOTA      = T.PERALIQUOTA,
                                           U.PERALIQUOTAST    = T.PERALIQUOTAST,
                                           U.PERALIQICMSCALCPRECO = T.PERALIQICMSCALCPRECO,
                                           U.PERTRIBUTADO     = T.PERTRIBUTADO,
                                           U.PERISENTO        = T.PERISENTO
                                           
                                     WHERE U.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                       AND U.UFEMPRESA        = T.UFEMPRESA
                                       AND U.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                       AND U.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                       AND U.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
    IF i = 100 THEN COMMIT;
       i := 0;
    END IF;
            
      END;
  END LOOP;
 COMMIT;
END;  
  
-- Update RJ ICMS ST de 20% para 22%

DECLARE 
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT * FROM MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO IN (999,783,857,776,261,837,782,746,1004,704,1054,741,677,860,681,92,913,1066,963,136,1145,703,723,1098,966,799,891,989,911,67,42,30,279,31,1023,1003,10,1021,1082,728,984,268,977,240,1060,14,795,887,1055,1125,297,753,707,522,983,29,800,443,683,454,12,836,742,1065,884,1062,1096,794,19,878,700,939,758,9,730,716,822,801,732,722,854,15,886,998,870,981,731,821,447,781,872,1136,1100,1123,842,734,996,883,995,144,851,830,919,915,893,5,978,855,71,188,843,125,192,897,137,936,126,973,256,808,384,972,33,202,845,725,898,1124,263,340,899,840,750,44,28,149,968,894,826,437,719,117,917,912,201,537,414,147,961,910,96,196,735,748,1008,543,338,1067,311,70,148,900,16,717,1097,1102,767,835,827,828,1104,205,103,778,668,1138,1033,167,965,974,178,969,97,45,889,3,726,214,931,787,1068,955,729,1000,957,918,688,625,1073,943,671,953,785,358,2,841,1137,711,881,985,1061,21,861,987,61,920,1009,885,982,1012,226,13,895,676,720,940,1056,834,493,958,1130,1131,336,925,1099,1029,959,960,775,314,691,82,86,692,813,814,798,796,1046,1042,779,113,954,862,644,970,1144,1143,1139,967,762,839,806,690,152,792,859,76,1081,1084,693,988,68,689,695,1007,130,817,1080,696,310,49,95,48,101,924,1016,702,759,90,79,427,1146,108,682,1058,740,1025,411,812,1147,1005,77,78,755,20,1070,1094,715,515,146,1019,403,1001,34,1049,225,838,234,675,667,773,60,846,673,36,1105,713,64,552,115,643,255,181,265,151,180,254,1106,156,142,382,154,804,55,935,1107,84,927,1020,153,971,203,452,168,157,929,204,665,714,672,53,173,304,680,306,674,72,75,1031,371,824,163,107,176,831,934,32,198,199,701,932,253,39,628,207,986,175,190,169,259,191,165,264,161,462,62,141,37,171,195,164,269,166,1092,858,260,25,160,664,162,474,747,1122,230,145,1128,1101,38,1030,63,1069,419,57,41,179,182,408,1050,790,183,1103,150,194,727,933,197,756,187,823,158,712,1032,143,185,186,892,1132,59,1133,849,418,847,852,856,820,850,848,916,914,890,344,322,65,980,1034,679,627,66,1028,950,761,979,52,926,611,549,949,325,763,533,98,1063,660,942,100,243,337,1057,341,1024,46,138,754,903,678,362,343,803,91,415,94,73,661,17,613,1141,1140,1142,896,404,88,213,548,124,244,118,633,631,43,110,635,24,629,83,287,1083,504,1085,282,210,294,278,880,948,423,1006,295,819,1077,56,1078,317,335,1079,283,1086,434,1087,663,47,69,1091,281,74,833,296,99,50,1015,285,300,290,209,632,351,81,102,85,547,699,26,1095,87,853,1043,737,528,1041,1126,706,818,993,964,743,1072,868,938,442,946,909,908,793,1048,1027,1040,907,906,1038,945,1039,902,901,1037,905,1014,536,1035,904,1047,1036,1045,289,1026,705,733)
                 AND X.PERALIQUOTAST IN (20)
                 AND X.NROREGTRIBUTACAO IN (6,2,1,7,0)
                 AND X.UFEMPRESA = 'RJ'
                 AND X.TIPTRIBUTACAO IN ('EI','ED','SC','SN','EM'))

   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERALIQUOTAST    = 22,
                                              Z.USUALTERACAO     = 'TKT367615'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;
   
END;

-- Update RJ ICMS ST de 18% para 20%

DECLARE 
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT * FROM MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO IN (999,783,857,776,261,837,782,746,1004,704,1054,741,677,860,681,92,913,1066,963,136,1145,703,723,1098,966,799,891,989,911,67,42,30,279,31,1023,1003,10,1021,1082,728,984,268,977,240,1060,14,795,887,1055,1125,297,753,707,522,983,29,800,443,683,454,12,836,742,1065,884,1062,1096,794,19,878,700,939,758,9,730,716,822,801,732,722,854,15,886,998,870,981,731,821,447,781,872,1136,1100,1123,842,734,996,883,995,144,851,830,919,915,893,5,978,855,71,188,843,125,192,897,137,936,126,973,256,808,384,972,33,202,845,725,898,1124,263,340,899,840,750,44,28,149,968,894,826,437,719,117,917,912,201,537,414,147,961,910,96,196,735,748,1008,543,338,1067,311,70,148,900,16,717,1097,1102,767,835,827,828,1104,205,103,778,668,1138,1033,167,965,974,178,969,97,45,889,3,726,214,931,787,1068,955,729,1000,957,918,688,625,1073,943,671,953,785,358,2,841,1137,711,881,985,1061,21,861,987,61,920,1009,885,982,1012,226,13,895,676,720,940,1056,834,493,958,1130,1131,336,925,1099,1029,959,960,775,314,691,82,86,692,813,814,798,796,1046,1042,779,113,954,862,644,970,1144,1143,1139,967,762,839,806,690,152,792,859,76,1081,1084,693,988,68,689,695,1007,130,817,1080,696,310,49,95,48,101,924,1016,702,759,90,79,427,1146,108,682,1058,740,1025,411,812,1147,1005,77,78,755,20,1070,1094,715,515,146,1019,403,1001,34,1049,225,838,234,675,667,773,60,846,673,36,1105,713,64,552,115,643,255,181,265,151,180,254,1106,156,142,382,154,804,55,935,1107,84,927,1020,153,971,203,452,168,157,929,204,665,714,672,53,173,304,680,306,674,72,75,1031,371,824,163,107,176,831,934,32,198,199,701,932,253,39,628,207,986,175,190,169,259,191,165,264,161,462,62,141,37,171,195,164,269,166,1092,858,260,25,160,664,162,474,747,1122,230,145,1128,1101,38,1030,63,1069,419,57,41,179,182,408,1050,790,183,1103,150,194,727,933,197,756,187,823,158,712,1032,143,185,186,892,1132,59,1133,849,418,847,852,856,820,850,848,916,914,890,344,322,65,980,1034,679,627,66,1028,950,761,979,52,926,611,549,949,325,763,533,98,1063,660,942,100,243,337,1057,341,1024,46,138,754,903,678,362,343,803,91,415,94,73,661,17,613,1141,1140,1142,896,404,88,213,548,124,244,118,633,631,43,110,635,24,629,83,287,1083,504,1085,282,210,294,278,880,948,423,1006,295,819,1077,56,1078,317,335,1079,283,1086,434,1087,663,47,69,1091,281,74,833,296,99,50,1015,285,300,290,209,632,351,81,102,85,547,699,26,1095,87,853,1043,737,528,1041,1126,706,818,993,964,743,1072,868,938,442,946,909,908,793,1048,1027,1040,907,906,1038,945,1039,902,901,1037,905,1014,536,1035,904,1047,1036,1045,289,1026,705,733)
                 AND X.PERALIQUOTAST IN (18)
                 AND X.NROREGTRIBUTACAO IN (6,2,1,7,0)
                 AND X.UFEMPRESA = 'RJ'
                 AND X.TIPTRIBUTACAO IN ('EI','ED','SC','SN','EM'))

   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERALIQUOTAST    = 20,
                                              Z.USUALTERACAO     = 'TKT367615'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;
   
END;
 
-- Update RJ ICMS de 20% para 22%

DECLARE 
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT * FROM MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO IN (999,783,857,776,261,837,782,746,1004,704,1054,741,677,860,681,92,913,1066,963,136,1145,703,723,1098,966,799,891,989,911,67,42,30,279,31,1023,1003,10,1021,1082,728,984,268,977,240,1060,14,795,887,1055,1125,297,753,707,522,983,29,800,443,683,454,12,836,742,1065,884,1062,1096,794,19,878,700,939,758,9,730,716,822,801,732,722,854,15,886,998,870,981,731,821,447,781,872,1136,1100,1123,842,734,996,883,995,144,851,830,919,915,893,5,978,855,71,188,843,125,192,897,137,936,126,973,256,808,384,972,33,202,845,725,898,1124,263,340,899,840,750,44,28,149,968,894,826,437,719,117,917,912,201,537,414,147,961,910,96,196,735,748,1008,543,338,1067,311,70,148,900,16,717,1097,1102,767,835,827,828,1104,205,103,778,668,1138,1033,167,965,974,178,969,97,45,889,3,726,214,931,787,1068,955,729,1000,957,918,688,625,1073,943,671,953,785,358,2,841,1137,711,881,985,1061,21,861,987,61,920,1009,885,982,1012,226,13,895,676,720,940,1056,834,493,958,1130,1131,336,925,1099,1029,959,960,775,314,691,82,86,692,813,814,798,796,1046,1042,779,113,954,862,644,970,1144,1143,1139,967,762,839,806,690,152,792,859,76,1081,1084,693,988,68,689,695,1007,130,817,1080,696,310,49,95,48,101,924,1016,702,759,90,79,427,1146,108,682,1058,740,1025,411,812,1147,1005,77,78,755,20,1070,1094,715,515,146,1019,403,1001,34,1049,225,838,234,675,667,773,60,846,673,36,1105,713,64,552,115,643,255,181,265,151,180,254,1106,156,142,382,154,804,55,935,1107,84,927,1020,153,971,203,452,168,157,929,204,665,714,672,53,173,304,680,306,674,72,75,1031,371,824,163,107,176,831,934,32,198,199,701,932,253,39,628,207,986,175,190,169,259,191,165,264,161,462,62,141,37,171,195,164,269,166,1092,858,260,25,160,664,162,474,747,1122,230,145,1128,1101,38,1030,63,1069,419,57,41,179,182,408,1050,790,183,1103,150,194,727,933,197,756,187,823,158,712,1032,143,185,186,892,1132,59,1133,849,418,847,852,856,820,850,848,916,914,890,344,322,65,980,1034,679,627,66,1028,950,761,979,52,926,611,549,949,325,763,533,98,1063,660,942,100,243,337,1057,341,1024,46,138,754,903,678,362,343,803,91,415,94,73,661,17,613,1141,1140,1142,896,404,88,213,548,124,244,118,633,631,43,110,635,24,629,83,287,1083,504,1085,282,210,294,278,880,948,423,1006,295,819,1077,56,1078,317,335,1079,283,1086,434,1087,663,47,69,1091,281,74,833,296,99,50,1015,285,300,290,209,632,351,81,102,85,547,699,26,1095,87,853,1043,737,528,1041,1126,706,818,993,964,743,1072,868,938,442,946,909,908,793,1048,1027,1040,907,906,1038,945,1039,902,901,1037,905,1014,536,1035,904,1047,1036,1045,289,1026,705,733)
                 AND X.PERALIQUOTA   IN (20)
                 AND X.NROREGTRIBUTACAO IN (6,2,1,7,0)
                 AND X.UFEMPRESA = 'RJ'
                 AND X.TIPTRIBUTACAO IN ('EI','ED','SC','SN'))
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERALIQUOTA      = 22,
                                              Z.USUALTERACAO     = 'TKT367615'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;
   
END;

-- Update RJ ICMS de 18% para 20%

DECLARE 
  i INTEGER := 0;
  
  BEGIN
    FOR t IN (SELECT * FROM MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO IN (999,783,857,776,261,837,782,746,1004,704,1054,741,677,860,681,92,913,1066,963,136,1145,703,723,1098,966,799,891,989,911,67,42,30,279,31,1023,1003,10,1021,1082,728,984,268,977,240,1060,14,795,887,1055,1125,297,753,707,522,983,29,800,443,683,454,12,836,742,1065,884,1062,1096,794,19,878,700,939,758,9,730,716,822,801,732,722,854,15,886,998,870,981,731,821,447,781,872,1136,1100,1123,842,734,996,883,995,144,851,830,919,915,893,5,978,855,71,188,843,125,192,897,137,936,126,973,256,808,384,972,33,202,845,725,898,1124,263,340,899,840,750,44,28,149,968,894,826,437,719,117,917,912,201,537,414,147,961,910,96,196,735,748,1008,543,338,1067,311,70,148,900,16,717,1097,1102,767,835,827,828,1104,205,103,778,668,1138,1033,167,965,974,178,969,97,45,889,3,726,214,931,787,1068,955,729,1000,957,918,688,625,1073,943,671,953,785,358,2,841,1137,711,881,985,1061,21,861,987,61,920,1009,885,982,1012,226,13,895,676,720,940,1056,834,493,958,1130,1131,336,925,1099,1029,959,960,775,314,691,82,86,692,813,814,798,796,1046,1042,779,113,954,862,644,970,1144,1143,1139,967,762,839,806,690,152,792,859,76,1081,1084,693,988,68,689,695,1007,130,817,1080,696,310,49,95,48,101,924,1016,702,759,90,79,427,1146,108,682,1058,740,1025,411,812,1147,1005,77,78,755,20,1070,1094,715,515,146,1019,403,1001,34,1049,225,838,234,675,667,773,60,846,673,36,1105,713,64,552,115,643,255,181,265,151,180,254,1106,156,142,382,154,804,55,935,1107,84,927,1020,153,971,203,452,168,157,929,204,665,714,672,53,173,304,680,306,674,72,75,1031,371,824,163,107,176,831,934,32,198,199,701,932,253,39,628,207,986,175,190,169,259,191,165,264,161,462,62,141,37,171,195,164,269,166,1092,858,260,25,160,664,162,474,747,1122,230,145,1128,1101,38,1030,63,1069,419,57,41,179,182,408,1050,790,183,1103,150,194,727,933,197,756,187,823,158,712,1032,143,185,186,892,1132,59,1133,849,418,847,852,856,820,850,848,916,914,890,344,322,65,980,1034,679,627,66,1028,950,761,979,52,926,611,549,949,325,763,533,98,1063,660,942,100,243,337,1057,341,1024,46,138,754,903,678,362,343,803,91,415,94,73,661,17,613,1141,1140,1142,896,404,88,213,548,124,244,118,633,631,43,110,635,24,629,83,287,1083,504,1085,282,210,294,278,880,948,423,1006,295,819,1077,56,1078,317,335,1079,283,1086,434,1087,663,47,69,1091,281,74,833,296,99,50,1015,285,300,290,209,632,351,81,102,85,547,699,26,1095,87,853,1043,737,528,1041,1126,706,818,993,964,743,1072,868,938,442,946,909,908,793,1048,1027,1040,907,906,1038,945,1039,902,901,1037,905,1014,536,1035,904,1047,1036,1045,289,1026,705,733)
                 AND X.PERALIQUOTA   IN (18)
                 AND X.NROREGTRIBUTACAO IN (6,2,1,7,0)
                 AND X.UFEMPRESA = 'RJ'
                 AND X.TIPTRIBUTACAO IN ('EI','ED','SC','SN'))
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERALIQUOTA      = 20,
                                              Z.USUALTERACAO     = 'TKT367615'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;

END;

-- Update RJ Microempresa Aliq ICMS Calc de 18% para 20%

DECLARE
i INTEGER := 0;

  BEGIN
    FOR t IN (SELECT * FROM MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO IN (999,783,857,776,261,837,782,746,1004,704,1054,741,677,860,681,92,913,1066,963,136,1145,703,723,1098,966,799,891,989,911,67,42,30,279,31,1023,1003,10,1021,1082,728,984,268,977,240,1060,14,795,887,1055,1125,297,753,707,522,983,29,800,443,683,454,12,836,742,1065,884,1062,1096,794,19,878,700,939,758,9,730,716,822,801,732,722,854,15,886,998,870,981,731,821,447,781,872,1136,1100,1123,842,734,996,883,995,144,851,830,919,915,893,5,978,855,71,188,843,125,192,897,137,936,126,973,256,808,384,972,33,202,845,725,898,1124,263,340,899,840,750,44,28,149,968,894,826,437,719,117,917,912,201,537,414,147,961,910,96,196,735,748,1008,543,338,1067,311,70,148,900,16,717,1097,1102,767,835,827,828,1104,205,103,778,668,1138,1033,167,965,974,178,969,97,45,889,3,726,214,931,787,1068,955,729,1000,957,918,688,625,1073,943,671,953,785,358,2,841,1137,711,881,985,1061,21,861,987,61,920,1009,885,982,1012,226,13,895,676,720,940,1056,834,493,958,1130,1131,336,925,1099,1029,959,960,775,314,691,82,86,692,813,814,798,796,1046,1042,779,113,954,862,644,970,1144,1143,1139,967,762,839,806,690,152,792,859,76,1081,1084,693,988,68,689,695,1007,130,817,1080,696,310,49,95,48,101,924,1016,702,759,90,79,427,1146,108,682,1058,740,1025,411,812,1147,1005,77,78,755,20,1070,1094,715,515,146,1019,403,1001,34,1049,225,838,234,675,667,773,60,846,673,36,1105,713,64,552,115,643,255,181,265,151,180,254,1106,156,142,382,154,804,55,935,1107,84,927,1020,153,971,203,452,168,157,929,204,665,714,672,53,173,304,680,306,674,72,75,1031,371,824,163,107,176,831,934,32,198,199,701,932,253,39,628,207,986,175,190,169,259,191,165,264,161,462,62,141,37,171,195,164,269,166,1092,858,260,25,160,664,162,474,747,1122,230,145,1128,1101,38,1030,63,1069,419,57,41,179,182,408,1050,790,183,1103,150,194,727,933,197,756,187,823,158,712,1032,143,185,186,892,1132,59,1133,849,418,847,852,856,820,850,848,916,914,890,344,322,65,980,1034,679,627,66,1028,950,761,979,52,926,611,549,949,325,763,533,98,1063,660,942,100,243,337,1057,341,1024,46,138,754,903,678,362,343,803,91,415,94,73,661,17,613,1141,1140,1142,896,404,88,213,548,124,244,118,633,631,43,110,635,24,629,83,287,1083,504,1085,282,210,294,278,880,948,423,1006,295,819,1077,56,1078,317,335,1079,283,1086,434,1087,663,47,69,1091,281,74,833,296,99,50,1015,285,300,290,209,632,351,81,102,85,547,699,26,1095,87,853,1043,737,528,1041,1126,706,818,993,964,743,1072,868,938,442,946,909,908,793,1048,1027,1040,907,906,1038,945,1039,902,901,1037,905,1014,536,1035,904,1047,1036,1045,289,1026,705,733)
                 AND X.PERALIQICMSCALCPRECO = 18
                 AND X.NROREGTRIBUTACAO IN (6,2,1,7,0)
                 AND X.UFEMPRESA = 'RJ'
                 AND X.TIPTRIBUTACAO IN ('EM'))
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERALIQICMSCALCPRECO = 20,
                                              Z.USUALTERACAO     = 'TKT367615'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;
      
-- Update RJ % Tributado e Isento de 38,89% para 35% e Isento de 61,11% para 65%

    FOR t IN (SELECT * FROM MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO IN (999,783,857,776,261,837,782,746,1004,704,1054,741,677,860,681,92,913,1066,963,136,1145,703,723,1098,966,799,891,989,911,67,42,30,279,31,1023,1003,10,1021,1082,728,984,268,977,240,1060,14,795,887,1055,1125,297,753,707,522,983,29,800,443,683,454,12,836,742,1065,884,1062,1096,794,19,878,700,939,758,9,730,716,822,801,732,722,854,15,886,998,870,981,731,821,447,781,872,1136,1100,1123,842,734,996,883,995,144,851,830,919,915,893,5,978,855,71,188,843,125,192,897,137,936,126,973,256,808,384,972,33,202,845,725,898,1124,263,340,899,840,750,44,28,149,968,894,826,437,719,117,917,912,201,537,414,147,961,910,96,196,735,748,1008,543,338,1067,311,70,148,900,16,717,1097,1102,767,835,827,828,1104,205,103,778,668,1138,1033,167,965,974,178,969,97,45,889,3,726,214,931,787,1068,955,729,1000,957,918,688,625,1073,943,671,953,785,358,2,841,1137,711,881,985,1061,21,861,987,61,920,1009,885,982,1012,226,13,895,676,720,940,1056,834,493,958,1130,1131,336,925,1099,1029,959,960,775,314,691,82,86,692,813,814,798,796,1046,1042,779,113,954,862,644,970,1144,1143,1139,967,762,839,806,690,152,792,859,76,1081,1084,693,988,68,689,695,1007,130,817,1080,696,310,49,95,48,101,924,1016,702,759,90,79,427,1146,108,682,1058,740,1025,411,812,1147,1005,77,78,755,20,1070,1094,715,515,146,1019,403,1001,34,1049,225,838,234,675,667,773,60,846,673,36,1105,713,64,552,115,643,255,181,265,151,180,254,1106,156,142,382,154,804,55,935,1107,84,927,1020,153,971,203,452,168,157,929,204,665,714,672,53,173,304,680,306,674,72,75,1031,371,824,163,107,176,831,934,32,198,199,701,932,253,39,628,207,986,175,190,169,259,191,165,264,161,462,62,141,37,171,195,164,269,166,1092,858,260,25,160,664,162,474,747,1122,230,145,1128,1101,38,1030,63,1069,419,57,41,179,182,408,1050,790,183,1103,150,194,727,933,197,756,187,823,158,712,1032,143,185,186,892,1132,59,1133,849,418,847,852,856,820,850,848,916,914,890,344,322,65,980,1034,679,627,66,1028,950,761,979,52,926,611,549,949,325,763,533,98,1063,660,942,100,243,337,1057,341,1024,46,138,754,903,678,362,343,803,91,415,94,73,661,17,613,1141,1140,1142,896,404,88,213,548,124,244,118,633,631,43,110,635,24,629,83,287,1083,504,1085,282,210,294,278,880,948,423,1006,295,819,1077,56,1078,317,335,1079,283,1086,434,1087,663,47,69,1091,281,74,833,296,99,50,1015,285,300,290,209,632,351,81,102,85,547,699,26,1095,87,853,1043,737,528,1041,1126,706,818,993,964,743,1072,868,938,442,946,909,908,793,1048,1027,1040,907,906,1038,945,1039,902,901,1037,905,1014,536,1035,904,1047,1036,1045,289,1026,705,733)
                 AND X.PERTRIBUTADO = 38.89
                 AND X.NROREGTRIBUTACAO IN (6,2,1,7,0)
                 AND X.UFEMPRESA = 'RJ'
                 AND X.TIPTRIBUTACAO IN ('EI','ED','SC','SN'))
   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERTRIBUTADO     = 35,
                                              Z.PERISENTO        = 65,
                                              Z.USUALTERACAO     = 'TKT367615'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;
   
   
-- Update SP para RJ ICMS ST de 18% para 20%

    FOR t IN (SELECT * FROM MAP_TRIBUTACAOUF X
               WHERE X.NROTRIBUTACAO IN (999,783,857,776,261,837,782,746,1004,704,1054,741,677,860,681,92,913,1066,963,136,1145,703,723,1098,966,799,891,989,911,67,42,30,279,31,1023,1003,10,1021,1082,728,984,268,977,240,1060,14,795,887,1055,1125,297,753,707,522,983,29,800,443,683,454,12,836,742,1065,884,1062,1096,794,19,878,700,939,758,9,730,716,822,801,732,722,854,15,886,998,870,981,731,821,447,781,872,1136,1100,1123,842,734,996,883,995,144,851,830,919,915,893,5,978,855,71,188,843,125,192,897,137,936,126,973,256,808,384,972,33,202,845,725,898,1124,263,340,899,840,750,44,28,149,968,894,826,437,719,117,917,912,201,537,414,147,961,910,96,196,735,748,1008,543,338,1067,311,70,148,900,16,717,1097,1102,767,835,827,828,1104,205,103,778,668,1138,1033,167,965,974,178,969,97,45,889,3,726,214,931,787,1068,955,729,1000,957,918,688,625,1073,943,671,953,785,358,2,841,1137,711,881,985,1061,21,861,987,61,920,1009,885,982,1012,226,13,895,676,720,940,1056,834,493,958,1130,1131,336,925,1099,1029,959,960,775,314,691,82,86,692,813,814,798,796,1046,1042,779,113,954,862,644,970,1144,1143,1139,967,762,839,806,690,152,792,859,76,1081,1084,693,988,68,689,695,1007,130,817,1080,696,310,49,95,48,101,924,1016,702,759,90,79,427,1146,108,682,1058,740,1025,411,812,1147,1005,77,78,755,20,1070,1094,715,515,146,1019,403,1001,34,1049,225,838,234,675,667,773,60,846,673,36,1105,713,64,552,115,643,255,181,265,151,180,254,1106,156,142,382,154,804,55,935,1107,84,927,1020,153,971,203,452,168,157,929,204,665,714,672,53,173,304,680,306,674,72,75,1031,371,824,163,107,176,831,934,32,198,199,701,932,253,39,628,207,986,175,190,169,259,191,165,264,161,462,62,141,37,171,195,164,269,166,1092,858,260,25,160,664,162,474,747,1122,230,145,1128,1101,38,1030,63,1069,419,57,41,179,182,408,1050,790,183,1103,150,194,727,933,197,756,187,823,158,712,1032,143,185,186,892,1132,59,1133,849,418,847,852,856,820,850,848,916,914,890,344,322,65,980,1034,679,627,66,1028,950,761,979,52,926,611,549,949,325,763,533,98,1063,660,942,100,243,337,1057,341,1024,46,138,754,903,678,362,343,803,91,415,94,73,661,17,613,1141,1140,1142,896,404,88,213,548,124,244,118,633,631,43,110,635,24,629,83,287,1083,504,1085,282,210,294,278,880,948,423,1006,295,819,1077,56,1078,317,335,1079,283,1086,434,1087,663,47,69,1091,281,74,833,296,99,50,1015,285,300,290,209,632,351,81,102,85,547,699,26,1095,87,853,1043,737,528,1041,1126,706,818,993,964,743,1072,868,938,442,946,909,908,793,1048,1027,1040,907,906,1038,945,1039,902,901,1037,905,1014,536,1035,904,1047,1036,1045,289,1026,705,733)
                 AND X.PERALIQUOTAST IN (18)
                 AND X.NROREGTRIBUTACAO IN (6,2,1,7,0)
                 AND X.UFEMPRESA = 'SP'
                 AND X.UFCLIENTEFORNEC = 'RJ'
                 AND X.TIPTRIBUTACAO IN ('SC'))

   LOOP
     BEGIN
       i := i+1;
       UPDATE CONSINCO.MAP_TRIBUTACAOUF Z SET Z.PERALIQUOTAST    = 20,
                                              Z.USUALTERACAO     = 'TKT367615'
                                        WHERE Z.NROTRIBUTACAO    = T.NROTRIBUTACAO
                                          AND Z.UFEMPRESA        = T.UFEMPRESA
                                          AND Z.UFCLIENTEFORNEC  = T.UFCLIENTEFORNEC
                                          AND Z.TIPTRIBUTACAO    = T.TIPTRIBUTACAO
                                          AND Z.NROREGTRIBUTACAO = T.NROREGTRIBUTACAO;
                                          
            IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;

   END;
   
-- Backup MRL_TRIBUTACAOPDV
   
CREATE TABLE CONSINCO.NAGT_MRL_TRIBUTACAOPDV_BKP AS
SELECT * FROM MRL_TRIBUTACAOPDV;
   
DECLARE
  i INTEGER := 0;
  
  BEGIN
  FOR t IN (SELECT * FROM CONSINCO.MRL_TRIBUTACAOPDV P 
             WHERE P.NROEMPRESA = 36 
               AND ALIQTRIBUTACAOPDV = 20 
               AND P.NROTRIBUTACAO IN (999,783,857,776,261,837,782,746,1004,704,1054,741,677,860,681,92,913,1066,963,136,1145,703,723,1098,966,799,891,989,911,67,42,30,279,31,1023,1003,10,1021,1082,728,984,268,977,240,1060,14,795,887,1055,1125,297,753,707,522,983,29,800,443,683,454,12,836,742,1065,884,1062,1096,794,19,878,700,939,758,9,730,716,822,801,732,722,854,15,886,998,870,981,731,821,447,781,872,1136,1100,1123,842,734,996,883,995,144,851,830,919,915,893,5,978,855,71,188,843,125,192,897,137,936,126,973,256,808,384,972,33,202,845,725,898,1124,263,340,899,840,750,44,28,149,968,894,826,437,719,117,917,912,201,537,414,147,961,910,96,196,735,748,1008,543,338,1067,311,70,148,900,16,717,1097,1102,767,835,827,828,1104,205,103,778,668,1138,1033,167,965,974,178,969,97,45,889,3,726,214,931,787,1068,955,729,1000,957,918,688,625,1073,943,671,953,785,358,2,841,1137,711,881,985,1061,21,861,987,61,920,1009,885,982,1012,226,13,895,676,720,940,1056,834,493,958,1130,1131,336,925,1099,1029,959,960,775,314,691,82,86,692,813,814,798,796,1046,1042,779,113,954,862,644,970,1144,1143,1139,967,762,839,806,690,152,792,859,76,1081,1084,693,988,68,689,695,1007,130,817,1080,696,310,49,95,48,101,924,1016,702,759,90,79,427,1146,108,682,1058,740,1025,411,812,1147,1005,77,78,755,20,1070,1094,715,515,146,1019,403,1001,34,1049,225,838,234,675,667,773,60,846,673,36,1105,713,64,552,115,643,255,181,265,151,180,254,1106,156,142,382,154,804,55,935,1107,84,927,1020,153,971,203,452,168,157,929,204,665,714,672,53,173,304,680,306,674,72,75,1031,371,824,163,107,176,831,934,32,198,199,701,932,253,39,628,207,986,175,190,169,259,191,165,264,161,462,62,141,37,171,195,164,269,166,1092,858,260,25,160,664,162,474,747,1122,230,145,1128,1101,38,1030,63,1069,419,57,41,179,182,408,1050,790,183,1103,150,194,727,933,197,756,187,823,158,712,1032,143,185,186,892,1132,59,1133,849,418,847,852,856,820,850,848,916,914,890,344,322,65,980,1034,679,627,66,1028,950,761,979,52,926,611,549,949,325,763,533,98,1063,660,942,100,243,337,1057,341,1024,46,138,754,903,678,362,343,803,91,415,94,73,661,17,613,1141,1140,1142,896,404,88,213,548,124,244,118,633,631,43,110,635,24,629,83,287,1083,504,1085,282,210,294,278,880,948,423,1006,295,819,1077,56,1078,317,335,1079,283,1086,434,1087,663,47,69,1091,281,74,833,296,99,50,1015,285,300,290,209,632,351,81,102,85,547,699,26,1095,87,853,1043,737,528,1041,1126,706,818,993,964,743,1072,868,938,442,946,909,908,793,1048,1027,1040,907,906,1038,945,1039,902,901,1037,905,1014,536,1035,904,1047,1036,1045,289,1026,705,733) 
            )
 LOOP
   BEGIN
     i := i+1;
     UPDATE CONSINCO.MRL_TRIBUTACAOPDV PDV SET PDV.ALIQTRIBUTACAOPDV = 22,
                                               PDV.USUALTERACAO   = 'TKT367615'
                                         WHERE PDV.NROTRIBUTACAO  = T.NROTRIBUTACAO
                                           AND PDV.NROEMPRESA     = T.NROEMPRESA
                                           AND PDV.TIPOTRIBUTACAO = T.TIPOTRIBUTACAO;
             IF i = 1000 THEN COMMIT;
            i := 0;
            END IF;
            
      END;
      END LOOP;
      
   COMMIT;

   END;                               
                                           
