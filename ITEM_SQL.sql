tcDB.jdbc.ITEM_SQL=select top(1)  item.pitem_id as PARTNUMBER, wksObject.pobject_name as PARTNAME, wksObject.pobject_type as OBJECT_TYPE,  releaseStatus.pname as LIFECYCLESTATE , itemRev.pitem_revision_id as REVISION,  releaseStatus.pname as LIFECYCLESTATE , wksObject.pobject_name as NOMENCLATURE , wksObject.pobject_type as DISPLAYEDTYPE , wksObject.pobject_type as CLASS  from  PITEM item  JOIN  ( SELECT puid, A.pitem_revision_id, A.ritems_tagu, A.psequence_id FROM PITEMREVISION A  JOIN  ( SELECT pitem_revision_id, ritems_tagu, MAX(psequence_id) rseq  FROM PITEMREVISION GROUP BY pitem_revision_id, ritems_tagu ) B ON A.pitem_revision_id=B.pitem_revision_id AND A.ritems_tagu=B.ritems_tagu AND psequence_id=rseq  ) itemRev ON item.puid = itemRev.ritems_tagu   JOIN  PWORKSPACEOBJECT wksObject ON itemRev.puid = wksObject.puid    JOIN  PPOM_APPLICATION_OBJECT pomAPPObject ON wksObject.puid = pomAPPObject.puid  JOIN  PPOM_USER ownUser ON pomAPPObject.rowning_useru = ownUser.puid   JOIN  PPOM_USER lastModUser ON pomAPPObject.rlast_mod_useru= lastModUser.puid  Left join PRELEASE_STATUS_LIST releaseStatusList on releaseStatusList.puid = itemRev.puid  Left join PRELEASESTATUS releaseStatus on releaseStatus.puid = releaseStatusList.pvalu_0 where item.pitem_id IN ('?') order by  REVISION desc 

