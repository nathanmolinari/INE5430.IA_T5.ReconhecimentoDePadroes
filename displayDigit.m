function result = displayDigit(digitPixels, row)
%DISPLAYDIGITC Display 2D digit in a nice grid
%   result = displayDigit(digitPixels, row) displays 2D data
%   digitPixels = matrix com os pixels
%   row = coluna a qual se deseja imprimir o digito
  result = displayData(digitPixels(1:400, row:row));
end
