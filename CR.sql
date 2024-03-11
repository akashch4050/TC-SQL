

========================= PDS CR
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
item.pitem_id as [I_PARTNUMBER], 
itemRev.pitem_revision_id as [R_REVISION] 
,uom.punit as [I_UOM_TAG]
,wksObject.pobject_name as R_PARTNAME, 
wksObject.pobject_desc as R_OBJECT_DESC,
wksObject.pobject_type as [R_OBJECT_TYPE],
ownUser.puser_id as [R_CREATED_BY], 
pomAPPObject.pcreation_date as [R_CREATION_DATE],
lastModUser.puser_id as [R_LAST_MODIFIED_BY],
pomAPPObject.plast_mod_date as [R_LAST_MODIFIED_DATE]
,custGrp.grp_name as  [R_OWNING_GROUP]
,wksObject.pdate_released as [R_RELEASE_DATE]
,getStatus.pname as [R_LIFECYCLE_STATE]
,pdscr.pbwr3_enggchangecoordinator
,pdscr.pbwr3_champion
,changereq.pCMIsFastTrack
,pchange.pCMDisposition 

   
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
) itemRev ON item.puid = itemRev.ritems_tagu 
JOIN  PITEMREVISION itemRevision ON itemRevision.puid = itemRev.puid
JOIN PBWR3_PDS_CRREVISION pdscr ON  pdscr.puid=itemRev.puid
JOIN  PCHANGEITEMREVISION pchange ON itemRevision.puid = pchange.puid
JOIN PGNCHANGEREQUESTREVISION changereq ON changereq.puid=  pchange.puid
LEFT JOIN  PUNITOFMEASURE uom ON item.ruom_tagu= uom.puid
JOIN  PWORKSPACEOBJECT wksObject ON itemRev.puid = wksObject.puid 
JOIN  PPOM_APPLICATION_OBJECT pomAPPObject ON wksObject.puid = pomAPPObject.puid
JOIN  PPOM_USER ownUser ON pomAPPObject.rowning_useru = ownUser.puid
JOIN  PPOM_USER lastModUser ON pomAPPObject.rlast_mod_useru= lastModUser.puid
JOIN  PPOM_GROUP_FullName custGrp ON pomAPPObject.rowning_groupu= custGrp.grp_puid
LEFT OUTER JOIN GetLatest_Stat_Date_LF getStatus ON itemRev.puid=getStatus.rev_puid

where item.pitem_id like '20%'
