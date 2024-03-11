========================= DT_ITem

WITH PPOM_GROUP_FullName (grp_puid, grp_name, grp_level, prnt_id)
AS (
	SELECT 	  puid,  CAST(pname as nvarchar) as grp_name,  0,  rparentu
	FROM PPOM_GROUP WHERE rparentu='AAAAAAAAAAAAAA'
	UNION ALL
	SELECT   pg.puid,  CAST(CONCAT(CONCAT(pg.pname , '.'), pgt.grp_name) as nvarchar) as grp_name,
	  pgt.grp_level + 1,  pg.rparentu 	FROM PPOM_GROUP  pg, PPOM_GROUP_FullName  pgt
	WHERE pg.rparentu=pgt.grp_puid
),
 GetLatest_Stat_Date_LF (rev_puid,pname, pstart_date ,pdate_released) AS (
    SELECT T_RELLIST.puid, T_STS.pname,T_STS.pstart_date,T_STS.pdate_released FROM
    PRELEASE_STATUS_LIST T_RELLIST,
    PRELEASESTATUS T_STS,
    (
        SELECT T_RELLIST.puid AS REV_PUID, MAX(T_STS.pdate_released) AS LTS_REL_DATE
        FROM
        PRELEASE_STATUS_LIST T_RELLIST,
        PRELEASESTATUS T_STS
        WHERE 
        T_STS.puid=T_RELLIST.pvalu_0
        GROUP BY T_RELLIST.puid
    ) T_LTS_RELDATE
    WHERE
    T_STS.puid=T_RELLIST.pvalu_0
    AND T_RELLIST.puid=T_LTS_RELDATE.REV_PUID
    AND T_STS.pdate_released=T_LTS_RELDATE.LTS_REL_DATE
)
select 
item.pitem_id as Item_ID,itemRev.pitem_revision_id as ITEMREVISION
,uom.psymbol
,itemRevWKS.pobject_name
,itemRevWKS.pobject_type
,itemRevWKS.pobject_desc
,projWKS.pobject_name as PDS_PROJECT
,itemownUser.puser_id as [I_CREATED_BY]
,itemPoMApp.pcreation_date as [I_CREATION_DATE]
,itemlastModUser.puser_id as [I_LAST_MODIFIED_BY]
, itemPoMApp.plast_mod_date as [I_LAST_MODIFIED_DATE]
,custGrp.grp_name as  [R_OWNING_GROUP]
,projWKS.pdate_released as [R_RELEASE_DATE]

,dtform.pDT_Alternate_Part_Number
,dtform.pbwr3_re_business_group
,dtform.pbwr3_re_loc_design_site
,dtform.pbwr3_product_hierarchy
,dtform.pbwr3_base_model

,pmachrevf.pbwr3_make_buy
,pmachrevf.pbwr3_model_released_on
,pmachrevf.pbwr3_plant_code
,pmachrevf.pbwr3_reference_part_number
,pmachrevf.pbwr3_replaced_by
,pmachrevf.pbwr3_replaces
,pmachrevf.pbwr3_responsible_engineer
,pmachrevf.pbwr3_restricted_use_level
,pmachrevf.pbwr3_weight_uom
,pmachrevf.pDT_Weight
,pmachrevf.pDT_Change_Number

From PITEM item LEFT JOIN PUNITOFMEASURE uom ON uom.puid=item.puid

JOIN  PWORKSPACEOBJECT wo ON item.puid=wo.puid
JOIN  PIMANRELATION formiman ON item.puid = formiman.rprimary_objectu
LEFT JOIN  PFORM pf1  ON formiman.rsecondary_objectu = pf1.puid
LEFT JOIN  PDT_ITEM_MASTERFORM dtform ON pf1.rdata_fileu = dtform.puid

JOIN PITEMREVISION itemRev ON item.puid= itemRev.ritems_tagu
JOIN PWORKSPACEOBJECT itemRevWKS ON   itemRev.puid=itemRevWKS.puid
JOIN  PPOM_APPLICATION_OBJECT itemPoMApp ON itemRevWKS.puid = itemPoMApp.puid
JOIN  PPOM_USER itemownUser ON itemPoMApp.rowning_useru = itemownUser.puid
JOIN  PPOM_USER itemlastModUser ON itemPoMApp.rlast_mod_useru= itemlastModUser.puid
JOIN  PPOM_GROUP_FullName custGrp ON itemPoMApp.rowning_groupu= custGrp.grp_puid
LEFT OUTER JOIN GetLatest_Stat_Date_LF getStatus ON itemRev.puid=getStatus.rev_puid

JOIN  PIMANRELATION iman ON itemRev.puid = iman.rprimary_objectu
LEFT JOIN  PFORM pf  ON iman.rsecondary_objectu = pf.puid
LEFT JOIN  PDT_ITEM_MASTER_REV_FORM pmachrevf ON pf.rdata_fileu = pmachrevf.puid
JOIN PBWR3_PDS_PROJECT_NUMBER_14 pdsProject ON pdsProject.puid=pmachrevf.puid
JOIN PWORKSPACEOBJECT projWKS ON pdsProject.pvalu_0=projWKS.puid


where item.pitem_id like  '%09385239%'
