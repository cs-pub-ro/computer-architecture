#include <iostream>

void FSM_ba() {  
  // FSM input: 0 - a, 1 - b, other - exit
  // FSM output: 0 - not found, 1 - found
  // FSM state: 0 - S0, 1 - Sa, 2 - Sb, 3 - SA
  int state = 0;
  int in, out;
  out = 0;
  in = 0;

  while(1) {
      switch(state) {
          case 0:
              out = 0;
              break;

          case 1:
              out = 0;
              break;

          case 2:
              out = 0;
              break;

          case 3:
              out = 1;
              break;
      }
    std::cout << "Output: " << out << std::endl;
      
    // Read input
    std::cout << "Please input a number (0 for a, 1 for b, other exit ): ";
    std::cin >> in;
    if (in > 1) {
        break;
    }

      switch(state) {
          case 0:
              if(in == 0)
                  state = 1;
              else
                  state = 2;
              break;

          case 1:
              if(in == 0)
                  state = 1;
              else
                  state = 2;
              break;

          case 2:
              if(in == 0)
                  state = 3;
              else
                  state = 2;
              break;

          case 3:
              if(in == 0)
                  state = 1;
              else
                  state = 2;
              break;
      }
  }
}

int main() {
    FSM_ba();
    return 0;
}