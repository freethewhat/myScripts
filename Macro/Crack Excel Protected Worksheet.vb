Sub CrackPassword()
 
 
  Dim v1 As Integer, u1 As Integer, w1 As Integer
  Dim v2 As Integer, u2 As Integer, w2 As Integer
  Dim v3 As Integer, u3 As Integer, w3 As Integer
  Dim v4 As Integer, u4 As Integer, w4 As Integer
  On Error Resume Next
 
  For v1 = 65 To 66: For u1 = 65 To 66: For w1 = 65 To 66
  For v2 = 65 To 66: For u2 = 65 To 66: For w2 = 65 To 66
  For v3 = 65 To 66: For u3 = 65 To 66: For w3 = 65 To 66
  For v4 = 65 To 66: For u4 = 65 To 66: For w4 = 32 To 126
    
       
 ActiveSheet.Unprotect Chr(v1) & Chr(u1) & Chr(w1) & _
      Chr(v2) & Chr(u2) & Chr(v3) & Chr(u3) & Chr(w3) & _
      Chr(v4) & Chr(u4) & Chr(w4) & Chr(w2)
 
    
  Next: Next: Next: Next: Next: Next
  Next: Next: Next: Next: Next: Next

End Sub