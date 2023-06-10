### The Overall circuitry for this project

Below is overall protoboard for this project
![board_circ_2](https://github.com/DimivanWell/Micro-Computers/assets/105472781/454c1c2a-b884-4eb0-aaa8-a0612302312e)


Utilizing basic circuitry, each color of the stop light present; Yellow, Green, and Red. These are given 1k resistors and there own pin on the micro-controller. Then is each of the pins for the seven segment display in order to parse through 9 to 0 at a ten second count for the yellow light. The pedestrian switch is given an interrupt and can be triggered any time inside the Green Light phase cutting short and jumping to yellow.

