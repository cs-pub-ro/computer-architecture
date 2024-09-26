#include <iostream>

void FSM_intersectie() {
    int state = 0; // FSM state: 0 - N/S_verde, 1 - N/S_galben, 2 - N/S_rosu, 3 - E/W_galben
    int N_rosu;
    int N_galben;
    int N_verde;
    int S_rosu;
    int S_galben;
    int S_verde;
    int W_rosu;
    int W_galben;
    int W_verde;
    int E_rosu;
    int E_galben;
    int E_verde;
    int done;
    int T;
    done = 0;
    T = 0;

    while(1) {
        N_rosu = 0;
        N_galben = 0;
        N_verde = 0;
        S_rosu = 0;
        S_galben = 0;
        S_verde = 0;
        W_rosu = 0;
        W_galben = 0;
        W_verde = 0;
        E_rosu = 0;
        E_galben = 0;
        E_verde = 0;
        switch(state) {
            case 0:
                E_rosu = 1;
                W_rosu = 1;
                N_verde = 1;
                S_verde = 1;
                T = 50;
                if(done == 1)
                    state = 1;
                else
                    state = 0;
                break;
            case 1:
                N_galben = 1;
                S_galben = 1;
                E_rosu = 1;
                W_rosu = 1;
                T = 10;
                if(done == 1)
                    state = 2;
                else
                    state = 1;
                break;
            case 2:
                N_rosu = 1;
                S_rosu = 1;
                E_verde = 1;
                W_verde = 1;
                T = 30;
                if(done == 1)
                    state = 3;
                else
                    state = 2;
                break;
            case 3:
                N_rosu = 1;
                S_rosu = 1;
                E_galben = 1;
                W_galben = 1;
                T = 10;
                if(done == 1)
                    state = 0;
                else
                    state = 3;
                break;
        }

        std::cout << "Stare: " << state << std::endl;
        std::cout << "Done: " << done << std::endl;
        std::cout << "N: " << N_rosu << N_galben << N_verde << std::endl;
        std::cout << "S: " << S_rosu << S_galben << S_verde << std::endl;
        std::cout << "W: " << W_rosu << W_galben << W_verde << std::endl;
        std::cout << "E: " << E_rosu << E_galben << E_verde << std::endl;
        std::cout << "Timp: " << T << std::endl;
        std::cin >> done;
        if (done > 1) {
            break;
        }
    }
}

int main() {
    FSM_intersectie();
    return 0;
}