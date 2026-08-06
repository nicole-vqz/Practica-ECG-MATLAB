function [Yout] = cuantificador(Xin, Nbits)
    niveles = 2^Nbits;
    ancho_paso = 65536 / niveles;
        particion = ancho_paso : ancho_paso : (65536 - ancho_paso);
    
    Yout = quantiz(Xin, particion);
end