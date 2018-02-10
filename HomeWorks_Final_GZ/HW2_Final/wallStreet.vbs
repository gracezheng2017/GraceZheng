Sub wall_street()

  
  Dim ticker As String
  Dim ticker_total As Double
  ticker_total = 0
  
  Dim sum_row_num As Integer
  sum_row_num = 2

  Dim lastrownum As long
  lastrownum = Range("A1").End(xlDown).Row

  
  For i = 2 To lastrownum

    ' Check if ticker change
    If Cells(i + 1, 1).Value <> Cells(i, 1).Value Then

      ' get ticker name
      ticker = Cells(i, 1).Value

      ' sum total
      ticker_total = ticker_total + Cells(i, 7).Value

      Range("I" & sum_row_num).Value = ticker
      Range("J" & sum_row_num).Value = ticker_total

      sum_row_num = sum_row_num + 1
      
      ticker_total = 0

    Else

      ticker_total = ticker_total + Cells(i,7).Value

    End If

  Next i

End Sub
