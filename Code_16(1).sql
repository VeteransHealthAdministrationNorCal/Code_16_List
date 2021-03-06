SELECT --DISTINCT 
  SPatient.PatientSSN,
  SPatient.PatientName,
  RadExam.ExamDateTime

FROM
  LSV.BISL_R1VX.AR3Y_SPatient_SPatient AS SPatient
  
  INNER JOIN LSV.Rad.RadiologyExam AS RadExam
    ON SPatient.PatientSID = RadExam.PatientSID
	AND SPatient.Sta3n = RadExam.Sta3n  
  LEFT JOIN LSV.Rad.RadiologyExamSecondaryDiagnosticCode AS RadExam2
    ON RadExam.RadiologyExamSID = RadExam2.RadiologyExamSID

  INNER JOIN LSV.Dim.RadiologyProcedure AS DimProcedure
    ON RadExam.RadiologyProcedureSID = DimProcedure.RadiologyProcedureSID

  LEFT JOIN LSV.Dim.RadiologyDiagnosticCode AS DimCode
    ON RadExam.RadiologyDiagnosticCodeSID = DimCode.RadiologyDiagnosticCodeSID

WHERE
  SPatient.Sta3n = '612'
  AND CAST(RadExam.ExamDateTime AS date) BETWEEN DATEADD(month, -1, GETDATE()) AND GETDATE()
  AND (RadExam.RadiologyDiagnosticCodeSID in (
    '800000985',	--CHEST X-RAY F/U NEEDED
    '800000996',		--POSSIBLE MALIGNANCY, FOLLOW-UP NEEDED
    '800000946')	--POSSIBLE MALIGNANCY *NULL Description
	OR RadExam2.RadiologyDiagnosticCodeSID in (
    '800000985',	--CHEST X-RAY F/U NEEDED
    '800000996',		--POSSIBLE MALIGNANCY, FOLLOW-UP NEEDED
    '800000946')	--POSSIBLE MALIGNANCY *NULL Description
  )

GROUP BY
  SPatient.PatientSSN,
  SPatient.PatientName,
  RadExam.ExamDateTime

ORDER BY
  RadExam.ExamDateTime,
  SPatient.PatientName,
  SPatient.PatientSSN