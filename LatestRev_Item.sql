============================Get latest Revision of item
select
item.pitem_id as [I_PARTNUMBER], 
itemRev.pitem_revision_id as [R_REVISION] 
  
from
PITEM item
JOIN (
    SELECT puid, A.pitem_revision_id, A.ritems_tagu, A.psequence_id
    FROM PITEMREVISION A
    JOIN
    (
        SELECT pitem_revision_id, ritems_tagu, MAX(psequence_id) rseq
        FROM PITEMREVISION
        GROUP BY pitem_revision_id, ritems_tagu
    ) B
    ON
    A.pitem_revision_id=B.pitem_revision_id
    AND A.ritems_tagu=B.ritems_tagu
    AND psequence_id=rseq
) itemRev ON item.puid = itemRev.ritems_tagu  and item.pitem_id IN ( '?')
JOIN  PITEMREVISION itemRevision ON itemRevision.puid = itemRev.puid
JOIN  PWORKSPACEOBJECT itemRevWks ON itemRev.puid = itemRevWks.puid
JOIN  PPOM_APPLICATION_OBJECT itemRevPOM ON itemRevWks.puid = itemRevPOM.puid

JOIN
				
(

select  MAX( d.pcreation_date ) as CreationDate
from PITEM a 
JOIN PITEMREVISION b ON a.puid=b.ritems_tagu and a.pitem_id IN ('?')
JOIN  PWORKSPACEOBJECT c ON b.puid = c.puid    
JOIN  PPOM_APPLICATION_OBJECT d ON c.puid = d.puid 
group by a.pitem_id 

) Emax ON Emax.CreationDate = itemRevPOM.pcreation_date
