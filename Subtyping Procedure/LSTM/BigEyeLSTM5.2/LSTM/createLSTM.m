function [para] = createLSTM(xSize,hSize)
para.Woigf = rand(xSize + hSize,hSize) * 0.02 - 0.01;

end