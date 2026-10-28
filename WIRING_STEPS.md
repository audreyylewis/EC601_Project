# Breadboard Wiring Guide: Testing the Hardware Interrupt

# Sprint 1: Intermittent Power Hardware Simulator

This guide outlines the physical breadboard setup required to simulate a stochastic energy harvester and measure the "death window" (the $\Delta t$ between the low-voltage interrupt and total system failure).

## Components Required
*   1x Breadboard
*   1x Toggle Switch
*   1x Electrolytic Capacitor (100µF to 1000µF recommended for baseline testing)
*   1x **220Ω Resistor** (Simulates the FPGA datapath load)
*   1x Potentiometer (e.g., 10kΩ for the voltage divider)
*   1x **AD8561 Ultrafast Comparator** 
*   Jumper wires
*   Oscilloscope (2-channel)

---

## Wiring Steps

### Step 1: Establish the Main Power Bus
1. Connect a `3.3V` pin from your Intel/Altera FPGA development board to the positive power rail of the breadboard.
2. Connect a `GND` pin from the FPGA to the ground rail of the breadboard. *(Critical: The analog circuit and digital FPGA must share this common ground).*

### Step 2: Build the Harvested Energy Circuit (The "Puddle")
1. Insert the toggle switch across the breadboard trench. Connect one side to the stable `3.3V` rail.
2. Connect the other side of the switch to a new, empty breadboard row. This row represents the **Declining Voltage Rail**.
3. Place the capacitor connecting the **Declining Voltage Rail** to `GND`.
4. Place the **220Ω resistor** in parallel with the capacitor, also connecting the **Declining Voltage Rail** to `GND`. 

### Step 3: Set the Interrupt Threshold (The Reference)
1. Insert the potentiometer. Connect its outer pins to the stable `3.3V` rail and `GND`.
2. Connect a multimeter to the middle wiper pin and `GND`. 
3. Adjust the potentiometer until it outputs exactly **2.8V** (or ~0.5V above your FPGA's minimum operating voltage). This wiper pin is your **Reference Voltage**.

### Step 4: Wire the AD8561 Comparator
*Note: The AD8561 is a push-pull comparator and does not require an external pull-up resistor.*
1. **Pin 3 (V+):** Connect to the stable `3.3V` rail.
2. **Pin 4 (V-):** Connect to `GND`.
3. **Pin 6 (GND):** Connect to `GND`.
4. **Pin 5 (LATCH):** Connect to `GND` to disable the latch and allow continuous tracking.
5. **Pin 2 (IN-):** Connect to the **Declining Voltage Rail** (the capacitor).
6. **Pin 1 (IN+):** Connect to the **Reference Voltage** (the potentiometer wiper).

### Step 5: The FPGA Connection & Measurement
1. Run a jumper wire directly from the AD8561's **Pin 7 (Q Output)** to the assigned GPIO interrupt pin on your FPGA. 
2. Hook Oscilloscope Channel 1 to the **Declining Voltage Rail**.
3. Hook Oscilloscope Channel 2 to the AD8561 **Pin 7 (Q Output)**.

## The Test Execution
Turn on the main power. The toggle switch acts as the ambient energy source. Flip the switch OFF to simulate a "passing shadow" or energy failure. Channel 2 on the oscilloscope will snap HIGH instantly as the voltage crosses your 2.8V reference, while Channel 1 will show the steep discharge curve dictated by your 220Ω resistor. The time between the interrupt firing and Channel 1 hitting the SRAM failure threshold is the hard physical deadline your SystemVerilog FSM must beat.
