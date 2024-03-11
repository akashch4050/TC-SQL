================================ get releated object when item as item & REVision
select  
itemPrmy.pitem_id as PRM_PART_ID, 
itemRevPrmy.pitem_revision_id as PRM_PART_REV,
itemRevWks.pobject_type as PRM_PART_TYPE,
itemSec.pitem_id as SEC_PART_ID, 
itemRevSec.pitem_revision_id as SEC_PART_REV,
secWKS.pobject_type as SEC_PART_TYPE,
relationType.ptype_name as RELATION 

from 
PITEM itemPrmy 
JOIN PITEMREVISION itemRevPrmy ON itemPrmy.puid = itemRevPrmy.ritems_tagu  and itemPrmy.pitem_id IN ('DNR0006195_EBOM') and itemRevPrmy.pitem_revision_id IN('A')
JOIN PWORKSPACEOBJECT itemRevWks ON  itemRevPrmy.puid = itemRevWks.puid
JOIN  PPOM_APPLICATION_OBJECT itemRevPOM ON itemRevWks.puid = itemRevPOM.puid
JOIN PIMANRELATION imanRelation ON itemRevPrmy.puid = imanRelation.rprimary_objectu 
JOIN PIMANTYPE relationType ON  imanRelation.rrelation_typeu= relationType.puid  and  relationType.ptype_name IN('IMAN_reference')
JOIN PITEMREVISION itemRevSec ON itemRevSec.puid= imanRelation.rsecondary_objectu
JOIN PWORKSPACEOBJECT secWKS ON  itemRevSec.puid = secWKS.puid
JOIN PITEM itemSec ON   itemRevSec.ritems_tagu = itemSec.puid  


UNION ALL
select   

itemPrmy.pitem_id as PRM_PART_ID, 
itemRevPrmy.pitem_revision_id as PRM_PART_REV,
itemRevWks.pobject_type as PRM_PART_TYPE,
itemSec.pitem_id as SEC_PART_ID,
NULL, 
secWKS.pobject_type as SEC_PART_TYPE,
relationType.ptype_name as RELATION

from 
PITEM itemPrmy 
JOIN PITEMREVISION itemRevPrmy ON itemPrmy.puid = itemRevPrmy.ritems_tagu  and itemPrmy.pitem_id IN('DNR0006195_EBOM') and itemRevPrmy.pitem_revision_id IN ('A')
JOIN PWORKSPACEOBJECT itemRevWks ON  itemRevPrmy.puid = itemRevWks.puid
JOIN  PPOM_APPLICATION_OBJECT itemRevPOM ON itemRevWks.puid = itemRevPOM.puid
JOIN PIMANRELATION imanRelation ON itemRevPrmy.puid = imanRelation.rprimary_objectu 
JOIN PIMANTYPE relationType ON  imanRelation.rrelation_typeu= relationType.puid  and  relationType.ptype_name IN('IMAN_reference')
JOIN PITEM itemSec ON itemSec.puid= imanRelation.rsecondary_objectu
JOIN PWORKSPACEOBJECT secWKS ON  itemSec.puid = secWKS.puid
