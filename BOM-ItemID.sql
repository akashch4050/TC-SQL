====================BOM input as item_id --
SELECT distinct T_PRT_ITEM.pitem_id as PARENT_ITEMID ,
T_PRT_REV.pitem_revision_id as PARENT_REVISION,
child.pitem_id as CHILD_ITEMID ,

T_PSOCC.pqty_value as QUATNTITY,
T_PSOCC.pseq_no as FINDNO,
notetext.pval_0 as P4BOMUSAGE


FROM PITEM T_PRT_ITEM 
join PITEMREVISION T_PRT_REV on T_PRT_REV.ritems_tagu =T_PRT_ITEM.puid  and T_PRT_ITEM.pitem_id IN (?)
JOIN  PWORKSPACEOBJECT itemwks ON T_PRT_REV.puid = itemwks.puid    
JOIN  PPOM_APPLICATION_OBJECT itemPOM ON itemwks.puid = itemPOM.puid
Join (
select 
MAX( d.pcreation_date ) as CreationDate
from PITEM a 
JOIN PITEMREVISION b ON a.puid=b.ritems_tagu and a.pitem_id IN (?)
JOIN  PWORKSPACEOBJECT c ON b.puid = c.puid    
JOIN  PPOM_APPLICATION_OBJECT d ON c.puid = d.puid 
group by a.pitem_id 

) itemMax ON itemMax.CreationDate = itemPOM.pcreation_date

join PSTRUCTURE_REVISIONS T_STR_REV on T_STR_REV.puid =T_PRT_REV.puid 
join PPSBOMVIEWREVISION T_BVR on T_BVR.puid =T_STR_REV.pvalu_0 
join PPSOCCURRENCE T_PSOCC on T_PSOCC.rparent_bvru =T_BVR.puid 
LEFT join PNOTE_TEXTS notetext ON  T_PSOCC.rnotes_refu =notetext.puid 
join PITEM child ON T_PSOCC.rchild_itemu=child.puid 
