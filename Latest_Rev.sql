select distinct itemPrmy.pitem_id 
,itemRevPrmy.pitem_revision_id
,itemRevWks.pobject_type
From 
PITEM itemPrmy 
JOIN PITEMREVISION itemRevPrmy ON itemPrmy.puid = itemRevPrmy.ritems_tagu  and itemPrmy.pitem_id IN('DK230815_EBOM')
JOIN PWORKSPACEOBJECT itemRevWks ON  itemRevPrmy.puid = itemRevWks.puid
JOIN  PPOM_APPLICATION_OBJECT itemRevPOM ON itemRevWks.puid = itemRevPOM.puid
JOIN
				
(

select  MAX( d.pcreation_date ) as CreationDate
from PITEM a 
JOIN PITEMREVISION b ON a.puid=b.ritems_tagu and a.pitem_id IN ('DK230815_EBOM')
JOIN  PWORKSPACEOBJECT c ON b.puid = c.puid    
JOIN  PPOM_APPLICATION_OBJECT d ON c.puid = d.puid 
group by a.pitem_id 

) Emax ON Emax.CreationDate = itemRevPOM.pcreation_date
