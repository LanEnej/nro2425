#include <stdio.h>
#include <math.h>

// Če konstanta M_PI ni definirana, jo definiramo
#ifndef M_PI
#define M_PI 3.141592653589793
#endif

// Funkcija za približen izračun arctan(x) s Taylorjevim razvojem
double priblizekArctan(double vrednost, int steviloIteracij) {
    double vsota = 0.0;
    for (int i = 0; i < steviloIteracij; i++) {
        double clen = pow(-1, i) * pow(vrednost, 2 * i + 1) / (2 * i + 1);
        vsota += clen;
    }
    return vsota;
}

// Numerična integracija z uporabo trapezne metode
double trapeznaIntegracija(double (*funkcija)(double, int), double spodnjaMeja, double zgornjaMeja, int steviloPodintervalov, int steviloKorakov) {
    double korak = (zgornjaMeja - spodnjaMeja) / steviloPodintervalov;
    double integral = funkcija(spodnjaMeja, steviloKorakov) + funkcija(zgornjaMeja, steviloKorakov);

    for (int i = 1; i < steviloPodintervalov; i++) {
        double x = spodnjaMeja + i * korak;
        integral += 2 * funkcija(x, steviloKorakov);
    }

    return integral * korak / 2;
}

// Funkcija za izračun e^(3x) * arctan(x/2)
double izrazi(double x, int steviloKorakov) {
    double eksponentniDel = exp(3 * x);
    double arctanDel = priblizekArctan(x / 2, steviloKorakov);
    return eksponentniDel * arctanDel;
}

int main() {
    // Parametri za integracijo
    double spodnjaMeja = 0.0;
    double zgornjaMeja = M_PI / 4;
    int steviloPodintervalov = 1000;
    int steviloKorakov = 10;

    // Izračun integrala
    double vrednostIntegrala = trapeznaIntegracija(izrazi, spodnjaMeja, zgornjaMeja, steviloPodintervalov, steviloKorakov);

    // Izpis rezultata
    printf("Rezultat numerične integracije: %.15f\n", vrednostIntegrala);

    return 0;
}